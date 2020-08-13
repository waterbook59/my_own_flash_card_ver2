//いわゆるレポジトリ層
import 'package:flutter/material.dart';
import 'package:moor_ffi/database.dart';
import 'package:myownflashcardver2/data/event.dart';
import 'package:myownflashcardver2/models/db/dao.dart';
//import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/model/words_model.dart';
import 'package:myownflashcardver2/util/extensions.dart';

import '../../main.dart';


class WordsRepository  {

  //DIあり
  // DIなしだとクエリがnullで返ってくる(DIでdaoがインスタンスの値として渡された場合はここに格納)
  final WordsDao _dao;
  WordsRepository({dao}):_dao =dao;

    //DIなし
//  final WordsDao _dao = database.wordsDao;




  List<Word> result=List<Word>();
//  List<WordRecord> resultWordRecords=List<WordRecord>();
//  WordRecord _wordRecord = WordRecord();
  Event dbEvent;


  Future<List<Word>> getWordList() async{
    // DBから得られたWordRecordsの結果をモデルクラスのWordsへ変換する
//    result = await database.allWords;

  //このresultWordRecordsをfinalにすることで直接database.dartの参照やWordRecordのインスタンスがいらない
  final resultWordRecords = await _dao.allWords;
//    print("DB空のWordRecordのリスト：$resultWordRecords");
    result =resultWordRecords.toWords(resultWordRecords);
//    print("DBのWordRecordのリストをWordへ変換(中見れない..)：$result");
  return result;
  }

  Future<List<Word>> getMemorizedExcludeWordList() async{
//    result = await database.memorizedExcludeWords;
    final resultWordRecords = await _dao.memorizedExcludeWords;
    result =resultWordRecords.toWords(resultWordRecords);
    return result;
  }


  Future<List<Word>> allWordsSorted() async{
//    result = await database.allWordsSorted;
    final resultWordRecords = await _dao.allWordsSorted;
    result =resultWordRecords.toWords(resultWordRecords);
    return result;
  }

  Future<List<Word>> timeSorted() async{
//    result = await database.timeSorted;
    final resultWordRecords = await _dao.timeSorted;
    result =resultWordRecords.toWords(resultWordRecords);
    return result;
  }


  Future<Event> addWord(Word word) async{
    //入ってきたwordをwordRecordへ変換してdatabaseへ登録
    //returnするイベントを定義してイベントの状態をviewmodelに返す＆Future<void>からFuture<Event>変更
  try{
//    await database.addWord(word);
  //入ってきたwordをwordRecordへ変換してDBへ登録
    // エラー：Class 'Word' has no instance method 'toWordRecord'=>addWordの引数にWordクラスを明示したらOK!!
    final wordRecord = word.toWordRecord(word);
    await _dao.addWord(wordRecord);
    dbEvent =Event.add;
    return dbEvent;
  }on SqliteException catch (e) {
    //最終的にproxyproviderで自動通知できる？
    print("repositoryでのエラー：${e.toString()}");
    dbEvent =Event.adderror;
    }
    return dbEvent;
  }


  Future<Event> insertWord(Word word) async{
    try{
//      await database.updateWord(word);
      //入ってきたwordをwordRecordへ変換してDBへ登録
      final wordRecord = word.toWordRecord(word);
      await _dao.updateWord(wordRecord);
      dbEvent =Event.update;
      return dbEvent;
    }on SqliteException catch(error){
      print("repositoryでのエラー：この問題はすでに登録$error");
      dbEvent =Event.adderror;
    }
    return dbEvent;
  }

  Future<Event> deleteWord(Word selectedWord) async{
//    await database.deleteWord(selectedWord);
    //入ってきたwordをwordRecordへ変換してDBから削除
    final wordRecord = selectedWord.toWordRecord(selectedWord);
    await _dao.deleteWord(wordRecord);
    dbEvent = Event.delete;
    return dbEvent;
  }

  // 暗記済チェックを入れたWordを新たに更新登録
  Future<void> checkedUpdateFlag(Word updateWord) async{
//    await database.updateWord(updateWord);
    final wordRecord = updateWord.toWordRecord(updateWord);
    await _dao.updateWord(wordRecord);
  }

//  wordDeleted() {}

}