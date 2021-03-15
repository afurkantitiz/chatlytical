import 'package:chatlytical/app/chat.dart';
import 'package:chatlytical/model/user_model.dart';
import 'package:chatlytical/viewmodel/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserViewModel _userModel =
        Provider.of<UserViewModel>(context, listen: false);
    _userModel.getAllUser();
    return Scaffold(
        appBar: AppBar(
          title: Text("Kullanıcılar"),
        ),
        body: FutureBuilder<List<UserModel>>(
          future: _userModel.getAllUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var allUsers = snapshot.data;
              if (allUsers.length - 1 > 0) {
                return ListView.builder(
                  itemCount: allUsers.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data[index].userID != _userModel.user.userID) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (context) => Chat(
                                currentUser: _userModel.user,
                                secondUser: snapshot.data[index],
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(snapshot.data[index].userName),
                          subtitle: Text(snapshot.data[index].email),
                          trailing: Text(snapshot.data[index].language),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data[index].photoURL),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                );
              } else {
                return Center(
                  child: Text("Kayıtlı bir kullanıcı yok"),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
