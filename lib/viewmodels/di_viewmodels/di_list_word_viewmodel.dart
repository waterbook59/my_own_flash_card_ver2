import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/event.dart';
//モデルクラス参照はOKだが、viewModel層からのDBへの参照はNG!
//import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/model/words_model.dart';
import 'package:myownflashcardver2/models/repository/words_repository.dart';


class DiListWordViewModel extends ChangeNotifier {

  //DIあり
  final WordsRepository _repository;
  DiListWordViewModel({repository}):
      _repository =repository;

//  DIなし
//    final WordsRepository _repository = WordsRepository();


 //  直接database参照しないようにモデルクラスをDBに設定、Wordへ変換
  List<Word> _words=List<Word>();
  Event _eventStatus;
  //  StreamController<Event> _deleteAction = StreamController<Event>.broadcast();

  List<Word> get words =>_words;
  Event get eventStatus => _eventStatus;
  //  StreamController<Event> get deleteAction => _deleteAction;


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
  Future<void> onDeletedWord( Word selectedWord) async{
    _eventStatus = await _repository.deleteWord(selectedWord);

    // sink.addからnotifyListenerに変更!!!
    notifyListeners();
  }





}

