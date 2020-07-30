//radioボタン statefulウィジェットで外だしパターン

import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/memorized_status.dart';

class RadioSelectedType extends StatefulWidget {

  final Memorized _testType;//ゲッター設定した方が良い
  final ValueChanged _onRadioSelected;

  RadioSelectedType({onRadioSelected,testType})
       : _onRadioSelected =  onRadioSelected,
        _testType =testType;


  @override
  _RadioSelectedTypeState createState() => _RadioSelectedTypeState();
}

class _RadioSelectedTypeState extends State<RadioSelectedType> {
//  Memorized testType = Memorized.includedWords;
//

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: Column(children: <Widget>[
        RadioListTile(
          secondary: Icon(Icons.category),
          controlAffinity: ListTileControlAffinity.trailing,
          title: Text("全ての単語"),
          value: Memorized.includedWords,
          groupValue:widget._testType,
          // ラジオボタン(暗記済除外)onChanged
          onChanged: (testTypeValue) {

              //testTypeの初期値は受けるが値の変更は、homeScreenに値を返してhomeScreen側で変更？
              //もしくはState内で変更できるフィールド個別にもつ(testTypeは受ける値専用、変更は別)
//              widget._testType = testTypeValue;//これはラジオボタンの表示を変えるため
              widget._onRadioSelected(testTypeValue);//これで呼び出し元のvalueにtestTypeValueが入る？
              print("testTypeは$testTypeValue");

          }
        ),
        RadioListTile(
          secondary: Icon(Icons.thumb_up),
          controlAffinity: ListTileControlAffinity.trailing,
          title: Text("暗記済単語を除外"),
          value: Memorized.excludedWords,
          groupValue: widget._testType,
          // ラジオボタン(暗記済含む)onChanged
            onChanged: (testTypeValue) {
//                testType = testTypeValue;//これはラジオボタンの表示を変えるため
                widget._onRadioSelected(testTypeValue);//これで呼び出し元のvalueにtestTypeValueが入る
                //受注側で設定したValueChanged関数の引数に呼び出し元へ返す値を入れると、発注先へ渡せて使える
                print("testTypeは$testTypeValue");

            }
        ),
      ],
      ),
    );
  }
}

//_selectedButton(value) {
//  //onChangedの引数にRadioListTile(value:xx)の値が入ってくる
//  setState(() {
//    testType = value;
//    print("testTypeは$value");
//  });
//}