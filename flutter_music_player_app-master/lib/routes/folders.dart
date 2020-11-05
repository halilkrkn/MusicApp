import 'package:flutter/material.dart';

class Folders extends StatefulWidget {
  @override
  _FoldersState createState() => _FoldersState();
}

class _FoldersState extends State<Folders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      foldersCards("No Time To Die", "Billie Eilish", "4:02"),
                      SizedBox(height: 20.0,),
                      foldersCards("Don\'t start now", "Dua Lipa", "4:02"),
                      SizedBox(height: 20.0,),
                      foldersCards("Godzilla", "Eminem", "4:02"),
                      SizedBox(height: 20.0,),
                      foldersCards("Belly Ache", "Billie Eilish", "4:02"),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }

  foldersCards(String albumName, String artist, String duration) {
    return Container(
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset("assets/folder.png", fit: BoxFit.cover, height:50, width: 60,),
          ),
          SizedBox(width: 20.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(albumName, style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),),
              Text(artist, style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 10,
                color: Colors.black,
              ),),
            ],
          ),
          Spacer(),
          Icon(Icons.more_vert, color: Colors.black,)
        ],
      ),
    );
  }

}
