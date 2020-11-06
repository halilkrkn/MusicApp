import 'package:flutter/material.dart';
import 'package:flutter_music_player_app/screens/artistdetail.dart';


class Artists extends StatefulWidget {

  @override
  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {


  @override
  Widget build(BuildContext context) {
    var width =  MediaQuery.of(context).size.width;
    var height =  MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
              child: Container(
                child: Column(
                  children: [
                    row1(width,height),
                    SizedBox(height: height>700 ? 40.0 : 30.0, width: width,),
                    row2(width,height),
                    SizedBox(height: height>700 ? 40.0 : 30.0, width: width,),
                    row3(width,height),
                  ],
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }

  Widget row1(width,height){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/billie.jpg"))
              ),
            ),
            SizedBox(height: 10.0,),
            Text("Billie Eilish", style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),)
          ],
        ),
        SizedBox(width: width>400 ? 40.0 : 30.0,),
        Column(
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/eminem.jpg"))
              ),
            ),
            SizedBox(height: 10.0,),
            Text("Eminem", style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),)
          ],
        ),
      ],
    );


  }

  Widget row2(width,height){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/dualipa.jpg"))
              ),
            ),
            SizedBox(height: 10.0,),
            Text("Dua Lipa", style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),)
          ],
        ),
        SizedBox(width: width>400 ? 40.0 : 30.0,),
        Column(
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/brunomars.jpg"))
              ),
            ),
            SizedBox(height: 10.0,),
            Text("Bruno Mars", style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),)
          ],
        ),
      ],
    );
  }

  Widget row3(width,height){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/dualipa.jpg"))
              ),
            ),
            SizedBox(height: 10.0,),
            Text("Dua Lipa", style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),)
          ],
        ),
        SizedBox(width: width>400 ? 40.0 : 30.0,),
        Column(
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/brunomars.jpg"))
              ),
            ),
            SizedBox(height: 10.0,),
            Text("Bruno Mars", style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
            ),)
          ],
        ),
      ],
    );
  }


}