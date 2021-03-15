import 'package:chatlytical/model/user_model.dart';
import 'package:chatlytical/services/auth_base.dart';

class FakeAuthenticationService implements AuthBase {
  String userID = "122132321321";
  @override
  Future<UserModel> currentUser() async {
    return Future.value(UserModel(userID: userID, email: "fakeuser@fake.com"));
  }

  @override
  Future<UserModel> signInAnonymously() async {
    return await Future.delayed(Duration(seconds: 2),
        () => UserModel(userID: userID, email: "fakeuser@fake.com"));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => UserModel(
            userID: "google_user_id_12121", email: "fakeuser@fake.com"));
  }

  @override
  Future<UserModel> createUserWithEmailPassword(
      String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => UserModel(
            userID: "created_user_id_12121", email: "fakeuser@fake.com"));
  }

  @override
  Future<UserModel> signInWithEmailPassword(
      String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => UserModel(
            userID: "signIn_user_id_12121", email: "fakeuser@fake.com"));
  }
}
