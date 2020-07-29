//いわゆるレポジトリ層
import 'package:flutter/material.dart';
import 'package:moor_ffi/database.dart';
import 'package:myownflashcardver2/data/event.dart';
import 'package:myownflashcardver2/models/db/dao.dart';
import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/model/words_model.dart';
import 'package:myownflashcardver2/util/extensions.dart';

import '../../main.dart';


class WordsRepository  {

  List<Word> result=List<Word>();
  List<WordRecord> resultWordRecords=List<WordRecord>();
  WordRecord _wordRecord = WordRecord();
  Event dbEvent;
//  final WordsDao _dao;
  final dao = database.wordsDao;

  Future<List<Word>> getWordList() async{
    // DBから得られたWordRecordsの結果をモデルクラスのWordsへ変換する
//    result = await database.allWords;
    resultWordRecords = await dao.allWords;
    print("DB空のWordRecordのリスト：$resultWordRecords");
    result =resultWordRecords.toWords(resultWordRecords);
    print("DBのWordRecordのリストをWordへ変換(中見れない..)：$result");
  return result;
  }

  Future<List<Word>> getMemorizedExcludeWordList() async{
//    result = await database.memorizedExcludeWords;
    resultWordRecords = await dao.memorizedExcludeWords;
    result =resultWordRecords.toWords(resultWordRecords);
    return result;
  }


  Future<List<Word>> allWordsSorted() async{
//    result = await database.allWordsSorted;
    resultWordRecords = await dao.allWordsSorted;
    result =resultWordRecords.toWords(resultWordRecords);
    return result;
  }

  Future<List<Word>> timeSorted() async{
//    result = await database.timeSorted;
    resultWordRecords = await dao.timeSorted;
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
    _wordRecord = word.toWordRecord(word);
    await dao.addWord(_wordRecord);
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
      _wordRecord = word.toWordRecord(word);
      await dao.updateWord(_wordRecord);
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
    _wordRecord = selectedWord.toWordRecord(selectedWord);
    await dao.deleteWord(_wordRecord);
    dbEvent = Event.delete;
    return dbEvent;
  }

  // 暗記済チェックを入れたWordを新たに更新登録
  Future<void> checkedUpdateFlag(Word updateWord) async{
//    await database.updateWord(updateWord);
    _wordRecord = updateWord.toWordRecord(updateWord);
    await dao.updateWord(_wordRecord);
  }

//  wordDeleted() {}

}