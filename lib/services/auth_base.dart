import 'package:chatlytical/model/user_model.dart';

abstract class AuthBase {
  Future<UserModel> currentUser();
  Future<UserModel> signInAnonymously();
  Future<bool> signOut();
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithEmailPassword(String email, String password);
  Future<UserModel> createUserWithEmailPassword(String email, String password);
}
