import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/edit_status.dart';
import 'package:myownflashcardver2/data/event.dart';
import 'package:myownflashcardver2/data/uistate.dart';
import 'package:myownflashcardver2/models/model/words_model.dart';
import 'package:myownflashcardver2/models/repository/words_repository.dart';


class EditWordViewModel extends ChangeNotifier {

  //DIあり
  final WordsRepository _repository;
  EditWordViewModel({repository}):_repository =repository;

  //DIなし
//  final WordsRepository _repository = WordsRepository();

  bool _isQuestionEnabled=true;
  Text _titleText=Text("ペッペー");
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();
  List<Word> _words=List();
  //Stream関連
  StreamController<Event> _loginSuccessAction = StreamController<Event>.broadcast();
  UiState _uiState = UiState.Idle;
  Event _eventStatus;


  Text get titleText =>_titleText;
  bool get isQuestionEnabled => _isQuestionEnabled;
  TextEditingController get questionController => _questionController;
  TextEditingController get answerController => _answerController;
  List<Word> get words =>_words;
  //Stream関連
  StreamController<Event> get loginSuccessAction => _loginSuccessAction;
  UiState get uiState =>_uiState;
  bool get isLogging => uiState == UiState.Loading;
  Event get eventStatus => _eventStatus;


  //editScreenのinitStateに書いていた条件分岐による設定値をここで定義する
  Future<void> getTitleText(status,word) async{
    //todo returnいらないかが不安(notifyListenersの後に入れてみる)
    if(status == EditStatus.add){
      print("EditWordViewModelのstatus:$status");
      _isQuestionEnabled = true;
      _titleText= Text("新しい単語の追加");
      _questionController.text ="";
      _answerController.text = "";
      notifyListeners();
    }
    if(status == EditStatus.edit){
      print("EditWordViewModelのstatus:$status");
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



//  void login() {
//    _uiState = UiState.Loading;
//    print(_uiState);
//    notifyListeners();
//
//    Future.delayed(Duration(milliseconds: 1500)).then((_) {
//      // Login Success!
//
//      _uiState = UiState.Loaded;
//      print(_uiState);
//      notifyListeners();
//      _loginSuccessAction.sink.add("ストリーム！！");
//    });
//  }

  //todo disposeをどこで使うのか確認
  @override
  void dispose() {
    _loginSuccessAction.close();
    super.dispose();
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
      //sink.addでStringじゃなくてイベントを渡して状態でNavigator.pushReplacementする・しないを分ける
        _loginSuccessAction.sink.add(Event.empty);
        return;
      }

      //repositoryから返ってきたイベントを格納する
      _eventStatus =await _repository.addWord(word);

      //うまく登録できたらclear or エラー受け取ったらToast
      _loginSuccessAction.sink.add(_eventStatus);
      return;

//      if(_eventStatus==Event.add){
//        _loginSuccessAction.sink.add(Event.add);
//        _questionController.clear();
//        _answerController.clear();
//        return;
//      }
//      if(_eventStatus==Event.adderror){
//        _loginSuccessAction.sink.add(Event.adderror);
//        return;
//      }

      //thenではなくasync/awaitに書き換え
//      await Future.delayed(Duration(milliseconds: 750));
//      _loginSuccessAction.sink.add(Event.add);
//      return;

//      Future.delayed(Duration(milliseconds: 1500)).then((_) {
//        _loginSuccessAction.sink.add(Event.add);
//        return;
//      });
    }

    if(status == EditStatus.edit){
      //レポジトリ層へ更新投げる
      _eventStatus =await _repository.insertWord(word);
      _loginSuccessAction.sink.add(_eventStatus);
      return;

//      if(_eventStatus==Event.update){
//        _loginSuccessAction.sink.add(Event.update);
//        return;
//      }
//      if(_eventStatus==Event.adderror){
//        _loginSuccessAction.sink.add(Event.adderror);
//        return;
//      }
    }

  }

//うまく登録できたらclear
  void textClear() {
    _questionController.clear();
    _answerController.clear();
  }

}



