import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatlytical/constants.dart';
import 'package:chatlytical/model/message.dart';
import 'package:chatlytical/model/user_model.dart';
import 'package:chatlytical/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';

class Chat extends StatefulWidget {
  final UserModel secondUser;
  final UserModel currentUser;

  Chat({Key key, this.currentUser, this.secondUser}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ScrollController _scrollController = ScrollController();
  final FlutterTts flutterTts = FlutterTts();
  stt.SpeechToText _speech;
  bool _isListening = false;
  GoogleTranslator translator = new GoogleTranslator();
  var outputTranslateMessage;

  var _messageController;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _messageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserViewModel>(context);
    UserModel _currentUser = widget.currentUser;
    UserModel _secondUser = widget.secondUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Konuşma"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<List<Message>>(
              stream: _userModel.getMessages(
                  _currentUser.userID, _secondUser.userID),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<Message> allMessages = snapshot.data;
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: allMessages.length,
                  itemBuilder: (context, index) {
                    return _createChatBubble(allMessages[index]);
                  },
                );
              },
            )),
            Container(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      cursorColor: Colors.purple[200],
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                          fillColor: kPrimaryLightColor,
                          filled: true,
                          hintText: 'Mesajınızı Yazın',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none)),
                    ),
                  ),
                  AvatarGlow(
                    animate: _isListening,
                    glowColor: kPrimaryColor,
                    endRadius: 30.0,
                    duration: const Duration(milliseconds: 2000),
                    repeatPauseDuration: const Duration(milliseconds: 100),
                    repeat: true,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: IconButton(
                        splashColor: Colors.transparent,
                        icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                        color: kPrimaryColor,
                        highlightColor: Colors.transparent,
                        onPressed: _listen,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        border: Border(
                      left: BorderSide(
                        color: kPrimaryLightColor,
                        width: 1.0,
                      ),
                    )),
                    child: IconButton(
                        icon: Icon(Icons.send),
                        splashColor: Colors.transparent,
                        color: kPrimaryColor,
                        highlightColor: Colors.transparent,
                        onPressed: () async {
                          Message _saveMessage = Message(
                            fromMessage: _currentUser.userID,
                            toMessage: _secondUser.userID,
                            fromMe: true,
                            message: _messageController.text,
                            lang: _currentUser.language,
                          );
                          var result =
                              await _userModel.saveMessage(_saveMessage);

                          if (result == true) {
                            _messageController.clear();
                            _scrollController.animateTo(0.0,
                                duration: Duration(milliseconds: 10),
                                curve: Curves.easeOut);
                          }
                        }),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _messageController.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future _speak(String text) async {
    await flutterTts.setLanguage(widget.currentUser.language);
    await flutterTts.setPitch(0.4);
    print(await flutterTts.getVoices);
    await flutterTts.speak(text);
  }

  Widget _createChatBubble(Message currentMessage) {
    Color _inComingMessageColor = Colors.blue;
    Color _outGoingMessageColor = Colors.green;

    var _myMessage = currentMessage.fromMe;

    if (_myMessage) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: _outGoingMessageColor,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(4),
              child: Text(
                currentMessage.message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onDoubleTap: () async {
          outputTranslateMessage = await translator.translate(
              currentMessage.message,
              to: widget.currentUser.language);
          _speak(outputTranslateMessage.toString());
        },
        onLongPress: () async {
          outputTranslateMessage = await translator.translate(
              currentMessage.message,
              to: widget.currentUser.language);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(outputTranslateMessage.toString()),
            backgroundColor: Colors.purple[900],
            elevation: 20,
            // action: SnackBarAction(
            //   label: 'Ok',
            //   textColor: Colors.white,
            //   onPressed: () {},
            // ),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.secondUser.photoURL),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _inComingMessageColor,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Text(
                          currentMessage.message,
                          style: TextStyle(color: Colors.white),
                        ),
                        // Text((cikti != null) ? cikti.toString() : ""),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}
