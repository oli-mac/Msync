import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:msync/services/websocket_services.dart';
import 'dart:async';

// Events
abstract class PartyEvent extends Equatable {
  const PartyEvent();

  @override
  List<Object> get props => [];
}

class CreateParty extends PartyEvent {}
class JoinParty extends PartyEvent {
  final String partyUrl;
  const JoinParty(this.partyUrl);

  @override
  List<Object> get props => [partyUrl];
}

class SendMessage extends PartyEvent {
  final Map<String, dynamic> message;
  const SendMessage(this.message);

  @override
  List<Object> get props => [message];
}

// States
abstract class PartyState extends Equatable {
  const PartyState();

  @override
  List<Object> get props => [];
}

class PartyInitial extends PartyState {}
class PartyCreating extends PartyState {}
class PartyCreated extends PartyState {
  final String partyUrl;
  const PartyCreated(this.partyUrl);

  @override
  List<Object> get props => [partyUrl];
}
class PartyJoining extends PartyState {}
class PartyJoined extends PartyState {}
class PartyError extends PartyState {
  final String message;
  const PartyError(this.message);

  @override
  List<Object> get props => [message];
}

class PartyBloc extends Bloc<PartyEvent, PartyState> {
  final WebSocketService _webSocketService;
  StreamSubscription? _messageSubscription;

  PartyBloc({WebSocketService? webSocketService}) 
      : _webSocketService = webSocketService ?? WebSocketService(),
        super(PartyInitial()) {
    on<CreateParty>(_onCreateParty);
    on<JoinParty>(_onJoinParty);
    on<SendMessage>(_onSendMessage);

    _messageSubscription = _webSocketService.messageStream.listen((message) {
      // Handle incoming messages
      print('Received message: $message');
    });
  }

  Future<void> _onCreateParty(CreateParty event, Emitter<PartyState> emit) async {
    emit(PartyCreating());
    try {
      await _webSocketService.createServer(8080);
      const partyUrl = 'ws://192.168.1.1:8080';
      emit(const PartyCreated(partyUrl));
    } catch (e) {
      emit(PartyError(e.toString()));
    }
  }

  Future<void> _onJoinParty(JoinParty event, Emitter<PartyState> emit) async {
    emit(PartyJoining());
    try {
      await _webSocketService.connectToServer(event.partyUrl);
      emit(PartyJoined());
    } catch (e) {
      emit(PartyError(e.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<PartyState> emit) async {
    try {
      _webSocketService.sendMessage(event.message);
    } catch (e) {
      emit(PartyError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _webSocketService.dispose();
    return super.close();
  }
}