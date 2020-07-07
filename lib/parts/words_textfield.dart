/*
TextEditingControllerをカスタムウィジェットとして外に出したかったが、
controllerの値をクラス外へうまく渡せずに断念。

State内でwidget.変数に設定し、その変数をStatefulWidgetで名前付きコンストラクタ設定
呼び出し元で名前付コンストラクタ部に別名をつけたインスタンスを入れる
 */


import 'package:flutter/material.dart';

class WordsTextField extends StatefulWidget {

  final String label;
  final TextEditingController textEditingController;
  WordsTextField({this.label,this.textEditingController});



  @override
  _WordsTextFieldState createState() => _WordsTextFieldState();
}

class _WordsTextFieldState extends State<WordsTextField> {

//  TextEditingController _myController =TextEditingController();
//  String _inputString =_myController.text;
//  widget.callback(this._inputString);

  //レクチャーではtextFieldをメソッドにしているので、ここの項目設定していないので、
  //エラーがでたら比較
//  @override
//  void dispose() {
//    _myController.dispose();
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
//    String _inputString =_myController.text;

    return Column(
      children: <Widget>[
        Text(widget.label,style: TextStyle(fontSize: 30.0),),
        Padding(
          padding: const EdgeInsets.only(right:25.0,left:25.0,top:15.0),
          child: TextField(
            controller: widget.textEditingController,
            style: TextStyle(fontSize: 25.0),
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
