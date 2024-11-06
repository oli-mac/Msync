import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String url;
  final Duration duration;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.url,
    required this.duration,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'url': url,
      'duration': duration.inMilliseconds,
    };
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      url: json['url'] as String,
      duration: Duration(milliseconds: json['duration'] as int),
    );
  }

  @override
  List<Object> get props => [id, title, artist, url, duration];
}