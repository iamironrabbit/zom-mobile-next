import 'package:cached_network_image/cached_network_image.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/content_web_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'matrix.dart';

class ContentBanner extends StatelessWidget {
  final MxContent mxContent;
  final double height;
  final IconData defaultIcon;
  final bool loading;
  final Function onEdit;

  const ContentBanner(this.mxContent,
      {this.height = 400,
      this.defaultIcon = Icons.people_outline,
      this.loading = false,
      this.onEdit,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final int bannerSize =
        (mediaQuery.size.width * mediaQuery.devicePixelRatio).toInt();
    final String src = mxContent.getThumbnail(
      Matrix.of(context).client,
      width: bannerSize,
      height: bannerSize,
      method: ThumbnailMethod.scale,
    );
    return InkWell(
      onTap: () => mxContent.mxc?.isNotEmpty ?? false
          ? Navigator.of(context).push(
              AppRoute.defaultRoute(
                context,
                ContentWebView(mxContent),
              ),
            )
          : null,
      child: Container(
        height: 300,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.75,
                child: !loading
                    ? mxContent.mxc?.isNotEmpty ?? false
                        ? kIsWeb
                            ? Image.network(
                                src,
                                height: 300,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: src,
                                height: 300,
                                fit: BoxFit.cover,
                              )
                        : Icon(defaultIcon, size: 300)
                    : Icon(defaultIcon, size: 300),
              ),
            ),
            if (this.onEdit != null)
              Container(
                margin: EdgeInsets.all(8),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.file_upload),
                  onPressed: onEdit,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
