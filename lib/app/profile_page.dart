import 'package:chatlytical/viewmodel/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common_widget/social_log_in_button.dart';
import '../constants.dart';
import '../viewmodel/user_view_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _controllerUserName;
  TextEditingController _controllerLanguange;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String languageValue;

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
    _controllerLanguange = TextEditingController();
  }

  @override
  void dispose() {
    _controllerLanguange.dispose();
    _controllerUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    print("Profil sayfasindaki user degerleri : " +
        _userViewModel.user.toString());

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Profil"),
        actions: [
          IconButton(
            onPressed: () => _logOut(context),
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .03,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
              ),
              Text("E-Mail Adresiniz"),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(29),
                ),
                child: TextField(
                  cursorColor: kPrimaryColor,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: _userViewModel.user.email,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 2,
                ),
              ),
              Text("Kullanıcı Adınız"),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(29),
                ),
                child: TextField(
                  cursorColor: kPrimaryColor,
                  controller: _controllerUserName,
                  readOnly: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: _userViewModel.user.userName),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .25,
                    vertical: 10),
                child: SocialLoginButton(
                  butonText: "Kullanıcı Adını Kaydet",
                  onPressed: () {
                    _userNameUpdate(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 2,
                ),
              ),
              Text("Dil"),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(29),
                ),
                child: DropdownButton(
                  value: languageValue,
                  elevation: 16,
                  style: TextStyle(color: kPrimaryColor),
                  underline: Container(
                    height: 2,
                    color: kPrimaryLightColor,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      languageValue = newValue.toLowerCase();
                    });
                  },
                  items: <String>['tr', 'en']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .25,
                    vertical: 10),
                child: SocialLoginButton(
                  butonText: "Dili Kaydet",
                  onPressed: () {
                    _languageUpdate(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _logOut(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    var result = await _userModel.signOut();
    return result;
  }

  void _userNameUpdate(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    if (_userModel.user.userName != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.user.userID, _controllerUserName.text);

      if (updateResult == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Kullanıcı adı değiştirildi."),
        ));
      } else {
        _controllerUserName.text = _userModel.user.userName;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Kullanıcı Adı zaten kullanımda. Farklı bir kullanıcı adı deneyiniz."),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Kullanıcı adı değişikliği yapmadınız."),
      ));
    }
  }

  void _languageUpdate(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    if (_userModel.user.language != languageValue) {
      var updateResult = await _userModel.updateLanguage(
          _userModel.user.userID, languageValue);

      if (updateResult == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Dil değişikliği başarılı."),
        ));
      } else {
        _controllerLanguange.text = _userModel.user.language;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Dil değiştirilirken hata oluştu."),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Dil değişikliği yapmadınız."),
      ));
    }
  }
}
