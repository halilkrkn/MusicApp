import 'dart:async';

import 'package:flutter/material.dart';

class loadingScreen extends StatefulWidget {
  @override
  _loadingScreenState createState() => _loadingScreenState();
}

class _loadingScreenState extends State<loadingScreen> {
  String state = "Loading Songs";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset("assets/licon.png", fit: BoxFit.cover, height:120, width: 120,),
            ),
            SizedBox(height: 10,),
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width-40,
              child: Text("Kontra Music Player", textAlign: TextAlign.center,style: TextStyle( //müzik başlığı
                  fontFamily: 'Nunito-Bold',
                  letterSpacing: 1.0,
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
              ),),
            ),
            bottomMusicBar(),
          ],
        ),
      ),
    );
  }

  Widget bottomMusicBar(){
    var width = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.bottomCenter,
      child:  ClipRRect(
        borderRadius: BorderRadius.only(topRight: Radius.circular(15.0),topLeft: Radius.circular(15.0)),
        child: Container(
          height: 100,
          width : width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 15,),
                Text(state , style: TextStyle( //müzik başlığı
                    fontFamily: 'Nunito-Bold',
                    letterSpacing: 1.0,
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
