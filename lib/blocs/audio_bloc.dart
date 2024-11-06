import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:msync/models/song.dart';
import 'package:msync/services/audio_services.dart';

// Events
abstract class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object> get props => [];
}

class LoadSong extends AudioEvent {
  final Song song;
  const LoadSong(this.song);

  @override
  List<Object> get props => [song];
}

class PlayAudio extends AudioEvent {}

class PauseAudio extends AudioEvent {}

class StopAudio extends AudioEvent {}

class SeekAudio extends AudioEvent {
  final Duration position;
  const SeekAudio(this.position);

  @override
  List<Object> get props => [position];
}

class SetVolume extends AudioEvent {
  final double volume;
  const SetVolume(this.volume);

  @override
  List<Object> get props => [volume];
}

// States
abstract class AudioState extends Equatable {
  const AudioState();

  @override
  List<Object> get props => [];
}

class AudioInitial extends AudioState {}

class AudioLoading extends AudioState {}

class AudioReady extends AudioState {
  final Song song;
  const AudioReady(this.song);

  @override
  List<Object> get props => [song];
}

class AudioPlaying extends AudioState {
  final Song song;
  final Duration position;
  const AudioPlaying(this.song, this.position);

  @override
  List<Object> get props => [song, position];
}

class AudioPaused extends AudioState {
  final Song song;
  final Duration position;
  const AudioPaused(this.song, this.position);

  @override
  List<Object> get props => [song, position];
}

class AudioError extends AudioState {
  final String message;
  const AudioError(this.message);

  @override
  List<Object> get props => [message];
}

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioService _audioService;

  AudioBloc(this._audioService) : super(AudioInitial()) {
    on<LoadSong>(_onLoadSong);
    on<PlayAudio>(_onPlayAudio);
    on<PauseAudio>(_onPauseAudio);
    on<StopAudio>(_onStopAudio);
    on<SeekAudio>(_onSeekAudio);
    on<SetVolume>(_onSetVolume);

    // Listen to position updates
    _audioService.positionStream.listen((position) {
      if (state is AudioPlaying) {
        final currentState = state as AudioPlaying;
        emit(AudioPlaying(currentState.song, position));
      }
    });

    // Listen to player state changes
    _audioService.playerStateStream.listen((playerState) {
      if (state is AudioPlaying || state is AudioPaused) {
        final song = state is AudioPlaying
            ? (state as AudioPlaying).song
            : (state as AudioPaused).song;

        if (playerState.playing) {
          emit(AudioPlaying(song, Duration.zero));
        } else {
          emit(AudioPaused(song, Duration.zero));
        }
      }
    });
  }

  Future<void> _onLoadSong(LoadSong event, Emitter<AudioState> emit) async {
    emit(AudioLoading());
    try {
      await _audioService.setAudioSource(event.song.url);
      emit(AudioReady(event.song));
      add(PlayAudio()); // Automatically start playing after loading
    } catch (e) {
      emit(AudioError(e.toString()));
    }
  }

  Future<void> _onPlayAudio(PlayAudio event, Emitter<AudioState> emit) async {
    try {
      if (state is AudioReady || state is AudioPaused) {
        final song = state is AudioReady
            ? (state as AudioReady).song
            : (state as AudioPaused).song;
        await _audioService.play();
        emit(AudioPlaying(song, Duration.zero));
      }
    } catch (e) {
      emit(AudioError(e.toString()));
    }
  }

  Future<void> _onPauseAudio(PauseAudio event, Emitter<AudioState> emit) async {
    try {
      if (state is AudioPlaying) {
        final currentState = state as AudioPlaying;
        await _audioService.pause();
        emit(AudioPaused(currentState.song, currentState.position));
      }
    } catch (e) {
      emit(AudioError(e.toString()));
    }
  }

  Future<void> _onStopAudio(StopAudio event, Emitter<AudioState> emit) async {
    try {
      await _audioService.stop();
      emit(AudioInitial());
    } catch (e) {
      emit(AudioError(e.toString()));
    }
  }

  Future<void> _onSeekAudio(SeekAudio event, Emitter<AudioState> emit) async {
    try {
      await _audioService.seek(event.position);
    } catch (e) {
      emit(AudioError(e.toString()));
    }
  }

  Future<void> _onSetVolume(SetVolume event, Emitter<AudioState> emit) async {
    try {
      await _audioService.setVolume(event.volume);
    } catch (e) {
      emit(AudioError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _audioService.dispose();
    return super.close();
  }
}
