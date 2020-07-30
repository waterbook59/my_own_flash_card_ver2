//homeScreenでConsumer使うならStatelessでhomeScreen書いてみる

import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/memorized_status.dart';

class HomeScreenViewModel extends ChangeNotifier {

  //右辺に初期値設定(単に変更したいだけなら設定しなくていよい)
   Memorized _testRadioType = Memorized.includedWords;
   Memorized get testRadioType => _testRadioType;


  //Consumerに提供するウィジェットのインスタンス
//  RadioButtons _selectRadioButton = RadioButtons();
//  RadioButtons get selectRadioButton => _selectRadioButton;

//  void changeRadioButton() {
//    _selectRadioButton = RadioButtons(
//      onRadioSelected: (value){
//        _testType = value;
//      },);
//  }

  void selected(value) {
    print("radioButtonsのvalue値：$value");
     _testRadioType = value;
    notifyListeners();
  }


}