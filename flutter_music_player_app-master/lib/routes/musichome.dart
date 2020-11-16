import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player_app/models/GetSongs.dart';
import 'package:flutter_music_player_app/models/PlayerArguments.dart';
import 'package:flutter_music_player_app/models/PlayerNowPlaying.dart';
import 'package:flutter_music_player_app/routes/favourites.dart';
import 'package:flutter_music_player_app/screens/player.dart';
import 'file:///C:/Users/turk_/Desktop/flutter_music_player_app-master/lib/routes/albums.dart';
import 'file:///C:/Users/turk_/Desktop/flutter_music_player_app-master/lib/routes/artists.dart';
import 'folders.dart';


class MusicHome extends StatefulWidget {
  MusicHome({Key key,@required this.initialPage}) : super(key: key);
  final int initialPage;
  @override
  _MusicHomeState createState() => _MusicHomeState();
}

class _MusicHomeState extends State<MusicHome> with TickerProviderStateMixin{
  static TabController tabController;
  AnimationController animationController;
  bool isPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();
  NowPlayingSong nw;
  StreamSubscription _onPlayerStateChanged;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this,initialIndex: widget.initialPage);
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _onPlayerStateChanged =  audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        if(state == AudioPlayerState.PAUSED)
          animationController.reverse();
        else if(state == AudioPlayerState.PLAYING)
          animationController.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.search, color: Colors.black,),
                Spacer(),
                Icon(Icons.more_vert, color: Colors.black,),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 10),
            child: Text("Browse", style: TextStyle(
              color: Colors.black,
              fontFamily: 'Nunito-Regular',
              fontSize: 40
            ),),
          ),

          TabBar(
            controller: tabController,
            indicatorColor: Colors.blue[900],
              indicatorWeight: 2.0,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.black,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold
              ),
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              tabs: <Widget>[
                Tab(
                  child: Text("ALBUMS", style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Nunito'
                  ),),
                ),
                Tab(
                  child: Text("ARTISTS", style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Nunito'
                  ),),
                ),
                Tab(
                  child: Text("FOLDERS", style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Nunito'
                  ),),
                ),
                Tab(
                  child: Text("FAVOURITES", style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Nunito'
                  ),),
                ),
          ]),
          Expanded(
            child: Container(
              child: TabBarView(
                controller: tabController,
                  children: <Widget>[
                    Albums(audioPlayer: audioPlayer),
                    Artists(),
                    Folders(),
                    Favourites(),
                  ]),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:  InkWell(
              onTap: (){
              },
              child: ClipRRect(
                borderRadius: BorderRadius.only(topRight: Radius.circular(15.0),topLeft: Radius.circular(15.0)),
                child: Container(
                  height: 65,
                  width : width,
                  color: Colors.orange,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _albumCard("assets/dontdualipa.jpg"),
                        SizedBox(width: 10.0,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Music Name', style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),),
                            Text('artist', style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 15,
                              color: Colors.black,
                            ),),
                          ],
                        ),
                        Spacer(),
                        CircleAvatar(
                          backgroundColor: Colors.black87,
                          radius: 26.0,
                          child: IconButton(
                            iconSize: 36,
                            color: Colors.white,
                            icon: AnimatedIcon(icon: AnimatedIcons.play_pause, progress: animationController),
                            onPressed: (){
                              _handleOnPressed();
                            },
                          ),
                        ),
                        SizedBox(width: 10.0,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }

  _albumCard(String assetImg) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Image.asset(assetImg, fit: BoxFit.cover, height: 50,width: 50, ),
      ),
    );
  }

  void _handleOnPressed(){ //oynat durdur basıldığında çalışan kısım
    setState(() async {
      var state = audioPlayer.state;
      if(state == AudioPlayerState.PAUSED){
        await audioPlayer.resume();
        animationController.reverse();
      }
      else if(state == AudioPlayerState.PLAYING){
        await audioPlayer.pause();
        animationController.forward();
      }
    });
  }

  void _nextPage(int tab) {
    final int newTab = tabController.index + tab;
    if (newTab < 0 || newTab >= tabController.length) return;
    tabController.animateTo(newTab);
  }


}