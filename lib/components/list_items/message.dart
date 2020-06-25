import 'package:bubble/bubble.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/components/message_content.dart';
import 'package:fluffychat/components/reply_content.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/event_extension.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:flutter/material.dart';

import '../adaptive_page_layout.dart';
import '../avatar.dart';
import '../matrix.dart';
import 'state_message.dart';

class Message extends StatelessWidget {
  final Event event;
  final Event nextEvent;
  final Function(Event) onSelect;
  final Function(Event) onAvatarTab;
  final bool longPressSelect;
  final bool selected;
  final Timeline timeline;

  const Message(this.event,
      {this.nextEvent,
      this.longPressSelect,
      this.onSelect,
      this.onAvatarTab,
      this.selected,
      this.timeline});

  /// Indicates wheither the user may use a mouse instead
  /// of touchscreen.
  static bool useMouse = false;

  @override
  Widget build(BuildContext context) {
    if (event.type == EventTypes.Unknown) {
      return Container();
    }
    if (![EventTypes.Message, EventTypes.Sticker, EventTypes.Encrypted]
        .contains(event.type)) {
      return StateMessage(event);
    }

    var client = Matrix.of(context).client;
    final ownMessage = event.senderId == client.userID;
    var alignment = ownMessage ? Alignment.topRight : Alignment.topLeft;
    var color = Theme.of(context).secondaryHeaderColor;
    final sameSender = nextEvent != null &&
            [EventTypes.Message, EventTypes.Sticker].contains(nextEvent.type)
        ? nextEvent.sender.id == event.sender.id
        : false;
    var nip = sameSender
        ? BubbleNip.no
        : ownMessage ? BubbleNip.rightBottom : BubbleNip.leftBottom;
    var textColor = ownMessage
        ? Colors.white
        : Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    var rowMainAxisAlignment =
        ownMessage ? MainAxisAlignment.end : MainAxisAlignment.start;

    if (event.showThumbnail) {
      color = Theme.of(context).scaffoldBackgroundColor.withOpacity(0.66);
      textColor = Theme.of(context).textTheme.bodyText2.color;
    } else if (ownMessage) {
      color = event.status == -1
          ? Colors.redAccent
          : Theme.of(context).primaryColor;
    }

    var rowChildren = <Widget>[
      Expanded(
        child: Bubble(
          elevation: 0,
          radius: Radius.circular(8),
          alignment: alignment,
          margin: BubbleEdges.symmetric(horizontal: 4),
          color: color,
          nip: nip,
          child: Container(
            constraints:
                BoxConstraints(maxWidth: AdaptivePageLayout.defaultMinWidth),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (event.isReply)
                      FutureBuilder<Event>(
                        future: event.getReplyEvent(timeline),
                        builder: (BuildContext context, snapshot) {
                          final replyEvent = snapshot.hasData
                              ? snapshot.data
                              : Event(
                                  eventId: event.content['m.relates_to']
                                      ['m.in_reply_to']['event_id'],
                                  content: {'msgtype': 'm.text', 'body': '...'},
                                  senderId: event.senderId,
                                  type: 'm.room.message',
                                  room: event.room,
                                  roomId: event.roomId,
                                  status: 1,
                                  originServerTs: DateTime.now(),
                                );
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 4.0),
                            child:
                                ReplyContent(replyEvent, lightText: ownMessage),
                          );
                        },
                      ),
                    MessageContent(
                      event,
                      textColor: textColor,
                    ),
                    if (event.type == EventTypes.Encrypted &&
                        event.messageType == MessageTypes.BadEncrypted &&
                        event.content['can_request_session'] == true)
                      RaisedButton(
                        color: color.withAlpha(100),
                        child: Text(
                          L10n.of(context).requestPermission,
                          style: TextStyle(color: textColor),
                        ),
                        onPressed: () => SimpleDialogs(context)
                            .tryRequestWithLoadingDialog(event.requestKey()),
                      ),
                    SizedBox(height: 4),
                    Opacity(
                      opacity: 0,
                      child: _MetaRow(
                        event,
                        ownMessage,
                        textColor,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: ownMessage ? 0 : null,
                  left: !ownMessage ? 0 : null,
                  child: _MetaRow(
                    event,
                    ownMessage,
                    textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
    final avatarOrSizedBox = sameSender
        ? SizedBox(width: Avatar.defaultSize)
        : Avatar(
            event.sender.avatarUrl,
            event.sender.calcDisplayname(),
            onTap: () => onAvatarTab(event),
          );
    if (ownMessage) {
      rowChildren.add(avatarOrSizedBox);
    } else {
      rowChildren.insert(0, avatarOrSizedBox);
    }

    return InkWell(
      onHover: (b) => useMouse = true,
      onTap: !useMouse && longPressSelect ? () => null : () => onSelect(event),
      splashColor: Theme.of(context).primaryColor.withAlpha(100),
      onLongPress: !longPressSelect ? null : () => onSelect(event),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        color: selected
            ? Theme.of(context).primaryColor.withAlpha(100)
            : Theme.of(context).primaryColor.withAlpha(0),
        child: Padding(
          padding: EdgeInsets.only(
              left: 8.0, right: 8.0, bottom: sameSender ? 4.0 : 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: rowMainAxisAlignment,
            children: rowChildren,
          ),
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final Event event;
  final bool ownMessage;
  final Color color;

  const _MetaRow(this.event, this.ownMessage, this.color, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayname = event.sender.calcDisplayname();
    final showDisplayname =
        !ownMessage && event.senderId != event.room.directChatMatrixID;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showDisplayname)
          Text(
            displayname,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: displayname.color,
            ),
          ),
        if (showDisplayname) SizedBox(width: 4),
        Text(
          event.originServerTs.localizedTime(context),
          style: TextStyle(
            color: color,
            fontSize: 11,
          ),
        ),
        if (ownMessage) SizedBox(width: 2),
        if (ownMessage)
          Icon(
            event.statusIcon,
            size: 12,
            color: color,
          ),
      ],
    );
  }
}
