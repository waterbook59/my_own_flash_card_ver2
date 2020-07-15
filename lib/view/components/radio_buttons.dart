//radioボタン statelessウィジェットで外だしパターン

import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/memorized_status.dart';


class RadioButtons extends StatelessWidget {

  final Memorized wordTestType;
  final ValueChanged onRadioSelected;

  RadioButtons({this.wordTestType,this.onRadioSelected});

 /*
  final Memorized _wordTestType;
  final ValueChanged _onRadioSelected;

  RadioButtons({testType,onRadioSelected})
      :_wordTestType =testType,
        _onRadioSelected =  onRadioSelected;
*/

  @override
  Widget build(BuildContext context) {
    return  Column(children: <Widget>[
        RadioListTile(
          secondary: Icon(Icons.category),
          controlAffinity: ListTileControlAffinity.trailing,
          title: Text("全ての単語"),
          value: Memorized.includedWords,
          groupValue: wordTestType,
          // ラジオボタン(暗記済除外)onChanged
          //ValuChangedなので、右辺にもvalue値必須！！！！
          onChanged: (value)=>onRadioSelected(value),
    ),
        RadioListTile(
         secondary: Icon(Icons.thumb_up),
          controlAffinity: ListTileControlAffinity.trailing,
          title: Text("暗記済単語を除外"),
          value: Memorized.excludedWords,
          groupValue: wordTestType,
          // ラジオボタン(暗記済含む)onChanged
          onChanged: (value)=>onRadioSelected(value),
        ),
      ],
      );

  }


//  _onRadioSelected(value) {
//    //onChangedの引数にRadioListTile(value:xx)の値が入ってくる
//    setState(() {
//      _testType = value;
//      print("testTypeは$value");
//    });
//  }


}
