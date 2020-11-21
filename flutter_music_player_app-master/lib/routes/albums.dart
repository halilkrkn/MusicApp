import 'dart:ffi';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_music_player_app/models/Song.dart';
import 'package:flutter_music_player_app/routes/musichome.dart';

import 'package:flutter_music_player_app/screens/player.dart';

class Albums extends StatefulWidget {
  Albums({Key key, this.title, this.audioPlayer, this.songs}) : super(key: key);
  final AssetsAudioPlayer audioPlayer;
  final String title;
  final List<Song> songs;
  final musichome = MusicHome();
  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {

  bool havefavourite = false;
  double height = 150;
  List<Song> songs;
  @override
  void initState() {
    songs = widget.songs;
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
        return playListCard("assets/godzillaeminem.png",index);
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
          MaterialPageRoute(builder: (context) => Player(image: asset,player:widget.audioPlayer,songs: songs,index: index,)),
        );
      },
      child: Container(
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(asset, fit: BoxFit.cover, height:70, width: 70,),
            ),
            SizedBox(width: 10.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(songs[index].title.length > 20 ? songs[index].title.substring(0,20) : songs[index].title, style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),),
                Text(songs[index].artist.length > 15 ? songs[index].artist.substring(0,15) : songs[index].artist, style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  color: Colors.black,
                ),),
              ],
            ),
            Spacer(),
            Text(formatMillitoDisplay(songs[index].duration), style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 20,
                color: Colors.black
            ),),
            SizedBox(width: 15.0,),
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