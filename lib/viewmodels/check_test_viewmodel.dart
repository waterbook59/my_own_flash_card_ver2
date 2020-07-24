import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/memorized_status.dart';
import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/repository/words_repository.dart';

class CheckTestViewModel extends ChangeNotifier  {

  final WordsRepository _repository = WordsRepository();
  List<Word> _words=List();
  int _remainedQuestion =0;

  List<Word> get words =>_words;
  int get remainedQuestion => _remainedQuestion;

 Future<void> getWordList(Memorized testType) async{
  switch (testType){
    case Memorized.includedWords:
      _words = await _repository.getWordList();
      _remainedQuestion=_words.length;
      print("全データ：$_words");
      _words.shuffle();
      notifyListeners();
      break;
    case Memorized.excludedWords:
      _words = await _repository.getMemorizedExcludeWordList();
      _remainedQuestion=_words.length;
      print("覚えたモノ以外のデータ：$_words");
      _words.shuffle();
      notifyListeners();
      break;
  }

 }

}
