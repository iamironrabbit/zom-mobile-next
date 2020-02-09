import 'dart:async';
import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/chat_settings_popup_menu.dart';
import 'package:fluffychat/components/dialogs/confirm_dialog.dart';
import 'package:fluffychat/components/list_items/message.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/event_extension.dart';
import 'package:fluffychat/utils/room_extension.dart';
import 'package:fluffychat/views/chat_encryption_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:pedantic/pedantic.dart';

import 'chat_list.dart';

class ChatView extends StatelessWidget {
  final String id;

  const ChatView(this.id, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(
        activeChat: id,
      ),
      secondScaffold: _Chat(id),
    );
  }
}

class _Chat extends StatefulWidget {
  final String id;

  const _Chat(this.id, {Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<_Chat> {
  Room room;

  Timeline timeline;

  MatrixState matrix;

  String seenByText = "";

  final ScrollController _scrollController = ScrollController();

  FocusNode inputFocus = FocusNode();

  Timer typingCoolDown;
  Timer typingTimeout;
  bool currentlyTyping = false;

  Set<Event> selectedEvents = {};

  Event replyEvent;

  bool get selectMode => selectedEvents.isNotEmpty;

  @override
  void initState() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          timeline.events.isNotEmpty &&
          timeline.events[timeline.events.length - 1].type !=
              EventTypes.RoomCreate) {
        await timeline.requestHistory(historyCount: 100);
      }
    });

    super.initState();
  }

  void updateView() {
    if (!mounted) return;

    String seenByText = "";
    if (timeline.events.isNotEmpty) {
      List lastReceipts = List.from(timeline.events.first.receipts);
      lastReceipts.removeWhere((r) =>
          r.user.id == room.client.userID ||
          r.user.id == timeline.events.first.senderId);
      if (lastReceipts.length == 1) {
        seenByText = I18n.of(context)
            .seenByUser(lastReceipts.first.user.calcDisplayname());
      } else if (lastReceipts.length == 2) {
        seenByText = seenByText = I18n.of(context).seenByUserAndUser(
            lastReceipts.first.user.calcDisplayname(),
            lastReceipts[1].user.calcDisplayname());
      } else if (lastReceipts.length > 2) {
        seenByText = I18n.of(context).seenByUserAndCountOthers(
            lastReceipts.first.user.calcDisplayname(),
            (lastReceipts.length - 1).toString());
      }
    }
    if (timeline != null) {
      setState(() {
        this.seenByText = seenByText;
      });
    }
  }

  Future<bool> getTimeline() async {
    if (timeline == null) {
      timeline = await room.getTimeline(onUpdate: updateView);
      if (timeline.events.isNotEmpty) {
        unawaited(room.sendReadReceipt(timeline.events.first.eventId));
      }
    }
    updateView();
    return true;
  }

  @override
  void dispose() {
    timeline?.sub?.cancel();
    timeline = null;
    matrix.activeRoomId = "";
    super.dispose();
  }

  TextEditingController sendController = TextEditingController();

  void send() {
    if (sendController.text.isEmpty) return;
    Map<String, dynamic> textContent = {
      "msgtype": "m.text",
      "body": sendController.text,
    };
    if (replyEvent != null) {
      String replyText = ("<${room.client.userID}> " + replyEvent.body);
      List<String> replyTextLines = replyText.split("\n");
      for (int i = 0; i < replyTextLines.length; i++) {
        replyTextLines[i] = "> " + replyTextLines[i];
      }
      replyText = replyTextLines.join("\n");
      textContent["body"] = replyText + "\n\n${sendController.text}";
      textContent["m.relates_to"] = {
        "m.in_reply_to": {
          "event_id": replyEvent.eventId,
        },
      };
      setState(() => replyEvent = null);
    }
    room.sendEvent(textContent);
    sendController.text = "";
  }

  void sendFileAction(BuildContext context) async {
    if (kIsWeb) {
      return Toast.show(I18n.of(context).notSupportedInWeb, context);
    }
    File file = await FilePicker.getFile();
    if (file == null) return;
    await matrix.tryRequestWithLoadingDialog(
      room.sendFileEvent(
        MatrixFile(bytes: await file.readAsBytes(), path: file.path),
      ),
    );
  }

  void sendImageAction(BuildContext context) async {
    if (kIsWeb) {
      return Toast.show(I18n.of(context).notSupportedInWeb, context);
    }
    File file = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 1600,
        maxHeight: 1600);
    if (file == null) return;
    await matrix.tryRequestWithLoadingDialog(
      room.sendImageEvent(
        MatrixFile(bytes: await file.readAsBytes(), path: file.path),
      ),
    );
  }

  void openCameraAction(BuildContext context) async {
    if (kIsWeb) {
      return Toast.show(I18n.of(context).notSupportedInWeb, context);
    }
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 1600,
        maxHeight: 1600);
    if (file == null) return;
    await matrix.tryRequestWithLoadingDialog(
      room.sendImageEvent(
        MatrixFile(bytes: await file.readAsBytes(), path: file.path),
      ),
    );
  }

  String _getSelectedEventString(BuildContext context) {
    String copyString = "";
    for (Event event in selectedEvents) {
      if (copyString.isNotEmpty) copyString += "\n\n";
      copyString += event.getLocalizedBody(context, withSenderNamePrefix: true);
    }
    return copyString;
  }

  void copyEventsAction(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _getSelectedEventString(context)));
    setState(() => selectedEvents.clear());
  }

  void redactEventsAction(BuildContext context) async {
    bool confirmed = false;
    await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
          I18n.of(context).messageWillBeRemovedWarning,
          I18n.of(context).remove,
          (c) => confirmed = true),
    );
    if (!confirmed) return;
    for (Event event in selectedEvents) {
      await Matrix.of(context).tryRequestWithLoadingDialog(
          event.status > 0 ? event.redact() : event.remove());
    }
    setState(() => selectedEvents.clear());
  }

  bool get canRedactSelectedEvents {
    for (Event event in selectedEvents) {
      if (event.canRedact == false) return false;
    }
    return true;
  }

  void forwardEventsAction(BuildContext context) async {
    if (selectedEvents.length == 1) {
      Matrix.of(context).shareContent = selectedEvents.first.content;
    } else {
      Matrix.of(context).shareContent = {
        "msgtype": "m.text",
        "body": _getSelectedEventString(context),
      };
    }
    setState(() => selectedEvents.clear());
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  void sendAgainAction() {
    selectedEvents.first.sendAgain();
    setState(() => selectedEvents.clear());
  }

  void replyAction() {
    setState(() {
      replyEvent = selectedEvents.first;
      selectedEvents.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    matrix = Matrix.of(context);
    Client client = matrix.client;
    room ??= client.getRoomById(widget.id);
    if (room == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(I18n.of(context).oopsSomethingWentWrong),
        ),
        body: Center(
          child: Text(I18n.of(context).youAreNoLongerParticipatingInThisChat),
        ),
      );
    }
    matrix.activeRoomId = widget.id;

    if (room.membership == Membership.invite) {
      matrix.tryRequestWithLoadingDialog(room.join());
    }

    String typingText = "";
    List<User> typingUsers = room.typingUsers;
    typingUsers.removeWhere((User u) => u.id == client.userID);

    if (typingUsers.length == 1) {
      typingText = I18n.of(context).isTyping;
      if (typingUsers.first.id != room.directChatMatrixID) {
        typingText =
            I18n.of(context).userIsTyping(typingUsers.first.calcDisplayname());
      }
    } else if (typingUsers.length == 2) {
      typingText = I18n.of(context).userAndUserAreTyping(
          typingUsers.first.calcDisplayname(),
          typingUsers[1].calcDisplayname());
    } else if (typingUsers.length > 2) {
      typingText = I18n.of(context).userAndOthersAreTyping(
          typingUsers.first.calcDisplayname(),
          (typingUsers.length - 1).toString());
    }

    return Scaffold(
      appBar: AppBar(
        leading: selectMode
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: () => setState(() => selectedEvents.clear()),
              )
            : null,
        title: selectedEvents.isEmpty
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(room.getLocalizedDisplayname(context)),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: typingText.isEmpty ? 0 : 20,
                    child: Row(
                      children: <Widget>[
                        typingText.isEmpty
                            ? Container()
                            : Icon(Icons.edit,
                                color: Theme.of(context).primaryColor,
                                size: 10),
                        SizedBox(width: 4),
                        Text(
                          typingText,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Text(I18n.of(context)
                .numberSelected(selectedEvents.length.toString())),
        actions: selectMode
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.content_copy),
                  onPressed: () => copyEventsAction(context),
                ),
                if (canRedactSelectedEvents)
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => redactEventsAction(context),
                  ),
              ]
            : <Widget>[ChatSettingsPopupMenu(room, !room.isDirectChat)],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<bool>(
                future: getTimeline(),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (room.notificationCount != null &&
                      room.notificationCount > 0 &&
                      timeline != null &&
                      timeline.events.isNotEmpty) {
                    room.sendReadReceipt(timeline.events.first.eventId);
                  }

                  if (timeline.events.isEmpty) return Container();

                  return ListView.builder(
                      reverse: true,
                      itemCount: timeline.events.length + 1,
                      controller: _scrollController,
                      itemBuilder: (BuildContext context, int i) {
                        return i == 0
                            ? AnimatedContainer(
                                height: seenByText.isEmpty ? 0 : 24,
                                duration: seenByText.isEmpty
                                    ? Duration(milliseconds: 0)
                                    : Duration(milliseconds: 500),
                                alignment: timeline.events.first.senderId ==
                                        client.userID
                                    ? Alignment.topRight
                                    : Alignment.topLeft,
                                child: Text(
                                  seenByText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                padding: EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                  bottom: 8,
                                ),
                              )
                            : Message(timeline.events[i - 1],
                                onSelect: (Event event) => event.redacted
                                    ? null
                                    : selectedEvents.contains(event)
                                        ? setState(
                                            () => selectedEvents.remove(event))
                                        : setState(
                                            () => selectedEvents.add(event)),
                                longPressSelect: selectedEvents.isEmpty,
                                selected: selectedEvents
                                    .contains(timeline.events[i - 1]),
                                nextEvent:
                                    i >= 2 ? timeline.events[i - 2] : null);
                      });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: replyEvent != null ? 56 : 0,
              child: Material(
                color: Theme.of(context).secondaryHeaderColor,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => setState(() => replyEvent = null),
                    ),
                    Container(
                      width: 2,
                      height: 36,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            (replyEvent?.sender?.calcDisplayname() ?? "") + ":",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Text(
                            replyEvent?.getLocalizedBody(context,
                                    withSenderNamePrefix: false) ??
                                "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            room.canSendDefaultMessages && room.membership == Membership.join
                ? Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, -1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: selectMode
                          ? <Widget>[
                              Container(
                                height: 56,
                                child: FlatButton(
                                  onPressed: () => forwardEventsAction(context),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.keyboard_arrow_left),
                                      Text(I18n.of(context).forward),
                                    ],
                                  ),
                                ),
                              ),
                              selectedEvents.length == 1
                                  ? selectedEvents.first.status > 0
                                      ? Container(
                                          height: 56,
                                          child: FlatButton(
                                            onPressed: () => replyAction(),
                                            child: Row(
                                              children: <Widget>[
                                                Text(I18n.of(context).reply),
                                                Icon(
                                                    Icons.keyboard_arrow_right),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 56,
                                          child: FlatButton(
                                            onPressed: () => sendAgainAction(),
                                            child: Row(
                                              children: <Widget>[
                                                Text(I18n.of(context)
                                                    .tryToSendAgain),
                                                SizedBox(width: 4),
                                                Icon(Icons.send, size: 16),
                                              ],
                                            ),
                                          ),
                                        )
                                  : Container(),
                            ]
                          : <Widget>[
                              kIsWeb
                                  ? Container()
                                  : PopupMenuButton<String>(
                                      icon: Icon(Icons.add),
                                      onSelected: (String choice) async {
                                        if (choice == "file") {
                                          sendFileAction(context);
                                        } else if (choice == "image") {
                                          sendImageAction(context);
                                        }
                                        if (choice == "camera") {
                                          openCameraAction(context);
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: "file",
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                              child: Icon(Icons.attachment),
                                            ),
                                            title:
                                                Text(I18n.of(context).sendFile),
                                            contentPadding: EdgeInsets.all(0),
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: "image",
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.blue,
                                              foregroundColor: Colors.white,
                                              child: Icon(Icons.image),
                                            ),
                                            title: Text(
                                                I18n.of(context).sendImage),
                                            contentPadding: EdgeInsets.all(0),
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: "camera",
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.purple,
                                              foregroundColor: Colors.white,
                                              child: Icon(Icons.camera),
                                            ),
                                            title: Text(
                                                I18n.of(context).openCamera),
                                            contentPadding: EdgeInsets.all(0),
                                          ),
                                        ),
                                      ],
                                    ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: TextField(
                                    minLines: 1,
                                    maxLines: kIsWeb ? 1 : 8,
                                    keyboardType: kIsWeb
                                        ? TextInputType.text
                                        : TextInputType.multiline,
                                    onSubmitted: (String text) {
                                      send();
                                      FocusScope.of(context)
                                          .requestFocus(inputFocus);
                                    },
                                    focusNode: inputFocus,
                                    controller: sendController,
                                    decoration: InputDecoration(
                                      hintText: I18n.of(context).writeAMessage,
                                      border: InputBorder.none,
                                      suffixIcon: sendController.text.isEmpty
                                          ? InkWell(
                                              child: Icon(room.encrypted
                                                  ? Icons.lock
                                                  : Icons.lock_open),
                                              onTap: () =>
                                                  Navigator.of(context).push(
                                                AppRoute.defaultRoute(
                                                  context,
                                                  ChatEncryptionSettingsView(
                                                      widget.id),
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                                    onChanged: (String text) {
                                      this.typingCoolDown?.cancel();
                                      this.typingCoolDown =
                                          Timer(Duration(seconds: 2), () {
                                        this.typingCoolDown = null;
                                        this.currentlyTyping = false;
                                        room.sendTypingInfo(false);
                                      });
                                      this.typingTimeout ??=
                                          Timer(Duration(seconds: 30), () {
                                        this.typingTimeout = null;
                                        this.currentlyTyping = false;
                                      });
                                      if (!this.currentlyTyping) {
                                        this.currentlyTyping = true;
                                        room.sendTypingInfo(true,
                                            timeout: Duration(seconds: 30)
                                                .inMilliseconds);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () => send(),
                              ),
                            ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
