import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:msync/models/playlist.dart';
import 'package:msync/models/song.dart';

// Events
abstract class PlaylistEvent extends Equatable {
  const PlaylistEvent();

  @override
  List<Object> get props => [];
}

class AddSong extends PlaylistEvent {
  final Song song;
  const AddSong(this.song);

  @override
  List<Object> get props => [song];
}

class RemoveSong extends PlaylistEvent {
  final Song song;
  const RemoveSong(this.song);

  @override
  List<Object> get props => [song];
}

class ReorderSongs extends PlaylistEvent {
  final int oldIndex;
  final int newIndex;
  const ReorderSongs(this.oldIndex, this.newIndex);

  @override
  List<Object> get props => [oldIndex, newIndex];
}

class NextSong extends PlaylistEvent {}
class PreviousSong extends PlaylistEvent {}

// States
abstract class PlaylistState extends Equatable {
  const PlaylistState();

  @override
  List<Object> get props => [];
}

class PlaylistInitial extends PlaylistState {}
class PlaylistLoaded extends PlaylistState {
  final Playlist playlist;
  const PlaylistLoaded(this.playlist);

  @override
  List<Object> get props => [playlist];
}

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  PlaylistBloc() : super(PlaylistInitial()) {
    on<AddSong>(_onAddSong);
    on<RemoveSong>(_onRemoveSong);
    on<ReorderSongs>(_onReorderSongs);
    on<NextSong>(_onNextSong);
    on<PreviousSong>(_onPreviousSong);
  }

  void _onAddSong(AddSong event, Emitter<PlaylistState> emit) {
    if (state is PlaylistLoaded) {
      final currentState = state as PlaylistLoaded;
      final updatedSongs = List<Song>.from(currentState.playlist.songs)
        ..add(event.song);
      emit(PlaylistLoaded(
        currentState.playlist.copyWith(songs: updatedSongs),
      ));
    } else {
      emit(PlaylistLoaded(
        Playlist(
          id: DateTime.now().toString(),
          name: 'New Playlist',
          songs: [event.song],
        ),
      ));
    }
  }

  void _onRemoveSong(RemoveSong event, Emitter<PlaylistState> emit) {
    if (state is PlaylistLoaded) {
      final currentState = state as PlaylistLoaded;
      final updatedSongs = List<Song>.from(currentState.playlist.songs)
        ..remove(event.song);
      emit(PlaylistLoaded(
        currentState.playlist.copyWith(songs: updatedSongs),
      ));
    }
  }

  void _onReorderSongs(ReorderSongs event, Emitter<PlaylistState> emit) {
    if (state is PlaylistLoaded) {
      final currentState = state as PlaylistLoaded;
      final songs = List<Song>.from(currentState.playlist.songs);
      final song = songs.removeAt(event.oldIndex);
      songs.insert(event.newIndex, song);
      emit(PlaylistLoaded(
        currentState.playlist.copyWith(songs: songs),
      ));
    }
  }

  void _onNextSong(NextSong event, Emitter<PlaylistState> emit) {
    if (state is PlaylistLoaded) {
      final currentState = state as PlaylistLoaded;
      final playlist = currentState.playlist;
      if (playlist.currentIndex < playlist.songs.length - 1) {
        emit(PlaylistLoaded(
          playlist.copyWith(currentIndex: playlist.currentIndex + 1),
        ));
      }
    }
  }

  void _onPreviousSong(PreviousSong event, Emitter<PlaylistState> emit) {
    if (state is PlaylistLoaded) {
      final currentState = state as PlaylistLoaded;
      final playlist = currentState.playlist;
      if (playlist.currentIndex > 0) {
        emit(PlaylistLoaded(
          playlist.copyWith(currentIndex: playlist.currentIndex - 1),
        ));
      }
    }
  }
}