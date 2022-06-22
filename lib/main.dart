import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './services/socket_service.dart';

import './screens/home_screen.dart';
import './screens/status_screen.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (BuildContext context) => SocketService(),
      )
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Band Names",
      initialRoute: 'home-screen',
      routes: {
        'home-screen': (_) => HomeScreen(),
        'status-screen': (_) => StatusScreen(),
      },
    );
  }
}
