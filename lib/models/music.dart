class Music {
  String id;
  String title;
  String artist;
  String url;

  Music({
    required this.id,
    required this.title,
    required this.artist,
    required this.url,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'url': url,
    };
  }
}
