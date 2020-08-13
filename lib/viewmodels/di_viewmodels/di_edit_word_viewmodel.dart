import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/edit_status.dart';
import 'package:myownflashcardver2/data/event.dart';
import 'package:myownflashcardver2/data/uistate.dart';
import 'package:myownflashcardver2/models/model/words_model.dart';
import 'package:myownflashcardver2/models/repository/words_repository.dart';


class DiEditWordViewModel extends ChangeNotifier {

  //DIあり
  final WordsRepository _repository;
  DiEditWordViewModel({repository}):_repository =repository;

  //DIなし
//  final WordsRepository _repository = WordsRepository();

  bool _isQuestionEnabled=true;
  Text _titleText=Text("ペッペー");
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();
  List<Word> _words=List();
  //Stream関連
//  StreamController<Event> _loginSuccessAction = StreamController<Event>.broadcast();
  UiState _uiState = UiState.Idle;
  Event _eventStatus;


  Text get titleText =>_titleText;
  bool get isQuestionEnabled => _isQuestionEnabled;
  TextEditingController get questionController => _questionController;
  TextEditingController get answerController => _answerController;
  List<Word> get words =>_words;
  //Stream関連
//  StreamController<Event> get loginSuccessAction => _loginSuccessAction;
  UiState get uiState =>_uiState;
  bool get isLogging => uiState == UiState.Loading;
  Event get eventStatus => _eventStatus;


  //editScreenのinitStateに書いていた条件分岐による設定値をここで定義する
  Future<void> getTitleText(status,word) async{
    //returnいらないかが不安(notifyListenersの後に入れてみる??)
    if(status == EditStatus.add){
//      print("DiEditWordViewModelのstatus:$status");
      _isQuestionEnabled = true;
      _titleText= Text("新しい単語の追加");
      _questionController.text ="";
      _answerController.text = "";
      notifyListeners();
    }
    if(status == EditStatus.edit){
//      print("DiEditWordViewModelのstatus:$status");
      _isQuestionEnabled = false;
      _titleText= Text("登録した単語の修正");
      _questionController.text =word.strQuestion;
      _answerController.text = word.strAnswer;
      notifyListeners();
    }

  }


  Future<void> insertWord()async {
    var word = Word(
      strQuestion: _questionController.text,
      strAnswer: _answerController.text,
    );
    await _repository.insertWord(word);
    _questionController.clear();
    _answerController.clear();
    notifyListeners();
  }


  Future<void> onRegisteredWord(EditStatus status) async{
    //文字登録
    Word word = Word(
      strQuestion: _questionController.text,
      strAnswer: _answerController.text,
      strTime: DateTime.now(),
      isMemorized: false,
    );


    //ここでstatusによってaddとupdateの条件設定
    if (status == EditStatus.add) {
      if (_questionController.text == "" || _answerController.text == "") {
        //sink.addからnotifyListenerに変更して通知
//        _loginSuccessAction.sink.add(Event.empty);
        _eventStatus =Event.empty;
        notifyListeners();
        return;
      }
      //repositoryから返ってきたイベントを格納する
      _eventStatus =await _repository.addWord(word);
      //うまく登録できたらclear or エラー受け取ったらToast
//      _loginSuccessAction.sink.add(_eventStatus);
      notifyListeners();
      return;
    }

    if(status == EditStatus.edit){
      //レポジトリ層へ更新投げる
      _eventStatus =await _repository.insertWord(word);
      notifyListeners();
//      _loginSuccessAction.sink.add(_eventStatus);
      return;

    }

  }

//うまく登録できたらclear
  void textClear() {
    _questionController.clear();
    _answerController.clear();
  }

}



