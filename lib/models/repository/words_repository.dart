//いわゆるレポジトリ層
import 'package:flutter/material.dart';
import 'package:moor_ffi/database.dart';
import 'package:myownflashcardver2/data/event.dart';
import 'package:myownflashcardver2/models/db/database.dart';

import '../../main.dart';


class WordsRepository  {

  List<Word> result=List();
  Event dbEvent;

  Future<List<Word>> getWordList() async{
    result = await database.allWords;
  return result;
  }

  Future<List<Word>> allWordsSorted() async{
    result = await database.allWordsSorted;
    return result;
  }

  Future<List<Word>> timeSorted() async{
    result = await database.timeSorted;
    return result;
  }


  Future<Event> addWord(word) async{
    //returnするイベントを定義してイベントの状態をviewmodelに返す＆Future<void>からFuture<Event>変更
  try{
    await database.addWord(word);
    dbEvent =Event.add;
    return dbEvent;
  }on SqliteException catch (e) {
    //最終的にproxyproviderで自動通知できる？
    print("repositoryでのエラー：${e.toString()}");
    dbEvent =Event.adderror;
    } return dbEvent;
  }


  Future<Event> insertWord(Word word) async{
    try{
      await database.updateWord(word);
      dbEvent =Event.update;
      return dbEvent;
    }on SqliteException catch(error){
      print("repositoryでのエラー：この問題はすでに登録$error");
      dbEvent =Event.adderror;
    }return dbEvent;
  }

//  wordDeleted() {}

}