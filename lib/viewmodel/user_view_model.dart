import 'package:chatlytical/locator.dart';
import 'package:chatlytical/model/message.dart';
import 'package:chatlytical/model/user_model.dart';
import 'package:chatlytical/repository/user_repository.dart';
import 'package:chatlytical/services/auth_base.dart';
import 'package:flutter/material.dart';

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();

  UserModel _user;
  String emailErrorMessage;
  String passwordErrorMessage;

  ViewState get state => _state;
  UserModel get user => _user;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserViewModel() {
    currentUser();
  }

  @override
  Future<UserModel> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      return _user;
    } catch (e) {
      debugPrint("Viewmodeldeki current user hata:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<List<UserModel>> getAllUser() async {
    var allUserList = await _userRepository.getAllUser();
    return allUserList;
  }

  @override
  Future<UserModel> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInAnonymously();
      return _user;
    } catch (e) {
      print("Viewmodeldeki sign in anonymously hata $e");
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool result = await _userRepository.signOut();
      _user = null;
      return result;
    } catch (e) {
      print("Viewmodeldeki sign Out hata $e");
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      return _user;
    } catch (e) {
      print("Viewmodeldeki sign in anonymously hata $e");
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> createUserWithEmailPassword(
      String email, String password) async {
    if (_emailPasswordControl(email, password)) {
      try {
        state = ViewState.Busy;
        _user =
            await _userRepository.createUserWithEmailPassword(email, password);
        return _user;
      } finally {
        state = ViewState.Idle;
      }
    } else {
      return null;
    }
  }

  @override
  Future<UserModel> signInWithEmailPassword(
      String email, String password) async {
    try {
      if (_emailPasswordControl(email, password)) {
        state = ViewState.Busy;
        _user = await _userRepository.signInWithEmailPassword(email, password);
        return _user;
      } else {
        return null;
      }
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailPasswordControl(String email, String password) {
    var result = true;

    if (password.length < 6) {
      passwordErrorMessage = 'Şifre en az 6 karakter olmalıdır.';
      result = false;
    } else {
      passwordErrorMessage = null;
    }

    if (!email.contains('@')) {
      emailErrorMessage = 'Geçersiz email adresi';
      result = false;
    } else {
      emailErrorMessage = null;
    }
    return result;
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    var result = await _userRepository.updateUserName(userID, newUserName);
    if (result) {
      _user.userName = newUserName;
    }
    return result;
  }

  Future<bool> updateLanguage(String userID, String newLanguage) async {
    var result = await _userRepository.updateLanguage(userID, newLanguage);
    if (result) {
      _user.language = newLanguage;
    }
    return result;
  }

  Stream<List<Message>> getMessages(String currentUserID, String secondUserID) {
    return _userRepository.getMessages(currentUserID, secondUserID);
  }

  Future<bool> saveMessage(Message saveMessage) {
    return _userRepository.saveMessage(saveMessage);
  }
}
