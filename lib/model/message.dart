import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String fromMessage;
  final String toMessage;
  final bool fromMe;
  final String message;
  final String lang;
  final Timestamp date;

  Message(
      {this.fromMessage,
      this.toMessage,
      this.fromMe,
      this.message,
      this.lang,
      this.date});

  Map<String, dynamic> toMap() {
    return {
      'fromMessage': fromMessage,
      'toMessage': toMessage,
      'fromMe': fromMe,
      'message': message,
      'lang': lang,
      'date': date ?? FieldValue.serverTimestamp()
    };
  }

  Message.fromMap(Map<String, dynamic> map)
      : fromMessage = map['fromMessage'],
        toMessage = map['toMessage'],
        fromMe = map['fromMe'],
        message = map['message'],
        lang = map['lang'],
        date = map['date'];

  @override
  String toString() {
    return 'Message{fromMessage: $fromMessage, toMessage: $toMessage, fromMe: $fromMe, message: $message, lang: $lang, date: $date}';
  }
}
