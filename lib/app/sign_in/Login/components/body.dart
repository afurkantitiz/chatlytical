import 'package:chatlytical/app/sign_in/Signup/signup_screen.dart';
import 'package:chatlytical/app/sign_in/components/already_have_an_account_acheck.dart';
import 'package:chatlytical/app/sign_in/components/rounded_button.dart';
import 'package:chatlytical/app/sign_in/components/rounded_input_field.dart';
import 'package:chatlytical/app/sign_in/components/rounded_password_field.dart';
import 'package:chatlytical/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:chatlytical/model/user_model.dart';
import 'package:chatlytical/viewmodel/user_view_model.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _email, _password;
  final _formKey = GlobalKey<FormState>();

  Future<void> _googleAuth(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    UserModel _user = await _userModel.signInWithGoogle();
    if (_user != null) {
      print("Oturum açan userid: " + _user.userID.toString());
    }
  }

  void _formSubmit() async {
    _formKey.currentState.save();
    debugPrint("email : " + _email + "sifre : " + _password);
    final _userModel = Provider.of<UserViewModel>(context, listen: false);

    try {
      UserModel _authUser =
          await _userModel.signInWithEmailPassword(_email, _password);
      if (_authUser != null) {
        print("Oturum açan user id : " + _authUser.userID.toString());
      }
    } catch (e) {
      print("Widget oturum açma hata yakalandı" + e.toString());
      showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text("Oturum açılırken hata oluştu."),
              content: Text("Bu kullanıcı sistemde bulunmamaktadır."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Tamam"),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserViewModel>(context);
    Size size = MediaQuery.of(context).size;

    if (_userModel.user != null) {
      Future.delayed(Duration(milliseconds: 5), () {
        Navigator.of(context).pop();
      });
    }

    return _userModel.state == ViewState.Idle
        ? Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/login.png",
                      height: size.height * 0.35,
                    ),
                    SizedBox(height: size.height * 0.05),
                    RoundedInputField(
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Email Adresi",
                      onSaved: (String mail) {
                        _email = mail;
                      },
                    ),
                    RoundedPasswordField(
                      onSaved: (String pswrd) {
                        _password = pswrd;
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    GestureDetector(
                      onTap: () => _googleAuth(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Google ile giriş yapmak için ",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: size.width * 0.04),
                          ),
                          SvgPicture.asset(
                            "assets/icons/google-plus.svg",
                            height: size.width * 0.05,
                            color: kPrimaryColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    RoundedButton(
                      text: "LOGIN",
                      press: () => _formSubmit(),
                    ),
                    SizedBox(height: size.height * 0.03),
                    AlreadyHaveAnAccountCheck(
                      press: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) {
                              return SignUpScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
