import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pages/chat_list/search_title.dart';
import 'package:fluffychat/widgets/avatar.dart';
import '../../utils/localized_exception_extension.dart';
import '../../widgets/matrix.dart';

class SpaceView extends StatefulWidget {
  final ChatListController controller;
  final ScrollController scrollController;
  const SpaceView(
    this.controller, {
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<SpaceView> createState() => _SpaceViewState();
}

class _SpaceViewState extends State<SpaceView> {
  static final Map<String, Future<GetSpaceHierarchyResponse>> _requests = {};

  void _refresh() {
    setState(() {
      _requests.remove(widget.controller.activeSpaceId);
    });
  }

  Future<GetSpaceHierarchyResponse> getFuture(String activeSpaceId) =>
      _requests[activeSpaceId] ??=
          Matrix.of(context).client.getSpaceHierarchy(activeSpaceId);

  void _onJoinSpaceChild(SpaceRoomsChunk spaceChild) async {
    final client = Matrix.of(context).client;
    final space = client.getRoomById(widget.controller.activeSpaceId!);
    if (client.getRoomById(spaceChild.roomId) == null) {
      final result = await showFutureLoadingDialog(
        context: context,
        future: () async {
          await client.joinRoom(spaceChild.roomId,
              serverName: space?.spaceChildren
                  .firstWhereOrNull(
                      (child) => child.roomId == spaceChild.roomId)
                  ?.via);
          if (client.getRoomById(spaceChild.roomId) == null) {
            // Wait for room actually appears in sync
            await client.waitForRoomInSync(spaceChild.roomId, join: true);
          }
        },
      );
      if (result.error != null) return;
      _refresh();
    }
    if (spaceChild.roomType == 'm.space') {
      if (spaceChild.roomId == widget.controller.activeSpaceId) {
        VRouter.of(context).toSegments(['spaces', spaceChild.roomId]);
      } else {
        widget.controller.setActiveSpace(spaceChild.roomId);
      }
      return;
    }
    VRouter.of(context).toSegments(['rooms', spaceChild.roomId]);
  }

  void _onSpaceChildContextMenu(
      [SpaceRoomsChunk? spaceChild, Room? room]) async {
    final client = Matrix.of(context).client;
    final activeSpaceId = widget.controller.activeSpaceId;
    final activeSpace =
        activeSpaceId == null ? null : client.getRoomById(activeSpaceId);
    final action = await showModalActionSheet<SpaceChildContextAction>(
      context: context,
      title: spaceChild?.name ?? room?.displayname,
      message: spaceChild?.topic ?? room?.topic,
      actions: [
        if (room == null)
          SheetAction(
            key: SpaceChildContextAction.join,
            label: L10n.of(context)!.joinRoom,
            icon: Icons.send_outlined,
          ),
        if (spaceChild != null && (activeSpace?.canSendDefaultStates ?? false))
          SheetAction(
            key: SpaceChildContextAction.removeFromSpace,
            label: L10n.of(context)!.removeFromSpace,
            icon: Icons.delete_sweep_outlined,
          ),
        if (room != null)
          SheetAction(
            key: SpaceChildContextAction.leave,
            label: L10n.of(context)!.leave,
            icon: Icons.delete_outlined,
            isDestructiveAction: true,
          ),
      ],
    );
    if (action == null) return;

    switch (action) {
      case SpaceChildContextAction.join:
        _onJoinSpaceChild(spaceChild!);
        break;
      case SpaceChildContextAction.leave:
        await showFutureLoadingDialog(
          context: context,
          future: room!.leave,
        );
        break;
      case SpaceChildContextAction.removeFromSpace:
        await showFutureLoadingDialog(
          context: context,
          future: () => activeSpace!.removeSpaceChild(spaceChild!.roomId),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    final activeSpaceId = widget.controller.activeSpaceId;
    final allSpaces = client.rooms.where((room) => room.isSpace);
    if (activeSpaceId == null) {
      final rootSpaces = allSpaces
          .where(
            (space) => !allSpaces.any(
              (parentSpace) => parentSpace.spaceChildren
                  .any((child) => child.roomId == space.id),
            ),
          )
          .toList();

      return ListView.builder(
        itemCount: rootSpaces.length,
        controller: widget.scrollController,
        itemBuilder: (context, i) => ListTile(
          leading: Avatar(
            mxContent: rootSpaces[i].avatar,
            name: rootSpaces[i].displayname,
          ),
          title: Text(
            rootSpaces[i].displayname,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text('${rootSpaces[i].spaceChildren.length} Chats'),
          onTap: () => widget.controller.setActiveSpace(rootSpaces[i].id),
          onLongPress: () => _onSpaceChildContextMenu(null, rootSpaces[i]),
          trailing: const Icon(Icons.chevron_right_outlined),
        ),
      );
    }
    return FutureBuilder<GetSpaceHierarchyResponse>(
        future: getFuture(activeSpaceId),
        builder: (context, snapshot) {
          final response = snapshot.data;
          final error = snapshot.error;
          if (error != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(error.toLocalizedString(context)),
                ),
                IconButton(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh_outlined),
                )
              ],
            );
          }
          if (response == null) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          final parentSpace = allSpaces.firstWhereOrNull((space) => space
              .spaceChildren
              .any((child) => child.roomId == activeSpaceId));
          return ListView.builder(
              itemCount: response.rooms.length + 1,
              controller: widget.scrollController,
              itemBuilder: (context, i) {
                if (i == 0) {
                  return ListTile(
                    leading: BackButton(
                      onPressed: () =>
                          widget.controller.setActiveSpace(parentSpace?.id),
                    ),
                    title: Text(parentSpace == null
                        ? L10n.of(context)!.allSpaces
                        : parentSpace.displayname),
                    trailing: IconButton(
                      icon: snapshot.connectionState != ConnectionState.done
                          ? const CircularProgressIndicator.adaptive()
                          : const Icon(Icons.refresh_outlined),
                      onPressed:
                          snapshot.connectionState != ConnectionState.done
                              ? null
                              : _refresh,
                    ),
                  );
                }
                i--;
                final spaceChild = response.rooms[i];
                final room = client.getRoomById(spaceChild.roomId);
                if (room != null && !room.isSpace) {
                  return ChatListItem(
                    room,
                    onLongPress: () =>
                        _onSpaceChildContextMenu(spaceChild, room),
                    activeChat: widget.controller.activeChat == room.id,
                  );
                }
                final isSpace = spaceChild.roomType == 'm.space';
                final topic =
                    spaceChild.topic?.isEmpty ?? true ? null : spaceChild.topic;
                if (spaceChild.roomId == activeSpaceId) {
                  return SearchTitle(
                    title:
                        spaceChild.name ?? spaceChild.canonicalAlias ?? 'Space',
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Avatar(
                        size: 24,
                        mxContent: spaceChild.avatarUrl,
                        name: spaceChild.name,
                        fontSize: 9,
                      ),
                    ),
                    color: Theme.of(context)
                        .colorScheme
                        .secondaryContainer
                        .withAlpha(128),
                    trailing: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Icon(Icons.edit_outlined),
                    ),
                    onTap: () => _onJoinSpaceChild(spaceChild),
                  );
                }
                return ListTile(
                  leading: Avatar(
                    mxContent: spaceChild.avatarUrl,
                    name: spaceChild.name,
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          spaceChild.name ??
                              spaceChild.canonicalAlias ??
                              L10n.of(context)!.chat,
                          maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (!isSpace) ...[
                        const Icon(
                          Icons.people_outline,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          spaceChild.numJoinedMembers.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                  onTap: () => _onJoinSpaceChild(spaceChild),
                  onLongPress: () => _onSpaceChildContextMenu(spaceChild, room),
                  subtitle: Text(
                    topic ??
                        (isSpace
                            ? L10n.of(context)!.enterSpace
                            : L10n.of(context)!.enterRoom),
                    maxLines: 1,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  trailing:
                      isSpace ? const Icon(Icons.chevron_right_outlined) : null,
                );
              });
        });
  }
}

enum SpaceChildContextAction {
  join,
  leave,
  removeFromSpace,
}
