import 'package:chatlytical/app/sign_in/Login/login_screen.dart';
import 'package:chatlytical/app/sign_in/components/already_have_an_account_acheck.dart';
import 'package:chatlytical/app/sign_in/components/rounded_button.dart';
import 'package:chatlytical/app/sign_in/components/rounded_input_field.dart';
import 'package:chatlytical/app/sign_in/components/rounded_password_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:chatlytical/model/user_model.dart';
import 'package:chatlytical/viewmodel/user_view_model.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _email, _password;
  final _formKey = GlobalKey<FormState>();

  void _formSubmit() async {
    _formKey.currentState.save();
    debugPrint("email : " + _email + "sifre : " + _password);
    final _userModel = Provider.of<UserViewModel>(context, listen: false);

    try {
      UserModel _createUser =
          await _userModel.createUserWithEmailPassword(_email, _password);
      if (_createUser != null) {
        print("Oturum açan user id : " + _createUser.userID.toString());
      }
    } catch (e) {
      print("Widget oturum açma hata yakalandı " + e.toString());
      showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text("Kullanıcı oluşturulurken hata oluştu."),
              content: Text(
                  "Girdiğiniz email adresi zaten kullanımda. Lütfen farklı bir mail adresi giriniz"),
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
    Size size = MediaQuery.of(context).size;
    final _userModel = Provider.of<UserViewModel>(context);

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
                      "assets/images/signup.png",
                      height: size.height * 0.35,
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
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
                    RoundedButton(
                      text: "KAYIT OL",
                      press: () => _formSubmit(),
                    ),
                    SizedBox(height: size.height * 0.03),
                    AlreadyHaveAnAccountCheck(
                      login: false,
                      press: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) {
                              return LoginScreen();
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
