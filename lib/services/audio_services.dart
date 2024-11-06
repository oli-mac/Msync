import 'package:just_audio/just_audio.dart';
import 'package:msync/services/youtube_service.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final YouTubeService _youtubeService = YouTubeService();
  Duration? _currentDuration;

  Future<void> setAudioSource(String url) async {
    try {
      String audioUrl = url;
      if (url.contains('youtube.com/') || url.contains('youtu.be/')) {
        audioUrl = await _youtubeService.getAudioStreamUrl(url);
      }
      await _audioPlayer.setUrl(audioUrl);
      _currentDuration = await _audioPlayer.duration;
    } catch (e) {
      throw Exception('Failed to load audio source: $e');
    }
  }

  Future<void> play() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      throw Exception('Failed to play audio: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      throw Exception('Failed to pause audio: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      throw Exception('Failed to stop audio: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      throw Exception('Failed to seek audio: $e');
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume);
    } catch (e) {
      throw Exception('Failed to set volume: $e');
    }
  }

  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Duration? get duration => _currentDuration;

  void dispose() {
    _audioPlayer.dispose();
  }
}
