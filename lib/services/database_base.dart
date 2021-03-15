import 'package:chatlytical/model/message.dart';
import 'package:chatlytical/model/user_model.dart';

abstract class DBBase {
  Future<bool> saveUser(UserModel user);
  Future<UserModel> readUser(String userID);
  Future<bool> updateUserName(String userID, String newUserName);
  Future<bool> updateLanguage(String userID, String language);
  Future<bool> updateProfilePhoto(String userID, String profilePhoto);
  Future<List<UserModel>> getAllUser();
  Stream<List<Message>> getMessages(String currentUserID, String secondUserID);
  Future<bool> saveMessage(Message saveMessage);
}
