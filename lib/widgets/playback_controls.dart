import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msync/blocs/audio_bloc.dart';
import 'package:msync/blocs/playlist_bloc.dart';


class PlaybackControls extends StatelessWidget {
  const PlaybackControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<PlaylistBloc, PlaylistState>(
              builder: (context, playlistState) {
                if (playlistState is PlaylistLoaded && 
                    playlistState.playlist.currentSong != null) {
                  return BlocBuilder<AudioBloc, AudioState>(
                    builder: (context, audioState) {
                      final currentSong = playlistState.playlist.currentSong!;
                      
                      // Load the song if it's not loaded
                      if (audioState is AudioInitial) {
                        context.read<AudioBloc>().add(LoadSong(currentSong));
                      }

                      // Get current position and duration
                      final position = (audioState is AudioPlaying)
                          ? (audioState as AudioPlaying).position
                          : (audioState is AudioPaused)
                              ? (audioState as AudioPaused).position
                              : Duration.zero;
                              
                      final duration = currentSong.duration.inSeconds > 0
                          ? currentSong.duration
                          : const Duration(minutes: 1); // Fallback duration

                      return Column(
                        children: [
                          Text(
                            currentSong.title,
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            currentSong.artist,
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.skip_previous),
                                onPressed: () {
                                  context.read<AudioBloc>().add(StopAudio());
                                  context.read<PlaylistBloc>().add(PreviousSong());
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  audioState is AudioPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                                onPressed: () {
                                  if (audioState is AudioPlaying) {
                                    context.read<AudioBloc>().add(PauseAudio());
                                  } else {
                                    context.read<AudioBloc>().add(PlayAudio());
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.skip_next),
                                onPressed: () {
                                  context.read<AudioBloc>().add(StopAudio());
                                  context.read<PlaylistBloc>().add(NextSong());
                                },
                              ),
                            ],
                          ),
                          if (audioState is AudioPlaying || audioState is AudioPaused)
                            Row(
                              children: [
                                Text(_formatDuration(position)),
                                Expanded(
                                  child: Slider(
                                    value: position.inSeconds.toDouble(),
                                    min: 0,
                                    max: duration.inSeconds.toDouble(),
                                    onChanged: (value) {
                                      context.read<AudioBloc>().add(
                                        SeekAudio(Duration(seconds: value.toInt())),
                                      );
                                    },
                                  ),
                                ),
                                Text(_formatDuration(duration)),
                              ],
                            ),
                        ],
                      );
                    },
                  );
                }
                return const Center(
                  child: Text('No song selected'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}