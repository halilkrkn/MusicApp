import 'package:flutter/material.dart';
import 'package:flutter_music_player_app/SizeConfig.dart';
import 'package:flutter_music_player_app/albums.dart';
import 'package:flutter_music_player_app/artists.dart';
import 'package:flutter_music_player_app/player.dart';

import 'folders.dart';


class MusicHome extends StatefulWidget {
  MusicHome({Key key}) : super(key: key);

  @override
  _MusicHomeState createState() => _MusicHomeState();
}

class _MusicHomeState extends State<MusicHome> with SingleTickerProviderStateMixin{
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.only(left: 20.0, top: 30.0),
            child: Text("Browse", style: TextStyle(
              color: Colors.black,
              fontFamily: 'Nunito-Regular',
              fontSize: 40
            ),),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 30.0),
            child: TabBar(
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
            ]),
          ),
          Expanded(
            child: Container(
              child: TabBarView(
                controller: tabController,
                  children: <Widget>[
                    Albums(),
                    Artists(),
                    Folders(),
                  ]),
            ),
          )
        ],
      ),

    );
  }
}