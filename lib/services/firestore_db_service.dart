import 'package:chatlytical/model/message.dart';
import 'package:chatlytical/model/user_model.dart';
import 'package:chatlytical/services/database_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel user) async {
    await _firebaseDB.collection("users").doc(user.userID).set(user.toMap());

    DocumentSnapshot _readUser =
        await FirebaseFirestore.instance.doc("users/${user.userID}").get();

    Map _readUserDataMap = _readUser.data();
    UserModel _readUserDataObject = UserModel.fromMap(_readUserDataMap);

    print("Read user object  : " + _readUserDataObject.toString());

    return true;
  }

  @override
  Future<UserModel> readUser(String userID) async {
    DocumentSnapshot _readUser =
        await _firebaseDB.collection("users").doc(userID).get();
    Map<String, dynamic> _readUserDataMap = _readUser.data();

    UserModel _readUserObject = UserModel.fromMap(_readUserDataMap);

    print("Okunan user nesnesi : " + _readUserObject.toString());
    return _readUserObject;
  }

  @override
  Future<bool> updateLanguage(String userID, String language) async {
    await _firebaseDB
        .collection("users")
        .doc(userID)
        .update({'language': language});
    return true;
  }

  @override
  Future<bool> updateUserName(String userID, String newUserName) async {
    var users = await _firebaseDB
        .collection("users")
        .where("userName", isEqualTo: newUserName)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firebaseDB
          .collection("users")
          .doc(userID)
          .update({'userName': newUserName});
      return true;
    }
  }

  Future<bool> updateProfilePhoto(String userID, String profilePhotoURL) async {
    await _firebaseDB
        .collection("users")
        .doc(userID)
        .update({'photoURL': profilePhotoURL});
    return true;
  }

  @override
  Future<List<UserModel>> getAllUser() async {
    QuerySnapshot querySnapshot = await _firebaseDB.collection("users").get();

    List<UserModel> allUsers = [];

    for (DocumentSnapshot oneUser in querySnapshot.docs) {
      UserModel _oneUser = UserModel.fromMap(oneUser.data());
      allUsers.add(_oneUser);
    }

    return allUsers;
  }

  @override
  Stream<List<Message>> getMessages(String currentUserID, String secondUserID) {
    var snapShot = _firebaseDB
        .collection("chats")
        .doc(currentUserID + "--" + secondUserID)
        .collection("messages")
        .orderBy("date")
        .snapshots();
    return snapShot.map((messageList) => messageList.docs
        .map((message) => Message.fromMap(message.data()))
        .toList());
  }

  Future<bool> saveMessage(Message saveMessage) async {
    var _messageID = _firebaseDB.collection("chats").doc().id;
    var _myDocumentID = saveMessage.fromMessage + "--" + saveMessage.toMessage;
    var _receiverDocumentID =
        saveMessage.toMessage + "--" + saveMessage.fromMessage;

    var _saveMessageMap = saveMessage.toMap();

    await _firebaseDB
        .collection("chats")
        .doc(_myDocumentID)
        .collection("messages")
        .doc(_messageID)
        .set(_saveMessageMap);

    _saveMessageMap.update("fromMe", (value) => false);

    await _firebaseDB
        .collection("chats")
        .doc(_receiverDocumentID)
        .collection("messages")
        .doc(_messageID)
        .set(_saveMessageMap);

    return true;
  }
}
