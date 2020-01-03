import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/chat_settings_popup_menu.dart';
import 'package:fluffychat/components/content_banner.dart';
import 'package:fluffychat/components/list_items/participant_list_item.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat_list.dart';
import 'package:fluffychat/views/invitation_selection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class ChatDetails extends StatefulWidget {
  final Room room;

  const ChatDetails(this.room);

  @override
  _ChatDetailsState createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  List<User> members;
  void setDisplaynameAction(BuildContext context, String displayname) async {
    final MatrixState matrix = Matrix.of(context);
    final Map<String, dynamic> success =
        await matrix.tryRequestWithLoadingDialog(
      widget.room.setName(displayname),
    );
    if (success != null && success.isEmpty) {
      Toast.show(
        "Displayname has been changed",
        context,
        duration: Toast.LENGTH_LONG,
      );
    }
  }

  void setAvatarAction(BuildContext context) async {
    final File tempFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 1600,
        maxHeight: 1600);
    if (tempFile == null) return;
    final MatrixState matrix = Matrix.of(context);
    final Map<String, dynamic> success =
        await matrix.tryRequestWithLoadingDialog(
      widget.room.setAvatar(
        MatrixFile(
          bytes: await tempFile.readAsBytes(),
          path: tempFile.path,
        ),
      ),
    );
    if (success != null && success.isEmpty) {
      Toast.show(
        "Avatar has been changed",
        context,
        duration: Toast.LENGTH_LONG,
      );
    }
  }

  void requestMoreMembersAction(BuildContext context) async {
    final List<User> participants = await Matrix.of(context)
        .tryRequestWithLoadingDialog(widget.room.requestParticipants());
    if (participants != null) setState(() => members = participants);
  }

  @override
  Widget build(BuildContext context) {
    members ??= widget.room.getParticipants();
    final int actualMembersCount =
        widget.room.mInvitedMemberCount + widget.room.mJoinedMemberCount;
    final bool canRequestMoreMembers = members.length < actualMembersCount;
    widget.room.onUpdate = () => setState(() => members = null);
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(
        activeChat: widget.room.id,
      ),
      secondScaffold: Scaffold(
        appBar: AppBar(
          title: Text(widget.room.displayname),
          actions: <Widget>[ChatSettingsPopupMenu(widget.room, false)],
        ),
        body: ListView.builder(
          itemCount: members.length + 1 + (canRequestMoreMembers ? 1 : 0),
          itemBuilder: (BuildContext context, int i) => i == 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ContentBanner(widget.room.avatar),
                    widget.room.canSendEvent("m.room.avatar") && !kIsWeb
                        ? ListTile(
                            title: Text("Edit group avatar"),
                            trailing: Icon(Icons.file_upload),
                            onTap: () => setAvatarAction(context),
                          )
                        : Container(),
                    widget.room.canSendEvent("m.room.name")
                        ? ListTile(
                            trailing: Icon(Icons.edit),
                            title: TextField(
                              textInputAction: TextInputAction.done,
                              onSubmitted: (s) =>
                                  setDisplaynameAction(context, s),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Edit group name",
                                labelStyle: TextStyle(color: Colors.black),
                                hintText: (widget.room.displayname),
                              ),
                            ),
                          )
                        : Container(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              height: 8,
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "$actualMembersCount participant(s)",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                              height: 8,
                              color: Theme.of(context).secondaryHeaderColor),
                        ),
                      ],
                    ),
                    widget.room.canInvite
                        ? ListTile(
                            title: Text("Invite contact"),
                            leading: Icon(Icons.add),
                            onTap: () => Navigator.of(context).push(
                              AppRoute.defaultRoute(
                                context,
                                InvitationSelection(widget.room),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                )
              : i < members.length + 1
                  ? ParticipantListItem(members[i - 1])
                  : ListTile(
                      title: Text(
                          "Load more ${actualMembersCount - members.length} participants"),
                      leading: Icon(Icons.refresh),
                      onTap: () => requestMoreMembersAction(context),
                    ),
        ),
      ),
    );
  }
}
