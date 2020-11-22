import 'dart:ffi';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_music_player_app/models/Song.dart';
import 'package:flutter_music_player_app/routes/musichome.dart';

import 'package:flutter_music_player_app/screens/player.dart';
import 'package:marquee/marquee.dart';

class Albums extends StatefulWidget {
  Albums({Key key, this.title, this.audioPlayer, this.songs, this.audiosongs}) : super(key: key);
  final AssetsAudioPlayer audioPlayer;
  final String title;
  final List<Song> songs;
  final List<Audio> audiosongs;
  final musichome = MusicHome();
  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {

  bool havefavourite = false;
  double height = 150;
  List<Song> songs;
  List<Audio> audiosongs;
  @override
  void initState() {
    songs = widget.songs;
    audiosongs = widget.audiosongs;
    // TODO: implement initState
   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 0, 10),
          child: Container(
            // Songs Kısmı
            child : Text("Songs", textAlign: TextAlign.left,style: TextStyle(
                color: Colors.black,
                fontFamily: 'Nunito-Regular',
                fontSize: 35,
            ),),
          ),
        ),
        Expanded(child: Padding(padding: EdgeInsets.fromLTRB(8, 0, 8, 0),child: getPlaylistList(),)),
      ],
    );
  }

  // Play List
  Widget getPlaylistList(){
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (BuildContext context,int index){
        return playListCard(audiosongs[index].metas.image.path,index);
      },
    );
  }



  // Songs - PLayList Kısmı
  playListCard(String asset,int index) {
    //final alreadySaved = favourites.contains(title);
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Player(image: asset,player:widget.audioPlayer,songs: audiosongs,index: index,isplaying: false,)),
        );
      },
      child: Container(
        child: Padding(
          padding: index == 0 ? const EdgeInsets.only(top: 0,bottom: 4) : const EdgeInsets.only(top: 4,bottom: 4),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(asset, fit: BoxFit.cover, height:MediaQuery.of(context).size.width/6, width: MediaQuery.of(context).size.width/5,),
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width/2,
                      child : Marquee(
                        text: songs[index].title,
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 10.0,
                        velocity: 40.0,
                        pauseAfterRound: Duration(seconds: 1),
                        startPadding: 0.0,
                        accelerationDuration: Duration(seconds: 2),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                      )
                  ),
                  Container(
                    child: Text(songs[index].artist.length > 15 ? songs[index].artist.substring(0,15) : songs[index].artist, style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 20,
                      color: Colors.black,
                    ),),
                  ),
                ],
              ),
              Spacer(),
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width/6,
                child: Text(formatMillitoDisplay(songs[index].duration), style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    color: Colors.black
                ),),
              ),
              InkWell(
                onTap: (){
                  //favori kısmı
                },
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Şarkıları Favorileme Kısmı
  Widget favoritesListView(index){
    return Row(children: <Widget>[

      _albumCard(favourites[index]),
      SizedBox(width: 10.0,),
    ],);
  }

  List<String> favourites = [
  ];

  Widget _favouriteEmpty() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.asset("assets/favourite.jpg", fit: BoxFit.cover, height: 150,width: 150, ),
      ),
    );
  }

  // Albüm Card Kısmı
  _albumCard(String assetImg) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0)
      ),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset(assetImg, fit: BoxFit.cover, height: 150,width: 150, ),
          ),
          Positioned(
            bottom: 10.0,
            left: 10.0,
            child: CircleAvatar(
              backgroundColor: Colors.white70,
              child: Icon(Icons.play_arrow, color: Colors.white,),
            ),
          )
        ],
      ),
    );
  }


  // Daha Fazla Albüm İÇin Albumler Kısmına Yönlendirme
  _seeMoreAlbumCard(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return MusicHome(initialPage: 3,);
        }),
        );
        },
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0)
        ),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset("assets/More.jpg", fit: BoxFit.cover, height: 150,width: 150, ),
            ),
            Positioned(
              bottom: 10.0,
              left: 10.0,
              child: InkWell(
                onTap: (){

                },
                child: CircleAvatar(
                  backgroundColor: Colors.white70,
                  child: Icon(Icons.play_arrow, color: Colors.white,),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String formatMillitoDisplay(String toformat){
    Duration duration = new Duration(minutes: 0,seconds: 0,milliseconds: int.parse(toformat));
    String durationstring =  duration.toString().split('.')[0];
    List<String> durationlist = durationstring.split(':');
    return durationlist[1]+":"+durationlist[2];
  }



}