import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msync/blocs/audio_bloc.dart';
import 'package:msync/blocs/party_bloc.dart';
import 'package:msync/blocs/playlist_bloc.dart';
import 'package:msync/screens/home_screen.dart';
import 'package:msync/services/audio_services.dart';

void main() {
  runApp(const MusicSyncApp());
}

class MusicSyncApp extends StatelessWidget {
  const MusicSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PartyBloc()),
        BlocProvider(create: (context) => AudioBloc(AudioService())),
        BlocProvider(create: (context) => PlaylistBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MSync',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
