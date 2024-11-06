import 'package:equatable/equatable.dart';
import 'package:msync/models/song.dart';

class Playlist extends Equatable {
  final String id;
  final String name;
  final List<Song> songs;
  final int currentIndex;

  const Playlist({
    required this.id,
    required this.name,
    required this.songs,
    this.currentIndex = 0,
  });

  Playlist copyWith({
    String? id,
    String? name,
    List<Song>? songs,
    int? currentIndex,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      songs: songs ?? this.songs,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  Song? get currentSong => songs.isNotEmpty ? songs[currentIndex] : null;

  @override
  List<Object> get props => [id, name, songs, currentIndex];
}