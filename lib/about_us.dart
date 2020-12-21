import 'package:ChatBot/utils/const.dart';
import 'package:ChatBot/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:internationalization/internationalization.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: new Text(Strings.of(context).valueOf("About"),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: appColor,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/login_back.jpg"),
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: Colors.black87,
          ),
          Padding(
            padding: const EdgeInsets.only(top:40.0,left: 20,right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image(
                  image: new AssetImage("assets/logo.png"),
                  width: 150,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  TITLE,
                  style: TextStyle(color: Colors.white),
                ),
                Text("1.0", style: TextStyle(color: Colors.white)),
                SizedBox(
                  height: 20,
                ),
                Text(Strings.of(context).valueOf("About Desc"),
                  style: TextStyle(color: Colors.white),textAlign:
                  TextAlign.center,),
                SizedBox(
                  height: 10,
                ),
                Text(Strings.of(context).valueOf("Dev By"),
                    style: TextStyle(color: Colors.white),textAlign:
                  TextAlign.center,),
                SizedBox(
                  height: 10,
                ),
                Text("Mohamed Mseddi", style: TextStyle(color: Colors.white)),
                SizedBox(
                  height: 10,
                ),
                Text(
                    "mseddi"
                    ".mohamed@iit.ens.tn",
                    style: TextStyle(color: Colors.white)),
                SizedBox(
                  height: 10,
                ),
                Text("Skander Boudabous", style: TextStyle(color: Colors.white)),
                SizedBox(
                  height: 10,
                ),
                Text("skander.boudabous@iit.ens.tn",
                    style: TextStyle(color: Colors.white)),
                SizedBox(
                  height: 10,
                ),
                Text("Mahdi Chaabouni", style: TextStyle(color: Colors.white)),
                SizedBox(
                  height: 10,
                ),
                Text("mahdi.chaabouni@iit.ens.tn",
                    style: TextStyle(color: Colors.white))

              ],
            ),
          ),
        ],
      ),
    );
  }
}
