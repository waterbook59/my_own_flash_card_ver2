import 'package:flutter/material.dart';

class WordTextInput extends StatelessWidget {

  final String label;
  final TextEditingController textEditingController;

  WordTextInput({this.label, this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(label,style: TextStyle(fontSize: 30.0),),
        Padding(
          padding: const EdgeInsets.only(right:25.0,left:25.0,top:15.0),
          child: TextField(
            controller: textEditingController,
//            enabled: _isQuestionEnabled,
            style: TextStyle(fontSize: 25.0),
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
