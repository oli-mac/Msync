import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msync/blocs/playlist_bloc.dart';

class PlaylistView extends StatelessWidget {
  const PlaylistView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        if (state is PlaylistLoaded) {
          return ReorderableListView.builder(
            shrinkWrap: true,
            itemCount: state.playlist.songs.length,
            itemBuilder: (context, index) {
              final song = state.playlist.songs[index];
              return ListTile(
                key: Key(song.id),
                title: Text(song.title),
                subtitle: Text(song.artist),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () =>
                      context.read<PlaylistBloc>().add(RemoveSong(song)),
                ),
              );
            },
            onReorder: (oldIndex, newIndex) {
              context
                  .read<PlaylistBloc>()
                  .add(ReorderSongs(oldIndex, newIndex));
            },
          );
        }
        return const Center(child: Text('No songs in playlist'));
      },
    );
  }
}