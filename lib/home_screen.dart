import 'package:ChatBot/about_us.dart';
import 'package:ChatBot/utils/const.dart';
import 'package:ChatBot/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:get_it/get_it.dart';
import 'package:internationalization/internationalization.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'chat_messages.dart';
import 'iit-view.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  FocusNode inputNode = new FocusNode();
  final List<ChatMessages> messageList = <ChatMessages>[];
  final TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  stt.SpeechToText speech = stt.SpeechToText();

  List<String> choices = [
    "Cycles",
    "Information",
    "Fees",
    "Pre-register",
    "Contact"
  ];
  String localLanguage;

  Widget _queryInputWidget(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: appColor),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  focusNode: inputNode,
                  controller: _textController,
                  onSubmitted: submitQuery,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration.collapsed(
                      hintText: Strings.of(context).valueOf("SendMsg"),
                      hintStyle: TextStyle(color: Colors.white)),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.lightGreenAccent,
                  ),
                  onPressed: () => submitQuery(_textController.text)),
              IconButton(
                  icon: Icon(
                    Icons.mic,
                    color: Colors.lightGreenAccent,
                  ),
                  onPressed: () {
                    speech.listen(onResult: resultListener);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void agentResponse(String query) async {
    query = query.replaceAll("'", "_");
    _textController.clear();
    AuthGoogle authGoogle = await AuthGoogle(fileJson: jsonPath).build();
    Dialogflow dialogFlow =
        Dialogflow(authGoogle: authGoogle, language: localLanguage);
    AIResponse response = await dialogFlow.detectIntent(query);
    if (response.getMessage().contains("[web]")) {
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (_) => new IITView()));
    } else {
      ChatMessages message = ChatMessages(
        text: response.getMessage() ??
            CardDialogflow(response.getListMessage()[0].title),
        name: "Flutter",
        type: false,
      );
      setState(() {
        messageList.insert(0, message);
      });
    }
  }

  void submitQuery(String text) {
    if (text != "") {
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
      _textController.clear();
      ChatMessages message = new ChatMessages(
        text: text,
        name: "User",
        type: true,
      );
      setState(() {
        messageList.insert(0, message);
        inputNode.unfocus();
      });
      agentResponse(text);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!GetIt.I.isRegistered<HomeScreenState>())
      GetIt.I.registerSingleton<HomeScreenState>(this);
    getSpeechToText();
  }

  void getSpeechToText() async {
    bool available = await speech.initialize(
        onStatus: statusListener, onError: errorListener);
    if (available) {
     print("available");
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    localLanguage = myLocale.languageCode;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(TITLE, style: TextStyle(color: Colors.white)),
        backgroundColor: appColor,
        elevation: 0,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.info_outline),onPressed: (){
            Navigator.of(context).push(new MaterialPageRoute(builder:(_)=> new AboutUs()));
          },)
        ],
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
          Column(children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Wrap(
                spacing: 5,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: choices
                    .map((e) => GestureDetector(
                        onTap: () {
                          submitQuery(Strings.of(context).valueOf(e));
                        },
                        child: Chip(
                          backgroundColor: appColor,
                          label: Text(
                            Strings.of(context).valueOf(e),
                            style: TextStyle(color: Colors.white),
                          ),
                        )))
                    .toList(),
              ),
            ),
            new Flexible(
                child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(8.0),
              reverse: true,
              //To keep the latest messages at the bottom
              itemBuilder: (_, int index) => messageList[index],
              itemCount: messageList.length,
            )),
            _queryInputWidget(context),
          ]),
        ],
      ),
    );
  }

  void statusListener(String status) {
   print("Status");
   print(status);
  }

  void errorListener(SpeechRecognitionError errorNotification) {
    print("Error");
    print(errorNotification);
  }

  void resultListener(SpeechRecognitionResult result) {
    if (result.finalResult) {
      print(result.recognizedWords);
      submitQuery(result.recognizedWords);
      speech.stop();
    }
  }
}
