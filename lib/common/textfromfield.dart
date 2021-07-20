import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {

  final String hintText;

  const AppTextFormField({Key key, @required this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.only(left: 20),
          filled: true,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue)
          )
      ),
    );
  }
}
