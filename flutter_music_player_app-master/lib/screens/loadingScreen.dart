import 'package:flutter/material.dart';

class loadingScreen extends StatefulWidget {
  @override
  _loadingScreenState createState() => _loadingScreenState();
}

class _loadingScreenState extends State<loadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset("assets/godzillaeminem.png", fit: BoxFit.cover, height:70, width: 70,),
          ),
          SizedBox(height: 20,),
          Text("Kontra Music Player", style: TextStyle( //müzik başlığı
              fontFamily: 'Nunito-Bold',
              letterSpacing: 1.0,
              fontSize: 40,
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),),
        ],
      ),
    );
  }
}
