import 'package:file_picker/file_picker.dart';
import 'package:msync/models/song.dart';
import 'package:path/path.dart' as path;

class FilePickerService {
  Future<List<Song>> pickAudioFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result != null) {
        return result.files.map((file) {
          return Song(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: path.basenameWithoutExtension(file.name),
            artist: 'Unknown', // Could be extracted from metadata
            url: file.path!,
            duration:
                const Duration(seconds: 0), // Could be extracted from metadata
          );
        }).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to pick audio files: $e');
    }
  }
}
