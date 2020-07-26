import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/memorized_status.dart';
import 'package:myownflashcardver2/data/test_status.dart';
import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/repository/words_repository.dart';

class CheckTestViewModel extends ChangeNotifier  {

  final WordsRepository _repository = WordsRepository();
   List<Word> _words=List();
   int _remainedQuestion =0;
   TestStatus _testStatus = TestStatus.before_start;
   bool _isQuestionPart =false;
   bool _isAnswerPart =false;
   bool _isMemorizedCheck =false;
   bool _isMemorized =false;
   int _index =0;

   List<Word> get words =>_words;
   int get remainedQuestion => _remainedQuestion;
   TestStatus get testStatus => _testStatus;
   bool get isQuestionPart => _isQuestionPart;
   bool get isAnswerPart => _isAnswerPart;
   bool get isMemorizedCheck => _isMemorizedCheck;
   bool get isMemorized => _isMemorized;
   int get index => _index;

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

  Future<void> changeTestStatus(TestStatus testState) async{
   switch(testState){
     case TestStatus.before_start:
       _testStatus =TestStatus.show_question;
       _isQuestionPart =true;
       _isAnswerPart = false;
       _isMemorizedCheck =false;
       //Word作らず変数はwordsとindexのみ
       _index +=1;
       _remainedQuestion -= 1;

//       _showQuestion();
       //_wordsから選択した１行分を定義_selectedWord =_words[index]
       print("before_startで押すと$_testStatus");
       break;


   }
  }

  Future<void> clickCheckButton(bool value) async{
    _isMemorized=value;
    notifyListeners();
  }




}
