import 'package:chatlytical/app/sign_in/components/text_field_container.dart';
import 'package:chatlytical/constants.dart';
import 'package:flutter/material.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onSaved;
  const RoundedPasswordField({
    Key key,
    this.onSaved,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool secureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: secureText,
        onSaved: widget.onSaved,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Şifre",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
            splashColor: Colors.transparent,
            icon: Icon(Icons.visibility),
            color: kPrimaryColor,
            onPressed: () {
              setState(() {
                secureText = !secureText;
              });
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
