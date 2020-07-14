import 'package:flutter/material.dart';
import 'package:myownflashcardver2/view/screens/edit_screen.dart';

class EditWordViewModel extends ChangeNotifier {

  Text _titleText=Text("ペッペー");
  Text get titleText =>_titleText;

  Future<void> getTitleText(status) async{
    if(status == EditStatus.add){
      print("editwordviewmodel:$status");
      _titleText= Text("新しい単語の追加");
      notifyListeners();
    }
    if(status == EditStatus.edit){
      _titleText= Text("登録した単語の修正");
      notifyListeners();
    }

  }
}


