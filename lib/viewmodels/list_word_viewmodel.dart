import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/event.dart';
//モデルクラス参照はOKだが、viewModel層からのDBへの参照はNG!
//import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/model/words_model.dart';
import 'package:myownflashcardver2/models/repository/words_repository.dart';


class ListWordViewModel extends ChangeNotifier {


    final WordsRepository _repository = WordsRepository();

  //DI使うならProxyProvider使わなあかんでしょ
//  final WordsRepository _repository;
//  ListWordViewModel({repository}):
//      _repository =repository;

 //  直接database参照しないようにモデルクラスをDBに設定、Wordへ変換
  List<Word> _words=List<Word>();
  StreamController<Event> _deleteAction = StreamController<Event>.broadcast();
  Event _eventStatus;

  List<Word> get words =>_words;
  StreamController<Event> get deleteAction => _deleteAction;
  Event get eventStatus => _eventStatus;


  Future<void> getWordList() async{
    _words =await _repository.getWordList();
    // ここでレポジトリから返ってきたListの中身が空の場合エラーがでるので、isEmptyの条件追加！！！
    if(_words.isEmpty) {
      print("リストが空ですよー！！他のwidgetか何か返さないとダメですよー！");
      notifyListeners();
      //sink.addでeventを流してemptyViewにする or notifyListeners();のみでうまいことemptyView出す
    }else{
      print("DB=>レポジトリ=>vieModelで取得したデータの１番目：${_words[0].strQuestion}");
      notifyListeners();
    }

  }

  Future<void> allWordsSorted() async{
    _words =await _repository.allWordsSorted();
    notifyListeners();
  }

  Future<void> timeSorted() async{
    _words =await _repository.timeSorted();
    notifyListeners();
  }

  //削除だけではダメでそこからまたwordのリストを取ってくる必要あり
  //TODO 連続削除時にエラーUnhandled Exception: NoSuchMethodError: The method 'findAncestorStateOfType' was called on null

  Future<void> onDeletedWord( Word selectedWord) async{
    _eventStatus = await _repository.deleteWord(selectedWord);
//    notifyListeners();//いらない？？editWordViewModelの方ではsink.addだけで通知
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

