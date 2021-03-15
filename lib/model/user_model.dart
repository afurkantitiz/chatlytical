import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  final String userID;
  String email;
  String userName;
  String language;
  String photoURL;
  DateTime createdAt;
  DateTime updatedAt;
  int level;

  UserModel({@required this.userID, @required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName': userName ??
          email.substring(0, email.indexOf('@')) + randomNumberCreator(),
      'language': language ?? 'tr',
      'photoURL': photoURL ??
          'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'level': level ?? 1,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        language = map['language'],
        photoURL = map['photoURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        level = map['level'];

  @override
  String toString() {
    return 'UserModel{userID: $userID, email: $email, userName: $userName, language: $language, photoURL: $photoURL, createdAt: $createdAt, updatedAt: $updatedAt, level: $level}';
  }

  String randomNumberCreator() {
    int randomNumber = Random().nextInt(9999999);
    return randomNumber.toString();
  }
}
