import 'dart:convert';

import 'package:fluffychat/pages/sticker/sticker.dart';
import 'package:fluffychat/pages/sticker/sticker_groups.dart';
import 'package:flutter/cupertino.dart';

class StickerProvider {
  Future<Map<String, List<Sticker>>> getStickers(BuildContext context) async {
    final stickerGroupsJson = await DefaultAssetBundle.of(context)
        .loadString('assets/stickers/stickers.json');
    final StickerGroups stickerGroups =
        StickerGroups.fromJson(jsonDecode(stickerGroupsJson));
    final stickerGroupMap = {
      for (var e in stickerGroups.packs) e.category: e.stickers
    };
    return stickerGroupMap;
  }
}
