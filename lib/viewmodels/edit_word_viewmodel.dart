import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/edit_status.dart';
//import 'package:myownflashcardver2/view/screens_before/edit_screen.dart';

class EditWordViewModel extends ChangeNotifier {

  bool _isQuestionEnabled=true;
  Text _titleText=Text("ペッペー");
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();

  Text get titleText =>_titleText;
  bool get isQuestionEnabled => _isQuestionEnabled;
  TextEditingController get questionController => _questionController;
  TextEditingController get answerController => _answerController;

  //editScreenのinitStateに書いていた条件分岐による設定値をここで定義する
  Future<void> getTitleText(status,word) async{
    if(status == EditStatus.add){
      print("editwordviewmodel:$status");
      _isQuestionEnabled = true;
      _titleText= Text("新しい単語の追加");
      _questionController.text ="";
      _answerController.text = "";
      notifyListeners();
    }
    if(status == EditStatus.edit){
      print("editwordviewmodel:$status");
      _isQuestionEnabled = false;
      _titleText= Text("登録した単語の修正");
      _questionController.text =word.strQuestion;
      _answerController.text = word.strAnswer;
      notifyListeners();
    }

  }
}


