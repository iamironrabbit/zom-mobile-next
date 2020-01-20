import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/event_extension.dart';
import 'package:fluffychat/views/content_web_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';
import 'package:url_launcher/url_launcher.dart';

import 'matrix.dart';

class MessageContent extends StatelessWidget {
  final Event event;
  final Color textColor;

  const MessageContent(this.event, {this.textColor});

  @override
  Widget build(BuildContext context) {
    switch (event.type) {
      case EventTypes.Message:
      case EventTypes.Sticker:
        switch (event.messageType) {
          case MessageTypes.Image:
          case MessageTypes.Sticker:
            final int size = 400;
            final String src = MxContent(event.content["url"]).getThumbnail(
              Matrix.of(context).client,
              width: size * MediaQuery.of(context).devicePixelRatio,
              height: size * MediaQuery.of(context).devicePixelRatio,
              method: ThumbnailMethod.scale,
            );
            return Bubble(
              padding: BubbleEdges.all(0),
              radius: Radius.circular(10),
              elevation: 0,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  AppRoute.defaultRoute(
                    context,
                    ContentWebView(MxContent(event.content["url"])),
                  ),
                ),
                child: kIsWeb
                    ? Image.network(
                        src,
                        width: size.toDouble(),
                      )
                    : CachedNetworkImage(
                        imageUrl: src,
                        width: size.toDouble(),
                      ),
              ),
            );
          case MessageTypes.Audio:
            return Container(
              width: 200,
              child: RaisedButton(
                color: Colors.blueGrey,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.play_arrow, color: Colors.white),
                    Text(
                      I18n.of(context).play(event.body),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 1,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () => Navigator.of(context).push(
                  AppRoute.defaultRoute(
                    context,
                    ContentWebView(MxContent(event.content["url"])),
                  ),
                ),
              ),
            );
          case MessageTypes.Video:
            return Container(
              width: 200,
              child: RaisedButton(
                color: Colors.blueGrey,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.play_arrow, color: Colors.white),
                    Text(
                      I18n.of(context).play(event.body),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 1,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () => Navigator.of(context).push(
                  AppRoute.defaultRoute(
                    context,
                    ContentWebView(MxContent(event.content["url"])),
                  ),
                ),
              ),
            );
          case MessageTypes.File:
            return Container(
              width: 200,
              child: RaisedButton(
                color: Colors.blueGrey,
                child: Text(
                  I18n.of(context).download(event.body),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => launch(
                  MxContent(event.content["url"])
                      .getDownloadLink(Matrix.of(context).client),
                ),
              ),
            );
          case MessageTypes.Text:
          case MessageTypes.Reply:
          case MessageTypes.Location:
          case MessageTypes.None:
          case MessageTypes.Notice:
          case MessageTypes.Emote:
            return LinkText(
              text: event.getLocalizedBody(context),
              textStyle: TextStyle(
                color: textColor,
                decoration: event.redacted ? TextDecoration.lineThrough : null,
              ),
            );
        }
        return Text(
          event.getLocalizedBody(context),
          style: TextStyle(
            color: textColor,
          ),
        );
      default:
        return Text(
          I18n.of(context).userSentUnknownEvent(
              event.sender.calcDisplayname(), event.typeKey),
          style: TextStyle(
            color: textColor,
            decoration: event.redacted ? TextDecoration.lineThrough : null,
          ),
        );
    }
  }
}
