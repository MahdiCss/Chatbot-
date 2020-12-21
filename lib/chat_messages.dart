import 'package:ChatBot/home_screen.dart';
import 'package:ChatBot/map.dart';
import 'package:ChatBot/utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internationalization/internationalization.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> botMessage(context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Image.asset(
            "assets/logo.png",
            width: 40,
            height: 40,
          ),
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//            Text(this.name,
//                style: TextStyle(fontWeight: FontWeight.bold)),
            Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildReponseWidget(text, context))),
          ],
        ),
      ),
    ];
  }

  Widget buildReponseWidget(String result, context) {
    if (result.contains("[choices]")) {
      result = result.substring(10);
      print(result.split("\n"));
      List<String> choices = result.split("\n");
      return Wrap(
        spacing: 5,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: choices
            .map((e) => GestureDetector(
                onTap: () {
                  GetIt.I<HomeScreenState>().submitQuery(e);
                },
                child: Chip(
                  backgroundColor: appColor,
                  label: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                )))
            .toList(),
      );
    } else if (result.contains("[image]")) {
      String imgUrl = result.split("[image]")[1].split("\n")[1];
      List<String> choices = result.split("[next]")[1].split("\n").sublist(1);
      return Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => {openDialogue(context, imgUrl)},
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Wrap(
            spacing: 5,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: choices
                .map((e) => GestureDetector(
                    onTap: () {
                      GetIt.I<HomeScreenState>().submitQuery(e);
                    },
                    child: Chip(
                      backgroundColor: appColor,
                      label: Text(
                        e,
                        style: TextStyle(color: Colors.white),
                      ),
                    )))
                .toList(),
          )
        ],
      );
    } else if (result.contains('[next]')) {
      List<String> results = result.split("[next]");
      String description = results[0];
      List<String> choices = results[1].split("\n").sublist(1);
      return new Column(
        children: <Widget>[
          description.contains("[line]")
              ? Column(
                  children: <Widget>[
                    Text(
                      description.split("[line]")[0],
                      textAlign: TextAlign.left,
                    ),
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: description
                          .split("[line]")[1]
                          .split("#")
                          .sublist(1)
                          .map((e) => new Text(
                                "- " + e,
                                textAlign: TextAlign.left,
                              ))
                          .toList(),
                    ),
                  ],
                )
              : Text(description),
          Wrap(
            spacing: 5,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            children: choices
                .map((e) => GestureDetector(
                    onTap: () {
                      GetIt.I<HomeScreenState>().submitQuery(e);
                    },
                    child: Chip(
                      backgroundColor: appColor,
                      label: Text(
                        e,
                        style: TextStyle(color: Colors.white),
                      ),
                    )))
                .toList(),
          )
        ],
      );
    } else if (result.contains("[line]")) {
      List<String> results = result.split("[line]");
      List<String> results2 = results[1].split("#");
      return Column(
        children: <Widget>[
          Text(
            results[0],
            textAlign: TextAlign.left,
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: results2
                .map((e) => new Text(
                      "- " + e,
                      textAlign: TextAlign.left,
                    ))
                .toList(),
          ),
        ],
      );
    } else if (result.contains("[separator]")) {
      result = result.substring(12);
      List<String> results = result.split("#");
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: results
            .map((e) => new Text(
                  "- " + e,
                  textAlign: TextAlign.left,
                ))
            .toList(),
      );
    } else if (result.contains("[map]")) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(Strings.of(context).valueOf("Map")),
          new IconButton(
            icon: Icon(
              Icons.location_on,
              size: 35,
              color: Colors.red,
            ),
            onPressed: () {
              openMap(context);
            },
          )
        ],
      );
    } else if (result.contains("[email]")) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("info@iit.tn"),
          IconButton(
            icon: Icon(Icons.mail_outline),
            color: Colors.red,
            onPressed: () async {
              const email = 'mailto:info@iit.tn';
              if (await canLaunch(email)) {
                await launch(email);
              }
            },
          )
        ],
      );
    } else if (result.contains("[phone]")) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("(+216) 74 46 50 20"),
          IconButton(
            icon: Icon(
              Icons.phone,
              size: 35,
              color: Colors.green,
            ),
            onPressed: () async {
              const phone = 'tel:74 46 50 20';
              if (await canLaunch(phone)) {
                await launch(phone);
              }
            },
          ),
        ],
      );
    } else {
      return Text(result);
    }
  }

  void openMap(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: new Map(
                iit: new LatLng(34.7288394, 10.7373393),
              ),
            ),
          );
        });
  }

  openDialogue(context, imgUrl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RotatedBox(
              quarterTurns: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CachedNetworkImage(
                  imageUrl: imgUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ));
        });
  }

  List<Widget> userMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Card(
                color: appColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 10.0),
        child: CircleAvatar(
          child: Icon(
            Icons.account_circle,
            size: 30,
          ),
          backgroundColor: appColor,
          radius: 20,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? userMessage(context) : botMessage(context),
      ),
    );
  }
}
