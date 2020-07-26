import 'package:flutter/material.dart';

class AnswerImage extends StatelessWidget {

  final String answerWord;
  AnswerImage({this.answerWord});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Image.asset("assets/images/image_flash_answer.png"),
        Center(child: Text(answerWord,style: TextStyle(fontSize:40.0,color: Colors.black87),)),
      ],
    );
  }
}
