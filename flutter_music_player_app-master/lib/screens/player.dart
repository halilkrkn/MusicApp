import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_player_app/models/Song.dart';


class Player extends StatefulWidget {
  Player({Key key,this.image, this.player, this.songs, this.index}) : super(key: key);
  final String image;
  final AssetsAudioPlayer player;
  final List<Song> songs;
  final int index;
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
  final List<StreamSubscription> _subscriptions = [];

  AnimationController animationController;
  bool isPlaying = true;
  Duration _duration;
  Duration _position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //müziğin detaylarını alıyorum
    albumImage = widget.image;
    audioPlayer = widget.player;

    getAudios().then((List<Audio> result){
    });
    index = widget.index;
    print(index);
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

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
    _subscriptions.add(audioPlayer.playlistFinished.listen((data) {
    }));
    _subscriptions.add(audioPlayer.playlistAudioFinished.listen((data) {
      title = data.audio.audio.metas.title;
      artist = data.audio.audio.metas.artist;
    }));
    _subscriptions.add(audioPlayer.current.listen((data) {
      _duration = data.audio.duration;
      title = data.audio.audio.metas.title;
      artist = data.audio.audio.metas.artist;
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
  }

  Future<List<Audio>> getAudios() async{
    for(Song s in widget.songs){
      Audio temp = new Audio.file(s.url,metas:Metas(
          title: s.title,
          artist: s.artist,
          image: MetasImage.file(s.photo)
      ));
      audiosongs.add(temp);
    }
    return audiosongs;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
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

            SizedBox(height: 30.0,),
            FlipCard(
              key: cardKey,
              flipOnTouch: false,
              front: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(albumImage, fit: BoxFit.cover, //müziğin resmi
                  height: 250,
                  width: 250,),
              ),
              back: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0), //buradaki cliprrectin içine yazıyı yaz
                  child: Container(
                    height: 250,
                    width: 250,
                    color: Colors.orange,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("faskfnasklfnaskşfmkasnfjasnjasmfpomasofasıofnasıfnasmaponamaosmfoasfmpoasmfopasmfapomfponfaso" , style: TextStyle( //müzik başlığı
                          fontFamily: 'Nunito-Bold',
                          letterSpacing: 1.0,
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),),
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
                    onTap: (){
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
            SizedBox(height: 20.0,),
            Text(title.length > 20 ? title.substring(0,20) : title, style: TextStyle( //müzik başlığı
                fontFamily: 'Nunito-Bold',
                letterSpacing: 1.0,
                fontSize: 35,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 15.0,),
            Text(artist, style: TextStyle( //şarkıcı
              fontFamily: 'Nunito-Bold',
              letterSpacing: 1.0,
              fontSize: 15,
              color: Colors.black,
            ),),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
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
              padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0,bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap : () async{ //geri tuşu
                      audioPlayer.previous(keepLoopMode: true);
                      setState(() { //tıklandığında müziğin isminin, albüm resminin ve sarkıcısının değişmesi
                        title = audioPlayer.current.value.audio.audio.metas.title;
                        artist = audioPlayer.current.value.audio.audio.metas.artist;
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

  String currentPosition(){
    PlayerBuilder.currentPosition(
        player: audioPlayer,
        builder: (context, duration) {
          return Text(duration.toString());
        }
    );
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
