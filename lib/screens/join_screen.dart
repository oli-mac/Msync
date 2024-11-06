import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msync/blocs/party_bloc.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Party'),
      ),
      body: BlocListener<PartyBloc, PartyState>(
        listener: (context, state) {
          if (state is PartyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is PartyJoined) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Successfully joined the party!')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Party URL',
                  hintText: 'Enter the party URL',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final url = _urlController.text.trim();
                  if (url.isNotEmpty) {
                    context.read<PartyBloc>().add(JoinParty(url));
                  }
                },
                child: const Text('Join'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
