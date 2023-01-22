import 'package:fluffychat/pages/sticker/sticker.dart';

class StickerGroup {
  String category = "";
  List<Sticker> stickers = [];

  StickerGroup(this.category, this.stickers);

  factory StickerGroup.fromJson(dynamic json) {
    final category = json['category'];
    final stickersJson = json['stickers'] as List;
    final List<Sticker> stickers = stickersJson
        .map((stickerJson) => Sticker.fromJson(stickerJson))
        .toList();
    return StickerGroup(category, stickers);
  }

  @override
  String toString() {
    return '{ $category, $stickers}';
  }
}
