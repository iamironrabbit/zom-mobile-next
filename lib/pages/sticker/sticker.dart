class Sticker {
  String name = "";
  String category = "";
  String emoticon = "";
  String url = "";

  Sticker(this.name, this.category, this.emoticon, this.url);

  factory Sticker.fromJson(dynamic json) {
    return Sticker(json['name'] as String, json['category'] as String,
        json['emoticon'] as String, json['url'] as String);
  }

  @override
  String toString() {
    return '{ $name, $category,$emoticon,$url }';
  }
}
