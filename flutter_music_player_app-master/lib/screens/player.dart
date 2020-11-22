import 'dart:async';
import 'dart:convert';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:marquee/marquee.dart';

class Player extends StatefulWidget {
  Player({Key key,this.image, this.player, this.songs, this.index, this.isplaying}) : super(key: key);
  final String image;
  final AssetsAudioPlayer player;
  final List<Audio> songs;
  final int index;
  final bool isplaying;
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> with SingleTickerProviderStateMixin{

  int durationOnPause = 0;
  String albumImage;
  AssetsAudioPlayer audioPlayer;
  Playlist playList;
  int index;
  GlobalKey<FlipCardState> cardKey;
  List<Audio> audiosongs;
  String title;
  String artist;
  bool isplaying;
  final List<StreamSubscription> _subscriptions = [];
  String lyrics;
  AnimationController animationController;
  bool isPlaying = true;
  Duration _duration;
  Duration _position;
  bool lyricsfetched = false;

  @override
  void initState() {
    // TODO: implement initState
    //müziğin detaylarını alıyorum
    albumImage = widget.image;
    audioPlayer = widget.player;
    index = widget.index;
    audiosongs = widget.songs;
    isplaying = widget.isplaying;
    print(index);
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    if(isplaying == false){
      audioPlayer.open(
        Playlist(
          audios: audiosongs,
          startIndex: index,
        ),
        loopMode: LoopMode.playlist,
        showNotification: true,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        //loop the full playlist
      );
    }
    _subscriptions.add(audioPlayer.playlistFinished.listen((data) {
    }));
    _subscriptions.add(audioPlayer.playlistAudioFinished.listen((data) {
      title = data.audio.audio.metas.title;
      artist = data.audio.audio.metas.artist;
    }));
    _subscriptions.add(audioPlayer.current.listen((data) {
      setState(() {
        _duration = data.audio.duration;
        title = data.audio.audio.metas.title;
        artist = data.audio.audio.metas.artist;
      });
    }));
    _subscriptions.add(audioPlayer.onReadyToPlay.listen((audio) {
      print("onRedayToPlay : $audio");
      setState(() {
        title = audio.audio.metas.title;
        artist = audio.audio.metas.artist;
        _duration = audio.duration;
      });
    }));
    _subscriptions.add(audioPlayer.currentPosition.listen((position) {
      setState(() {
        _position = position;
      });
    }));
    cardKey = GlobalKey<FlipCardState>();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  Future<String> _getSongLyrics(String title,String artist) async {
    var formattitle;
    var formatartist;
    if(title.contains('-')){
      var splittedtitle = title.split('-');
      formatartist = splittedtitle[0].replaceRange(splittedtitle[0].length-1, splittedtitle[0].length, '');
      formattitle = splittedtitle[1].replaceRange(0, 1, '');
    }
    else{
      formattitle = title.replaceAll(' ', "%20");
      formatartist = artist.replaceAll(' ', "%20");
    }
    print('title:'+title+'artist:'+artist);
    var songlyric;
    final String uri = "https://orion.apiseeds.com/api/music/lyric/$formatartist/$formattitle?apikey=uF0lVgHOgQTMZGpYbS5IOzngYwfnqXM33tWCzlPsOtOOcC67CT23mLAEdepBypRn";
    print(uri);
    final responseData = await http.get(uri,headers: {"Accept": "application/json"});
    if(responseData.statusCode == 200){
      var convertToJson = jsonDecode(responseData.body);
      if(convertToJson!=null)
        songlyric = convertToJson['result']['track']['text'];
      print(songlyric);
    }
    else{
      songlyric = "Lyrics Not Found";
    }
    return songlyric;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      onTap:(){
                        Navigator.pop(context);
                      },//geri tuşuna basıldığında songs kısmına dönmek için
                      child: Icon(Icons.arrow_back_ios, color: Colors.black,)),
                  Text("NOW PLAYING", style: TextStyle(
                      fontFamily: 'Nunito-Bold',
                      letterSpacing: 1.0,
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),),
                  Icon(Icons.more_vert, color: Colors.black,)
                ],
              ),
            ),
            Spacer(),
            FlipCard(
              key: cardKey,
              flipOnTouch: false,
              front: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(albumImage, fit: BoxFit.cover, //müziğin resmi
                  height: 300,
                  width: 300,),
              ),
              back: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0), //buradaki cliprrectin içine yazıyı yaz
                  child: Container(
                    height: 300,
                    width: 300,
                    color: Colors.orange,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: _setLyricsStatus(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ),
            ),
            SizedBox(height: 20.0,),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  color: Colors.orange.withOpacity(0.5),
                  width: 160,
                  child: InkWell(
                    onTap: () async{
                      var connectivityResult = await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.none) {
                        lyrics = "You're not Connected To Internet";
                      } else {
                        if(lyricsfetched == false){
                          _getSongLyrics(title,artist).then((String result){
                            setState(() {
                              lyrics = result;
                              lyricsfetched = true;
                            });
                          });
                        }
                      }
                      cardKey.currentState.toggleCard();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8,left: 8),
                      child: Row(
                        children: [
                          Icon(Icons.music_note_outlined),
                          SizedBox(width: 10,),
                          Text("Tap To See The Lyrics!" , style: TextStyle( //müzik başlığı
                              fontFamily: 'Nunito-Bold',
                              letterSpacing: 1.0,
                              fontSize: 8,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            title == null ? Container(height: 40,) :
            Container(
                height: 40,
                width: MediaQuery.of(context).size.width-30,
                child : Marquee(
                  text: title,
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 35,
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
            SizedBox(height: 10,),
            Text(artist == null ? "" : artist, style: TextStyle( //şarkıcı
              fontFamily: 'Nunito-Bold',
              letterSpacing: 1.0,
              fontSize: 15,
              color: Colors.black,
            ),),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
              child: Row(
                children: [
                  Text(_position == null ? "00:00" : formatMillitoDisplay(_position.inMilliseconds.toString()), style: TextStyle( //şarkıcı
                    fontFamily: 'Nunito-Bold',
                    letterSpacing: 1.0,
                    fontSize:10,
                    color: Colors.black,
                  ),),
                  SizedBox(
                    width: MediaQuery.of(context).size.width-100,
                    child: Slider(
                      activeColor: Colors.orangeAccent,
                      value: (_position != null &&
                          _duration != null &&
                          _position.inMilliseconds > 0 &&
                          _position.inMilliseconds < _duration.inMilliseconds)
                          ? _position.inMilliseconds / _duration.inMilliseconds
                          : 0.0,
                      inactiveColor: Colors.grey,
                      onChanged: (v) {
                        final Position = v * _duration.inMilliseconds;
                        audioPlayer.seek(Duration(milliseconds: Position.round()));
                      },
                    ),
                  ),
                  Text(_duration == null ? "00:00" : formatMillitoDisplay(_duration.inMilliseconds.toString()), style: TextStyle( //şarkıcı
                    fontFamily: 'Nunito-Bold',
                    letterSpacing: 1.0,
                    fontSize: 10,
                    color: Colors.black,
                  ),),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0,bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap : () async{ //geri tuşu
                      audioPlayer.previous(keepLoopMode: true);
                      setState(() { //tıklandığında müziğin isminin, albüm resminin ve sarkıcısının değişmesi
                        title = audioPlayer.current.value.audio.audio.metas.title;
                        artist = audioPlayer.current.value.audio.audio.metas.artist;
                        lyrics = null;
                        lyricsfetched = false;
                        if(cardKey.currentState.isFront == false)
                          cardKey.currentState.toggleCard();
                      });
                      print(index);
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.white10,
                        radius: 20.0,
                        child:  Icon(Icons.fast_rewind, color: Colors.black,)),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.black87,
                    radius: 40.0,
                    child: IconButton(
                      iconSize: 50,
                      color: Colors.white,
                      icon: AnimatedIcon(icon: AnimatedIcons.pause_play, progress: animationController),
                      onPressed: () async{
                        _handleOnPressed();
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      //ileri gitmek için geri gitmeyle aynı
                      audioPlayer.next(keepLoopMode:true);
                      setState(() {
                        title = audioPlayer.current.value.audio.audio.metas.title;
                        artist = audioPlayer.current.value.audio.audio.metas.artist;
                        lyrics = null;
                        lyricsfetched = false;
                        if(cardKey.currentState.isFront == false)
                          cardKey.currentState.toggleCard();
                      });
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.white10,
                        radius: 20.0,
                        child:  Icon(Icons.fast_forward, color: Colors.black,)
                    ),
                  ),
                ],
              ),
            )
          ],
        ),

      ),
    );
  }

  Widget _setLyricsStatus(){
    if(lyrics == null)
      return Padding(
        padding: const EdgeInsets.only(top: 110),//boyut/2-45
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10,),
            Text("Loading Lyrics" , style: TextStyle( //müzik başlığı
                fontFamily: 'Nunito-Bold',
                letterSpacing: 1.0,
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),),
          ],
        ),
      );
    else if(lyrics == "You're not Connected To Internet"){
      return Padding(
        padding: const EdgeInsets.only(top: 130),//boyut/2-45
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("You're not Connected To Internet" , style: TextStyle( //müzik başlığı
                fontFamily: 'Nunito-Bold',
                letterSpacing: 1.0,
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),),
          ],
        ),
      );
    }
    else
      return Text(lyrics , style: TextStyle( //müzik başlığı
          fontFamily: 'Nunito-Bold',
          letterSpacing: 1.0,
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold
      ),);
  }

  String formatMillitoDisplay(String toformat){
    Duration duration = new Duration(minutes: 0,seconds: 0,milliseconds: int.parse(toformat));
    String durationstring =  duration.toString().split('.')[0];
    List<String> durationlist = durationstring.split(':');
    return durationlist[1]+":"+durationlist[2];
  }



  Future<bool> _onBackPressed() async{
    Navigator.pop(context); //geri tuşuna basıldığında songs kısmına dönmek için
    return true;
  }

  void _handleOnPressed(){ //oynat durdur basıldığında çalışan kısım
    setState(() async {
      audioPlayer.playOrPause();

      if(audioPlayer.playerState.value == PlayerState.play){
        animationController.forward();
      }
      else if(audioPlayer.playerState.value == PlayerState.pause){

        animationController.reverse();
      }

    });
  }
}
