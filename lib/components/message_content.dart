import 'package:famedlysdk/encryption/utils/key_verification.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/audio_player.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/components/image_bubble.dart';
import 'package:fluffychat/utils/event_extension.dart';
import 'package:fluffychat/utils/matrix_locals.dart';
import 'package:fluffychat/components/dialogs/key_verification_dialog.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix_link_text/link_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/url_launcher.dart';
import '../app_config.dart';
import 'html_message.dart';
import 'matrix.dart';
import 'message_download_content.dart';

class MessageContent extends StatelessWidget {
  final Event event;
  final Color textColor;

  const MessageContent(this.event, {this.textColor});

  void _verifyOrRequestKey(BuildContext context) async {
    if (event.content['can_request_session'] != true) {
      FlushbarHelper.createError(
        message: event.type == EventTypes.Encrypted
            ? L10n.of(context).needPantalaimonWarning
            : event.getLocalizedBody(
                MatrixLocals(L10n.of(context)),
              ),
      );
      return;
    }
    final client = Matrix.of(context).client;
    if (client.isUnknownSession && client.encryption.crossSigning.enabled) {
      final req =
          await client.userDeviceKeys[client.userID].startVerification();
      req.onUpdate = () async {
        if (req.state == KeyVerificationState.done) {
          for (var i = 0; i < 12; i++) {
            if (await client.encryption.keyManager.isCached()) {
              break;
            }
            await Future.delayed(Duration(seconds: 1));
          }
          final timeline = await event.room.getTimeline();
          timeline.requestKeys();
          timeline.cancelSubscriptions();
        }
      };
      await KeyVerificationDialog(request: req).show(context);
    } else {
      final success = await showFutureLoadingDialog(
        context: context,
        future: () => event.requestKey(),
      );
      if (success.error == null) {
        await FlushbarHelper.createLoading(
          title: L10n.of(context).loadingPleaseWait,
          message: L10n.of(context).requestToReadOlderMessages,
          linearProgressIndicator: LinearProgressIndicator(),
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (event.type) {
      case EventTypes.Message:
      case EventTypes.Encrypted:
      case EventTypes.Sticker:
        switch (event.messageType) {
          case MessageTypes.Image:
          case MessageTypes.Sticker:
            if (event.showThumbnail) {
              return ImageBubble(event);
            }
            return MessageDownloadContent(event, textColor);
          case MessageTypes.Audio:
            return AudioPlayer(
              event,
              color: textColor,
            );
          case MessageTypes.Video:
          case MessageTypes.File:
            return MessageDownloadContent(event, textColor);
          case MessageTypes.Text:
          case MessageTypes.Notice:
          case MessageTypes.Emote:
            if (AppConfig.renderHtml &&
                !event.redacted &&
                event.isRichMessage) {
              var html = event.formattedText;
              if (event.messageType == MessageTypes.Emote) {
                html = '* $html';
              }
              final bigEmotes = event.onlyEmotes &&
                  event.numberEmotes > 0 &&
                  event.numberEmotes <= 10;
              final fontSize = DefaultTextStyle.of(context).style.fontSize;
              return HtmlMessage(
                html: html,
                defaultTextStyle: TextStyle(
                  color: textColor,
                  fontSize: bigEmotes ? fontSize * 3 : fontSize,
                ),
                room: event.room,
                emoteSize: bigEmotes ? fontSize * 3 : fontSize * 1.5,
              );
            }
            // else we fall through to the normal message rendering
            continue textmessage;
          case MessageTypes.BadEncrypted:
          case EventTypes.Encrypted:
            return RaisedButton(
              elevation: 7,
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline),
                  SizedBox(width: 8),
                  Text(L10n.of(context).encrypted),
                ],
              ),
              onPressed: () => _verifyOrRequestKey(context),
            );
          case MessageTypes.Location:
          case MessageTypes.None:
          textmessage:
          default:
            if (event.content['msgtype'] == Matrix.callNamespace) {
              return RaisedButton(
                elevation: 7,
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.phone_outlined),
                    SizedBox(width: 8),
                    Text(L10n.of(context).videoCall),
                  ],
                ),
                onPressed: () => launch(event.body),
              );
            }
            final fontSize = DefaultTextStyle.of(context).style.fontSize;
            if (event.redacted) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_forever_outlined, color: textColor),
                  SizedBox(width: 4),
                  Text(
                    event.getLocalizedBody(MatrixLocals(L10n.of(context)),
                        hideReply: true),
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 0.5,
                    ),
                  ),
                ],
              );
            }
            final bigEmotes = event.onlyEmotes &&
                event.numberEmotes > 0 &&
                event.numberEmotes <= 10;
            return LinkText(
              text: event.getLocalizedBody(MatrixLocals(L10n.of(context)),
                  hideReply: true),
              textStyle: TextStyle(
                color: textColor,
                fontSize: bigEmotes ? fontSize * 3 : fontSize,
                decoration: event.redacted ? TextDecoration.lineThrough : null,
              ),
              onLinkTap: (url) => UrlLauncher(context, url).launchUrl(),
            );
        }
        break;
      default:
        return Text(
          L10n.of(context)
              .userSentUnknownEvent(event.sender.calcDisplayname(), event.type),
          style: TextStyle(
            color: textColor,
            decoration: event.redacted ? TextDecoration.lineThrough : null,
          ),
        );
    }
    return Container(); // else flutter analyze complains
  }
}
