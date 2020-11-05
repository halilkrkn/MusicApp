import 'package:flutter/material.dart';
import 'package:flutter_music_player_app/routes/musichome.dart';
import 'package:flutter_music_player_app/screens/player.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: Colors.orange, // status bar color
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/home',
      routes: {
        '/home': (context) => MusicHome(initialPage:0),
        '/player': (context) => Player(),
      },
    );
  }
}