import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatlytical/constants.dart';
import 'package:chatlytical/model/message.dart';
import 'package:chatlytical/model/user_model.dart';
import 'package:chatlytical/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Chat extends StatefulWidget {
  final UserModel currentUser;
  final UserModel secondUser;

  const Chat({Key key, this.currentUser, this.secondUser}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  stt.SpeechToText _speech;
  bool _isListening = false;

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
                  itemCount: allMessages.length,
                  itemBuilder: (context, index) {
                    return Text(allMessages[index].message);
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
}
