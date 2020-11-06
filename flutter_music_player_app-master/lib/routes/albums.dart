import 'package:flutter/material.dart';
import 'file:///C:/Users/turk_/Desktop/flutter_music_player_app-master/lib/models/PlayerArguments.dart';
import 'package:flutter_music_player_app/routes/musichome.dart';

class Albums extends StatefulWidget {
  Albums({Key key, this.title}) : super(key: key);

  final String title;
  final musichome = MusicHome();
  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(left: 20.0,top: 30),
              child: Text("Favourites", style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Nunito-Regular',
                  fontSize: 20
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0),
              child: Container(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    _albumCard("assets/billiebadguy.jpg"),
                    SizedBox(width: 10.0,),
                    _albumCard("assets/godzillaeminem.png"),
                    SizedBox(width: 10.0,),
                    _albumCard("assets/notimetodiebe.jpg"),
                    SizedBox(width: 10.0,),
                    _albumCard("assets/billiebadguy.jpg"),
                    SizedBox(width: 10.0,),
                    _albumCard("assets/godzillaeminem.png"),
                    SizedBox(width: 10.0,),
                    _albumCard("assets/notimetodiebe.jpg"),
                    SizedBox(width: 10.0,),
                    _seeMoreAlbumCard(context),
                    SizedBox(width: 10.0,),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20.0,top: 30),
              child: Text("Songs", style: TextStyle(
                color: Colors.black,
                fontFamily: 'Nunito-Regular',
                fontSize: 30
              ),),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    playListCard("assets/notimetodiebe.jpg", "No Time To Die", "Billie Eilish", "4:02"),
                    SizedBox(height: 20.0,),
                    playListCard("assets/dontdualipa.jpg", "Don\'t start now", "Dua Lipa", "4:02"),
                    SizedBox(height: 20.0,),
                    playListCard("assets/notimetodiebe.jpg", "Godzilla", "Eminem", "4:02"),
                    SizedBox(height: 20.0,),
                    playListCard("assets/bellyache.jpeg", "Belly Ache", "Billie Eilish", "4:02"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),

    );
  }

  _albumCard(String assetImg) {
    return Container(
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
              child: CircleAvatar(
                backgroundColor: Colors.white70,
                child: Icon(Icons.play_arrow, color: Colors.white,),
              ),
            )
          ],
        ),
      ),
    );
  }

  playListCard(String asset, String albumName, String artist, String duration) {
    return InkWell(
      onTap: (){
        Navigator.pushReplacementNamed(
          context,
          '/player',
          arguments: PlayerArguments(
            albumName,artist,
          ),
        );
      },
      child: Container(
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(asset, fit: BoxFit.cover, height:100, width: 120,),
            ),
            SizedBox(width: 20.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(albumName, style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),),
                Text(artist, style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 20,
                    color: Colors.black,
                ),),
              ],
            ),
            Spacer(),
            Text(duration, style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 20,
              color: Colors.black
            ),),
            SizedBox(width: 20.0,),
            Icon(Icons.favorite_border, color: Colors.black,)
          ],
        ),
      ),
    );
  }
}