import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  WebSocketChannel? _channel;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  Future<void> createServer(int port) async {
    // In a real implementation, we would create a WebSocket server
    // For now, we'll simulate it
    await Future.delayed(const Duration(seconds: 1));
    return;
  }

  Future<void> connectToServer(String url) async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel!.stream.listen(
        (message) {
          final decodedMessage = json.decode(message as String);
          _messageController.add(decodedMessage as Map<String, dynamic>);
        },
        onError: (error) {
          throw Exception('WebSocket connection error: $error');
        },
        onDone: () {
          _messageController.add({'type': 'disconnected'});
        },
      );
    } catch (e) {
      throw Exception('Failed to connect to WebSocket server: $e');
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_channel != null) {
      _channel!.sink.add(json.encode(message));
    }
  }

  void dispose() {
    _channel?.sink.close(status.goingAway);
    _messageController.close();
  }
}
