import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  //constructor
  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    _socket = IO.io(
        'http://10.0.2.2:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());

    _socket.onConnect((_) {
      print('connected');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      print('disconnected');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket.on('new-message', (payload) {
      print(payload.containsKey('name') ? payload['name'] : '');
      print(payload.containsKey('message') ? payload['message'] : '');
      print(
          payload.containsKey('secondMessage') ? payload['secondMessage'] : '');
    });

    _socket.on('serverMessage', (payload) {
      print('server: $payload');
    });
  }
}
