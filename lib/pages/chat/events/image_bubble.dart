import 'package:fluffychat/pages/image_viewer/image_viewer.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class ImageBubble extends StatelessWidget {
  final Event event;
  final bool tapToView;
  final BoxFit fit;
  final bool maxSize;
  final Color? backgroundColor;
  final bool thumbnailOnly;
  final bool animated;
  final double width;
  final double height;
  final void Function()? onTap;

  const ImageBubble(
    this.event, {
    this.tapToView = true,
    this.maxSize = true,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.thumbnailOnly = true,
    this.width = 400,
    this.height = 300,
    this.animated = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  void _onTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
      return;
    }
    if (!tapToView) return;
    showDialog(
      context: Matrix.of(context).navigatorContext,
      useRootNavigator: false,
      builder: (_) => ImageViewer(event),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTap(context),
      child: Hero(
        tag: event.eventId,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          child: Container(
            color: backgroundColor,
            constraints: maxSize
                ? BoxConstraints(
                    maxWidth: width,
                    maxHeight: height,
                  )
                : null,
            child: Image.asset(_setImage(event)),
          ),
        ),
      ),
    );
  }

  String _setImage(Event event) {
    final String imageUrl = event.content['url'];
    final bool start = imageUrl.startsWith(":");
    final bool end = imageUrl.endsWith(":");
    if (start && end) {
      return event.content['body'];
    } else {
      return event.content['url'];
    }
  }
}
