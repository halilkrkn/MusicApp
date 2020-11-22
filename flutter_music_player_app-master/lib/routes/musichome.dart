import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_music_player_app/models/Song.dart';
import 'package:flutter_music_player_app/routes/favourites.dart';
import 'package:flutter_music_player_app/screens/loadingScreen.dart';
import 'package:flutter_music_player_app/screens/player.dart';
import 'package:marquee/marquee.dart';
import 'albums.dart';
import 'artists.dart';
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
  AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();
  bool songsadded = false;
  List<Song> songs = [];
  List<Audio> audiosongs = [];
  String title;
  String artist;
  int index;
  bool loaded = false;
  final List<StreamSubscription> _subscriptions = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this,initialIndex: widget.initialPage);
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _subscriptions.add(player.current.listen((data) {
      setState(() {
        index = data.index;
      });
    }));
    _subscriptions.add(player.playlistAudioFinished.listen((data) {
      setState(() {
        index = data.index+1;
      });
    }));
    _subscriptions.add(player.current.listen((data) {
      setState(() {
        title = data.audio.audio.metas.title;
        artist = data.audio.audio.metas.artist;
      });
    }));
    _subscriptions.add(player.onReadyToPlay.listen((audio) {
      print("onRedayToPlay : $audio");
      setState(() {
        title = audio.audio.metas.title;
        artist = audio.audio.metas.artist;
      });
    }));
  }



  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  Future<List<Audio>> getSongProperties() async {
    var songsquery = await audioQuery.getSongs();
    if(songsadded == false) {
      for (var s in songsquery) {
        Song tempsong = Song(s.id, s.title, s.artist, s.duration,s.filePath,s.albumArtwork);
        songs.add(tempsong);
      }
      songsadded = true;
    }
    for(Song s in songs){
      Audio temp = new Audio.file(s.url,metas:Metas(
          title: s.title,
          artist: s.artist,
          image: MetasImage.file("assets/billieellish.jpg")
      ));
      audiosongs.add(temp);
    }
    return audiosongs;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: getSongProperties(),
      builder: (context,AsyncSnapshot snapshot){
        if(songs.length <= 0){
          return loadingScreen(); //şarkıları alırken yükleme ekranı göster
        }
        else{
          return loadedWidget(width); //eğer şarkılar çekilmişse ekran gelsin
        }
      },
    );
  }

  Widget loadedWidget(width){
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
                    Albums(audioPlayer: player,songs: songs,audiosongs: audiosongs,),
                    Artists(),
                    Folders(),
                    Favourites(),
                  ]),
            ),
          ),
          (player.playerState.value == PlayerState.play || player.playerState.value == PlayerState.pause) ? bottomMusicBar(width) : Container(),
        ],
      ),

    );
  }

  Widget bottomMusicBar(width){
    return Align(
      alignment: Alignment.bottomCenter,
      child:  InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Player(image: audiosongs[index].metas.image.path,player:player,songs: audiosongs,index: index,isplaying:true,)),
          );
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
                  _albumCard(audiosongs[index].metas.image.path),
                  SizedBox(width: 10.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          height: 28,
                          width: MediaQuery.of(context).size.width/2+50,
                          child : Marquee(
                            text: title,
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            blankSpace: 10.0,
                            velocity: 30.0,
                            pauseAfterRound: Duration(seconds: 1),
                            startPadding: 0.0,
                            accelerationDuration: Duration(seconds: 2),
                            accelerationCurve: Curves.linear,
                            decelerationDuration: Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,
                          )
                      ),
                      Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width/2+40,
                          child : Marquee(
                            text: artist,
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                            scrollAxis: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            blankSpace: 10.0,
                            velocity: 30.0,
                            pauseAfterRound: Duration(seconds: 1),
                            startPadding: 0.0,
                            accelerationDuration: Duration(seconds: 2),
                            accelerationCurve: Curves.linear,
                            decelerationDuration: Duration(milliseconds: 500),
                            decelerationCurve: Curves.easeOut,
                          )
                      ),
                    ],
                  ),
                  Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.black87,
                    radius: 26.0,
                    child: IconButton(
                      iconSize: 28,
                      color: Colors.white,
                      icon: AnimatedIcon(icon: AnimatedIcons.pause_play, progress: animationController),
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
      player.playOrPause();

      if(player.playerState.value == PlayerState.play){
        animationController.forward();
      }
      else if(player.playerState.value == PlayerState.pause){

        animationController.reverse();
      }

    });
  }

  void _nextPage(int tab) {
    final int newTab = tabController.index + tab;
    if (newTab < 0 || newTab >= tabController.length) return;
    tabController.animateTo(newTab);
  }


}