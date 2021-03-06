import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_music_player_app/routes/musichome.dart';
import 'package:flutter_music_player_app/screens/loadingScreen.dart';
import 'package:flutter_music_player_app/screens/player.dart';
import 'package:flutter/services.dart';
import 'package:assets_audio_player/assets_audio_player.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // navigation bar color
    statusBarColor: Colors.orange, // status bar color
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  const MyApp({Key key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/home',
      routes: {
        '/loading': (context) => loadingScreen(),
        '/player': (context) => Player(),
        '/home': (context) => MusicHome(initialPage:0,),
      },
    );
  }
}