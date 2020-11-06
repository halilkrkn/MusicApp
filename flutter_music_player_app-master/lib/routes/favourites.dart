import 'package:flutter/material.dart';
import 'package:flutter_music_player_app/models/PlayerArguments.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    playListCard("assets/notimetodiebe.jpg", "No Time To Die",
                        "Billie Eilish", "4:02"),
                    SizedBox(
                      height: 20.0,
                    ),
                    playListCard("assets/dontdualipa.jpg", "Don\'t start now",
                        "Dua Lipa", "4:02"),
                    SizedBox(
                      height: 20.0,
                    ),
                    playListCard("assets/notimetodiebe.jpg", "Godzilla",
                        "Eminem", "4:02"),
                    SizedBox(
                      height: 20.0,
                    ),
                    playListCard("assets/bellyache.jpeg", "Belly Ache",
                        "Billie Eilish", "4:02"),
                  ],
                ),
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
