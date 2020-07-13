import 'package:flutter/material.dart';
//database参照してはいけないのでは・・・
import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/repository/words_repository.dart';

class ListWordViewModel extends ChangeNotifier {


    final WordsRepository _repository = WordsRepository();

  //DI使うならProxyProvider使わなあかんでしょ
//  final WordsRepository _repository;
//  ListWordViewModel({repository}):
//      _repository =repository;

  //直接database参照しないように別のList<WordRecord>とかが必要？
  List<Word> _words=List();
  List<Word> get words =>_words;

  Future<void> getWordList() async{
    _words =await _repository.getWordList();
    print("レポジトリから取れてくれ：$_words");
    notifyListeners();
  }

  Future<void> allWordsSorted() async{
    _words =await _repository.allWordsSorted();
    notifyListeners();
  }

  Future<void> timeSorted() async{
    _words =await _repository.timeSorted();
    notifyListeners();
  }

//  Future<void> wordDeleted() async{
//    _words =await _repository.wordDeleted();
//    notifyListeners();
//  }


}

