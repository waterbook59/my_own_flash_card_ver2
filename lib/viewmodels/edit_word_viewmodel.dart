import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/edit_status.dart';
import 'package:myownflashcardver2/data/uistate.dart';
import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/repository/words_repository.dart';


class EditWordViewModel extends ChangeNotifier {

  final WordsRepository _repository = WordsRepository();

  bool _isQuestionEnabled=true;
  Text _titleText=Text("ペッペー");
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();
  List<Word> _words=List();
  //Stream関連
  StreamController<String> _loginSuccessAction = StreamController<String>.broadcast();
  UiState _uiState = UiState.Idle;


  Text get titleText =>_titleText;
  bool get isQuestionEnabled => _isQuestionEnabled;
  TextEditingController get questionController => _questionController;
  TextEditingController get answerController => _answerController;
  List<Word> get words =>_words;
  //Stream関連
  StreamController<String> get loginSuccessAction => _loginSuccessAction;
  UiState get uiState =>_uiState;
  bool get isLogging => uiState == UiState.Loading;

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

  //toastは本来viewModel層が良さそうやけど、難しいからcallback的にview層が良さげ

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



  void login() {
    _uiState = UiState.Loading;
    print(_uiState);
    notifyListeners();

    Future.delayed(Duration(milliseconds: 1500)).then((_) {
      // Login Success!

      _uiState = UiState.Loaded;
      print(_uiState);
      notifyListeners();
      _loginSuccessAction.sink.add("ストリーム！！");
    });
  }

  @override
  void dispose() {
    _loginSuccessAction.close();
    super.dispose();
  }

  void onRegisteredWord(EditStatus status) {
    //    if(status == EditStatus.add){
//      if(viewModel.questionController.text ==""|| viewModel.answerController.text == ""){
//        Toast.show("問題とこたえの両方を入力しないと登録できません。", context, duration: Toast.LENGTH_LONG);
//        return;

    Future.delayed(Duration(milliseconds: 1500)).then((_) {
      // Login Success!
      _loginSuccessAction.sink.add("${_questionController.text}");
    });

  }

}



