import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msync/blocs/party_bloc.dart';
import 'package:msync/screens/join_screen.dart';

import 'host_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PartyBloc, PartyState>(
        listener: (context, state) {
          if (state is PartyCreated) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HostScreen(partyUrl: state.partyUrl),
              ),
            );
          } else if (state is PartyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Material(
                  elevation: 8, // Adjust this value for more/less elevation
                  shadowColor: Colors.black.withOpacity(0.3), // Soft shadow
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: Stack(
                      children: [
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Image.asset(
                            'assets/bg.png', // Replace with your image asset
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              context.read<PartyBloc>().add(CreateParty()),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 0, 60, 109)
                                      .withOpacity(0.6),
                                  Color.fromARGB(255, 0, 40, 80)
                                      .withOpacity(0.6),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Center(
                              child: const Text('Create Party',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ElevatedButton(
              //   onPressed: () => context.read<PartyBloc>().add(CreateParty()),
              //   child: const Text('Host Party'),
              // ),
              const SizedBox(height: 20),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const JoinScreen()),
                  ),
                  child: Center(
                    child: const Text('Join Party',
                        style: TextStyle(fontSize: 24)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
