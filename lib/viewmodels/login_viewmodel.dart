import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/uistate.dart';
import 'package:myownflashcardver2/view/screens/screen_home.dart';
import 'package:rxdart/rxdart.dart';



class LoginViewModel extends ChangeNotifier {
  var _uiState = UiState.Idle;
  UiState get uiState => _uiState;

  bool get isLogging => uiState == UiState.Loading;

  //finalにしてStreamControllerを単一の流れに：意味なし
  final StreamController<String> _loginSuccessAction = StreamController<String>.broadcast();
  //BehaviorSubjectに変更してみる
//  var _loginSuccessAction = BehaviorSubject<String>();
  StreamController<String> get loginSuccessAction => _loginSuccessAction;

  void login(context) {
    _uiState = UiState.Loading;
    notifyListeners();

    Future.delayed(Duration(milliseconds: 1500)).then((_) {
      // Login Success!
      _uiState = UiState.Loaded;
      notifyListeners();

      _loginSuccessAction.sink.add("view側へイベント通知");
//      print("sink.addした後");
//      print("Consumer下のLoginボタンonPressed押してviewModel内loginメソッド:$context");

      //Idleに変えてみる
//      _uiState = UiState.Idle;
//      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ScreenHome()));
    });

    //ログインの関数の中にdispose要素を入れてみる：Bad state: Cannot add new events after calling close
//    _loginSuccessAction.close();
  }

  @override
  void dispose() {
    _loginSuccessAction.close();
//    notifyListeners();
    super.dispose();
  }
}
