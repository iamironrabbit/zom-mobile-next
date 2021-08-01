import 'package:matrix/matrix.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'matrix.dart';

class Avatar extends StatelessWidget {
  final Uri mxContent;
  final String name;
  final double size;
  final Function onTap;
  static const double defaultSize = 44;
  final Client client;

  const Avatar(
    this.mxContent,
    this.name, {
    this.size = defaultSize,
    this.onTap,
    this.client,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final src = mxContent?.getThumbnail(
      client ?? Matrix.of(context).client,
      width: size * MediaQuery.of(context).devicePixelRatio,
      height: size * MediaQuery.of(context).devicePixelRatio,
    );
    var fallbackLetters = '@';
    if ((name?.runes?.length ?? 0) >= 2) {
      fallbackLetters = String.fromCharCodes(name.runes, 0, 2);
    } else if ((name?.runes?.length ?? 0) == 1) {
      fallbackLetters = name;
    }
    final noPic = mxContent == null ||
        mxContent.toString().isEmpty ||
        mxContent.toString() == 'null';
    final textWidget = Center(
      child: Text(
        fallbackLetters,
        style: TextStyle(
          color: noPic ? name?.darkColor : null,
          fontSize: 18,
        ),
      ),
    );
    final borderRadius = BorderRadius.circular(size / 2);
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          width: size,
          height: size,
          color:
              noPic ? name?.lightColor : Theme.of(context).secondaryHeaderColor,
          child: noPic
              ? textWidget
              : CachedNetworkImage(
                  imageUrl: src.toString(),
                  fit: BoxFit.cover,
                  width: size,
                  height: size,
                  placeholder: (c, s) => textWidget,
                  errorWidget: (c, s, d) => Stack(
                    children: [
                      textWidget,
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
