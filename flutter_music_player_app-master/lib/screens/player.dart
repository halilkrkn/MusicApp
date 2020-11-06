import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  Player({Key key,this.songName,this.singer,this.image,this.duration}) : super(key: key);

  final String songName;
  final String singer;
  final String image;
  final String duration;

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> with SingleTickerProviderStateMixin{

  double _value = 0.0;
  void _setValue(double value) {
    setState(() {
      _value = value;
    });
  }

  AnimationController animationController;
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      onTap:(){
                        Navigator.pushReplacementNamed(context, '/home');},
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

            SizedBox(height: 80.0,),
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset("assets/billiebadguy.jpg", fit: BoxFit.cover,
              height: 250,
              width: 250,),
            ),
            SizedBox(height: 20.0,),
            Text("Bad Guy", style: TextStyle(
              fontFamily: 'Nunito-Bold',
              letterSpacing: 1.0,
              fontSize: 35,
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 15.0,),
            Text("Billie Eilish", style: TextStyle(
                fontFamily: 'Nunito-Bold',
                letterSpacing: 1.0,
                fontSize: 15,
                color: Colors.black,
            ),),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
              child: Slider(
                activeColor: Colors.orangeAccent,
                value: _value,
                inactiveColor: Colors.grey,
                onChanged: _setValue,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0,bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(Icons.fast_rewind, color: Colors.black,),
                  CircleAvatar(
                    backgroundColor: Colors.black87,
                    radius: 40.0,
                    child: IconButton(
                      iconSize: 50,
                    color: Colors.white,
                    icon: AnimatedIcon(icon: AnimatedIcons.play_pause, progress: animationController),
                      onPressed: (){
                        _handleOnPressed();
                      },
                    ),
                  ),
                  Icon(Icons.fast_forward, color: Colors.black,)
                ],
              ),
            )
          ],
        ),

      ),
    );
  }

  Future<bool> _onBackPressed() async{
    Navigator.pushReplacementNamed(context, '/home');
    return true;
  }

  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
      ? animationController.forward()
          :animationController.reverse();
    });
  }
}
