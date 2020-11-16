import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_music_player_app/models/Song.dart';
import 'package:flutter_music_player_app/routes/musichome.dart';
import 'dart:async';

import 'package:flutter_music_player_app/screens/player.dart';

class Albums extends StatefulWidget {
  Albums({Key key, this.title, this.audioPlayer) : super(key: key);
  final AudioPlayer audioPlayer;
  final String title;
  final musichome = MusicHome();
  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {

  bool havefavourite = false;
  double height = 150;
  int i = 0;
  bool songsadded = false;
  List<Song> songs = [];

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  Future<List<Song>> getSongProperties() async {
    var songsquery = await audioQuery.getSongs();
    if(songsadded == false) {
      for (var s in songsquery) {
        Song tempsong = Song(s.id, s.title, s.artist, s.duration,s.filePath,s.albumArtwork);
        songs.add(tempsong);
      }
      songsadded = true;
    }
    print(songs.length);
  }

  @override
  void initState() {
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

  Widget getPlaylistList(){
    return FutureBuilder(
      future: getSongProperties(),
      builder: (context,AsyncSnapshot snapshot){
        if(songs.length <= 0){
          return Center(child: Container(
            height: 50,
              width: 50,
              child: CircularProgressIndicator()));
        }
        else{
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (BuildContext context,int index){
              return Padding(padding: EdgeInsets.fromLTRB(8, 0, 8, 8),child : playListCard("assets/godzillaeminem.png" ,songs[index].title,songs[index].artist,songs[index].duration,songs[index].url,index));
            },
          );
        }
      },
    );
  }

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


  playListCard(String asset, String title, String artist, String duration,String url,int index) {
    final alreadySaved = favourites.contains(title);
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Player(singer: artist,songName: title,duration: duration,songPath: url,image: asset,player: widget.audioPlayer,playlistsongs: songs,index: index,)),
        );
      },
      child: Container(
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(asset, fit: BoxFit.cover, height:70, width: 90,),
            ),
            SizedBox(width: 10.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title.length > 20 ? title.substring(0,20) : title, style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),),
                Text(artist.length > 15 ? artist.substring(0,15) : artist, style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  color: Colors.black,
                ),),
              ],
            ),
            Spacer(),
            Text(formatMillitoDisplay(duration), style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 20,
                color: Colors.black
            ),),
            SizedBox(width: 15.0,),
            InkWell(
              onTap: (){
                setState(() {
                  if (alreadySaved) {
                    favourites.remove(asset);
                  } else {
                    favourites.add(asset);
                  }
                });
              },
              child: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
              ),
            ),
          ],
        ),
      ),
    );
  }


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