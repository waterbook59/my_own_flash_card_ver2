import 'package:flutter/material.dart';
import 'package:myownflashcardver2/models/repository/words_repository.dart';

class ListWordViewModel extends ChangeNotifier {

  final WordsRepository _repository;

  ListWordViewModel({repository}):
      _repository =repository;

  List<Word> _words=List();
  List<Word> get words =>_words;

  Future<void> getWordList() async{

    _words =await _repository.getWordList();
    notifyListeners();
  }


}

