import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class StatusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.blue[300],
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            '${socketService.serverStatus}',
            style: TextStyle(fontSize: 30),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.socket.emit('new-message',
              {'name': 'flutter', 'message': 'hello from flutter'});
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
