import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  final Stream<String> stream;
  final Function(String) onChanged;

  final bool obscure;
  final String hint;
  final IconData icon;

  InputField({ this.hint, this.icon, this.obscure, this.stream, this.onChanged });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot){
      return TextField(
        onChanged: onChanged,
        obscureText: obscure,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Colors.pink,
        style: TextStyle(
          color: Colors.white
        ),
        decoration: InputDecoration(
          errorText: snapshot.hasError ? snapshot.error : null,
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white24),
          prefixIcon: Icon(
            icon,
            color: Colors.white,
          ),
        ),
       );
      }
    );
  }
}