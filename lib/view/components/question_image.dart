import 'package:flutter/material.dart';

class QuestionImage extends StatelessWidget {

  final String questionWord;

  QuestionImage({this.questionWord});


  /*
  widget分割するときには、分割先でそのwidgetをif分岐せず、呼び出し元で条件設定
  下記をwidget内ではなく呼び出し元で３項条件演算子使う
  isQuestionPart:true=> questionImage()
                :false=> 空の箱
         */

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Image.asset("assets/images/image_flash_question.png"),
        Center(child: Text(questionWord,style: TextStyle(fontSize:40.0,color: Colors.black87),)),
      ],
    );
  }
}
