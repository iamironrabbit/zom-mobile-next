import 'package:fluffychat/pages/sticker/sticker_group.dart';

class StickerGroups {
  List<StickerGroup> packs = [];

  StickerGroups(this.packs);

  factory StickerGroups.fromJson(dynamic json) {
    final stickerGroupsJson = json['packs'] as List;
    final List<StickerGroup> stickerGroups = stickerGroupsJson
        .map((stickerGroupJson) => StickerGroup.fromJson(stickerGroupJson))
        .toList();
    return StickerGroups(stickerGroups);
  }

  @override
  String toString() {
    return '{ $packs}';
  }
}
