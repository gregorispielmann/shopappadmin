import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _controller,
            ),
            FlatButton(
              child: Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.pink,
              onPressed: () {
                Navigator.of(context).pop(_controller.text);
              },
            )
          ],
        ),
      ),
    );
  }
}
