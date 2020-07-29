import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/event.dart';
//database参照してはいけない・
//import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/model/words_model.dart';
import 'package:myownflashcardver2/models/repository/words_repository.dart';

class ListWordViewModel extends ChangeNotifier {


    final WordsRepository _repository = WordsRepository();

  //DI使うならProxyProvider使わなあかんでしょ
//  final WordsRepository _repository;
//  ListWordViewModel({repository}):
//      _repository =repository;

  //TODO 直接database参照しないように別のList<WordRecord>とかが必要？
  List<Word> _words=List<Word>();
  StreamController<Event> _deleteAction = StreamController<Event>.broadcast();
  Event _eventStatus;

  List<Word> get words =>_words;
  StreamController<Event> get deleteAction => _deleteAction;
  Event get eventStatus => _eventStatus;


  Future<void> getWordList() async{
    _words =await _repository.getWordList();
    print("DB=>レポジトリ=>vieModelで取得したデータの１番目：${_words[0].strQuestion}");
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

  //削除だけではダメでそこからまたwordのリストを取ってくる必要あり？？
  Future<void> onDeletedWord( Word selectedWord) async{
    _eventStatus = await _repository.deleteWord(selectedWord);
    notifyListeners();
    _deleteAction.sink.add(_eventStatus);
  }

  //TODO いつstreamをdisposeするか確認
  @override
  void dispose() {
    super.dispose();
    _deleteAction.close();
  }


//  Future<void> wordDeleted() async{
//    _words =await _repository.wordDeleted();
//    notifyListeners();
//  }


}

