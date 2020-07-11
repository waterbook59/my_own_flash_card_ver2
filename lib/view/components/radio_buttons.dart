//radioボタン statelessウィジェットで外だしパターン

import 'package:flutter/material.dart';
import 'package:myownflashcardver2/view/screens/home_screen.dart';

class RadioButtons extends StatelessWidget {

  final Memorized _testType;
  final ValueChanged _onRadioSelected;

  RadioButtons({testType,onRadioSelected})
      :_testType =testType,
        _onRadioSelected =  onRadioSelected;



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
          groupValue: _testType,
          // ラジオボタン(暗記済除外)onChanged
          onChanged: (value) => _onRadioSelected,
        ),
        RadioListTile(
          secondary: Icon(Icons.thumb_up),
          controlAffinity: ListTileControlAffinity.trailing,
          title: Text("暗記済単語を除外"),
          value: Memorized.excludedWords,
          groupValue: _testType,
          // ラジオボタン(暗記済含む)onChanged
          onChanged: (value) => _onRadioSelected,
        ),
      ],
      ),
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
