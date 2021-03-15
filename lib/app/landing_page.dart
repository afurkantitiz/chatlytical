import 'package:chatlytical/app/home_page.dart';
import 'package:chatlytical/app/sign_in/Welcome/welcome_screen.dart';
import 'package:chatlytical/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserViewModel>(context);
    if (_userModel.state == ViewState.Idle) {
      if (_userModel.user == null) {
        return WelcomeScreen();
      } else {
        return HomePage(user: _userModel.user);
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
