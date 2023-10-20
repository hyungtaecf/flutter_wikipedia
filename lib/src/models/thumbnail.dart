class Thumbnail {
  const Thumbnail({
    required this.source,
    required this.width,
    required this.height,
  });
  Thumbnail.fromJson(Map<String, dynamic> json)
      : source = json["source"],
        width = json["width"],
        height = json["height"];

  final String source;
  final int width;
  final int height;
}
