import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player_app/screens/player.dart';
import 'package:marquee/marquee.dart';

class Folders extends StatefulWidget {
  Folders({this.audiolist, this.foldernames, this.player,});
  final List<List<Audio>> audiolist;
  final List<String> foldernames;
  final AssetsAudioPlayer player;
  @override
  _FoldersState createState() => _FoldersState();
}

class _FoldersState extends State<Folders> {

  List<String> folders;
  List<List<Audio>> foldersongs;
  bool clicked = false;
  int _index;
  AssetsAudioPlayer player;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foldersongs = widget.audiolist;
    folders = widget.foldernames;
    player = widget.player;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: bodyElement(),
    );
  }

  Widget bodyElement(){
    if(clicked == false){
      return Column(
        children: [
          Expanded(child: ListView.builder(
            itemCount: folders.length,
            itemBuilder: (BuildContext context,int index){
              return Padding(padding: EdgeInsets.only(left: 12,right: 12),child: folderCards("assets/folder.png",folders[index],index),);
            },
          )),
        ],
      );
    }
    else{
      return WillPopScope(
        onWillPop: _onBackPressed,
        child :Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width/12,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: (){
                    setState(() {
                      clicked = !clicked;
                    });
                  },
                  child: Container(
                    width: 40,
                      height: 40,
                      child: Icon(Icons.arrow_back, color: Colors.black,)),
                ),
              ),
            ),
          ),
          Expanded(child:ListView.builder(
            itemCount: foldersongs[_index].length,
            itemBuilder: (BuildContext context,int index){
              return Padding(padding: EdgeInsets.only(left: 12,right: 12),child: playListCard("assets/billieellish.jpg",index,foldersongs[_index]));
            },
          )
          ),
        ],
      ),
    );
    }
  }

  folderCards(String asset,String foldername,int index) {
    //final alreadySaved = favourites.contains(title);
    return Container(
      child: Padding(
        padding: index == 0 ? const EdgeInsets.only(top: 0,bottom: 4) : const EdgeInsets.only(top: 4,bottom: 4),
        child: InkWell(
          onTap: (){
            setState(() {
              clicked = !clicked;
              _index = index;
            });
          },
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(asset, fit: BoxFit.cover, height:MediaQuery.of(context).size.width/8, width: MediaQuery.of(context).size.width/7,),
              ),
              SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width*2/3,
                    child: Text(foldername, style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 20,
                      color: Colors.black,
                    ),),
                  ),
                ],
              ),
              Icon(Icons.more_vert, color: Colors.black,),
            ],
          ),
        ),
      ),
    );
  }

  playListCard(String asset,int index,List<Audio> audiosongs) {
    //final alreadySaved = favourites.contains(title);
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Player(image: asset,player:player,songs: audiosongs,index: index,isplaying: false,)),
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
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width/2,
                      child : Marquee(
                        text: audiosongs[index].metas.title,
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
                    child: Text(audiosongs[index].metas.artist.length > 20 ? audiosongs[index].metas.artist.substring(0,20) : audiosongs[index].metas.artist,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 20,
                      color: Colors.black,
                    ),),
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: (){
//favori kısmı
                },
                child: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async{
    setState(() {
      clicked = !clicked;
    });
  }
}
