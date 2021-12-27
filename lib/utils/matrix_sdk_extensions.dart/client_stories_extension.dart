//@dart=2.12

import 'package:flutter/cupertino.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:matrix/matrix.dart';

extension ClientStoriesExtension on Client {
  static const String storiesRoomType = 'msc3588.stories.stories-room';
  static const String storiesBlockListType = 'msc3588.stories.block-list';

  static const int lifeTimeInHours = 24;
  static const int maxPostsPerStory = 20;

  List<User> get contacts => rooms
      .where((room) => room.isDirectChat)
      .map((room) => room.getUserByMXIDSync(room.directChatMatrixID!))
      .toList();

  List<Room> get storiesRooms => rooms
      .where((room) =>
          room
              .getState(EventTypes.RoomCreate)
              ?.content
              .tryGet<String>('type') ==
          storiesRoomType)
      .toList();

  Future<List<User>> getUndecidedContactsForStories(Room? storiesRoom) async {
    if (storiesRoom == null) return contacts;
    final invitedContacts =
        (await storiesRoom.requestParticipants()).map((user) => user.id);
    final decidedContacts = storiesBlockList.toSet()..addAll(invitedContacts);
    return contacts
        .where((contact) => !decidedContacts.contains(contact.id))
        .toList();
  }

  List<String> get storiesBlockList =>
      accountData[storiesBlockListType]?.content.tryGetList<String>('users') ??
      [];

  Future<void> setStoriesBlockList(List<String> users) => setAccountData(
        userID!,
        storiesBlockListType,
        {'users': users},
      );

  Future<Room> createStoriesRoom([List<String>? invite]) async {
    final roomId = await createRoom(
      creationContent: {"type": "msc3588.stories.stories-room"},
      preset: CreateRoomPreset.privateChat,
      powerLevelContentOverride: {"events_default": 100},
      name: 'Stories from ${userID!.localpart}',
      initialState: [
        StateEvent(
          type: EventTypes.Encryption,
          stateKey: '',
          content: {
            'algorithm': 'm.megolm.v1.aes-sha2',
          },
        ),
      ],
      invite: invite,
    );
    if (getRoomById(roomId) == null) {
      // Wait for room actually appears in sync
      await onSync.stream
          .firstWhere((sync) => sync.rooms?.join?.containsKey(roomId) ?? false);
    }
    return getRoomById(roomId)!;
  }

  Future<Room?> getStoriesRoom(BuildContext context) async {
    final candidates = rooms.where((room) =>
        room.getState(EventTypes.RoomCreate)?.content.tryGet<String>('type') ==
            storiesRoomType &&
        room.ownPowerLevel >= 100);
    if (candidates.isEmpty) return null;
    if (candidates.length == 1) return candidates.single;
    return await showModalActionSheet<Room>(
        context: context,
        actions: candidates
            .map(
              (room) => SheetAction(label: room.displayname, key: room),
            )
            .toList());
  }
}
