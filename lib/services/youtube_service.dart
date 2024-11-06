import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:msync/models/song.dart';

class YouTubeService {
  final String baseUrl = 'http://localhost:3000';

  Future<Song?> validateAndGetSongInfo(String youtubeUrl) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/validate-youtube?url=${Uri.encodeComponent(youtubeUrl)}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['valid']) {
          return Song(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: data['title'],
            artist: data['artist'],
            url: youtubeUrl,
            duration: Duration(seconds: data['duration']),
          );
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to validate YouTube URL: $e');
    }
  }

  Future<String> getAudioStreamUrl(String youtubeUrl) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/audio-stream?url=${Uri.encodeComponent(youtubeUrl)}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['streamUrl'];
      }
      throw Exception('Failed to get audio stream URL');
    } catch (e) {
      throw Exception('Failed to get audio stream: $e');
    }
  }
}