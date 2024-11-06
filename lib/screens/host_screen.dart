import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msync/blocs/playlist_bloc.dart';
import 'package:msync/services/file_picker_service.dart';
import 'package:msync/widgets/playback_controls.dart';
import 'package:msync/widgets/playlist_view.dart';
import 'package:msync/widgets/url_input_dialog.dart';
import 'package:share_plus/share_plus.dart';

class HostScreen extends StatelessWidget {
  final String partyUrl;
  final _filePickerService = FilePickerService();

  HostScreen({super.key, required this.partyUrl});

  Future<void> _pickAndAddSongs(BuildContext context) async {
    try {
      final songs = await _filePickerService.pickAudioFiles();
      if (songs.isNotEmpty) {
        for (final song in songs) {
          context.read<PlaylistBloc>().add(AddSong(song));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding songs: $e')),
        );
      }
    }
  }

  Future<void> _showUrlInputDialog(BuildContext context) async {
    final song = await showDialog(
      context: context,
      builder: (context) => const UrlInputDialog(),
    );

    if (song != null && context.mounted) {
      context.read<PlaylistBloc>().add(AddSong(song));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Party'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Party URL',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(partyUrl),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => Share.share(
                        'Join my Music Sync party! URL: $partyUrl',
                        subject: 'Join Music Sync Party',
                      ),
                      icon: const Icon(Icons.share),
                      label: const Text('Share URL'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const PlaybackControls(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Playlist',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PopupMenuButton(
                        icon: const Icon(Icons.add),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'local',
                            child: Text('Add Local Files'),
                          ),
                          const PopupMenuItem(
                            value: 'url',
                            child: Text('Add from URL'),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'local') {
                            _pickAndAddSongs(context);
                          } else if (value == 'url') {
                            _showUrlInputDialog(context);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Expanded(child: PlaylistView()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
