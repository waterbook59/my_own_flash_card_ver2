//いわゆるレポジトリ層
import 'package:flutter/material.dart';
import 'package:moor_ffi/database.dart';
import 'package:myownflashcardver2/models/db/database.dart';

import '../../main.dart';


class WordsRepository  {

  List<Word> result=List();

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

  //addWord,update,delete戻り値はvoidで良い？？
  Future addWord(word) async{
    await database.addWord(word);

//    return result;
  }

  Future<void> insertWord(Word word) async{

        try{
          await database.addWord(word);
        //本来ここでtoast(登録完了)
        }on SqliteException catch(error){
          //本来ここでtoast(この問題はすでに登録されているので登録できません)
          print("この問題はすでに登録:$error");
        }


  }

//  wordDeleted() {}

}