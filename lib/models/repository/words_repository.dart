//いわゆるレポジトリ層
import 'package:flutter/material.dart';
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

}