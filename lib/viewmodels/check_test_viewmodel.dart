import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/memorized_status.dart';
import 'package:myownflashcardver2/data/test_status.dart';
import 'package:myownflashcardver2/models/model/words_model.dart';
import 'package:myownflashcardver2/models/repository/words_repository.dart';

class CheckTestViewModel extends ChangeNotifier  {

  //DIあり
  final WordsRepository _repository;
  CheckTestViewModel({repository}):_repository=repository;
  //DIなし
//  final WordsRepository _repository = WordsRepository();
   List<Word> _words=List<Word>();
   int _remainedQuestion =0;
   TestStatus _testStatus = TestStatus.before_start;
   bool _isQuestionPart =false;
   bool _isAnswerPart =false;
   bool _isMemorizedCheck =false;
   bool _isMemorized =false;
   int _index =-1;
   bool  _isFabVisible =true;
   bool _isEndMessageVisible =false;

   List<Word> get words =>_words;
   int get remainedQuestion => _remainedQuestion;
   TestStatus get testStatus => _testStatus;
   bool get isQuestionPart => _isQuestionPart;
   bool get isAnswerPart => _isAnswerPart;
   bool get isMemorizedCheck => _isMemorizedCheck;
   bool get isMemorized => _isMemorized;
   int get index => _index;
   bool get isFabVisible =>_isFabVisible;
   bool get isEndMessageVisible => _isEndMessageVisible;

  Future<void> getWordList(Memorized testType) async{
  switch (testType){
    case Memorized.includedWords:
      _words = await _repository.getWordList();
      if(_words.isEmpty) {
        print("リストが空ですよー！！他のwidgetか何か返さないとダメですよー！");
        return;//notifyListener??
        //sink.addでeventを流してemptyViewにする or notifyListeners();のみでうまいことemptyView出す
      }
      _remainedQuestion=_words.length;
      _words.shuffle();
      print("shuffle後のデータの１番目：${_words[0].strQuestion}");
      //ここにisQuestionPart,isAnswerPart,isMemorizedCheck,isFabVisible,isEndMessageVisibleの初期条件をないと前のテストが残る
      _isQuestionPart =false;
      _isAnswerPart = false;
      _isMemorizedCheck =false;
      _isFabVisible =true;
      _isEndMessageVisible =false;
      //ここでindex初期値に戻さないと２周目でindexが増え続けてエラー
      _index=-1;
      _testStatus = TestStatus.before_start;
      notifyListeners();
      break;
    case Memorized.excludedWords:
      _words = await _repository.getMemorizedExcludeWordList();
      //なぜかこっちは_words.isEmptyの条件つけなくてもエラー出ない
      print("覚えたモノ以外のデータ：$_words");
      _remainedQuestion=_words.length;
      _words.shuffle();
      _isQuestionPart =false;
      _isAnswerPart = false;
      _isMemorizedCheck =false;
      _isFabVisible =true;
      _isEndMessageVisible =false;
      _index=-1;
      _testStatus = TestStatus.before_start;
      notifyListeners();
      break;
  }
 }

  Future<void> changeTestStatus(TestStatus testState) async{
    //TODO 登録数がゼロの時にボタン押すとエラー！！
    if(_remainedQuestion<=0){
      return;
    }
   switch(testState){
     case TestStatus.before_start:
       print("before_startで押すと$_testStatus/残り問題数:$_remainedQuestion");
       _testStatus =TestStatus.show_question;
       _isQuestionPart =true;
       _isAnswerPart = false;
       _isMemorizedCheck =false;
       //Word作らず変数はwordsとindexのみ
       notifyListeners();
       _index +=1;
       _remainedQuestion -= 1;
       //_wordsから選択した１行分を定義_selectedWord =_words[index]
       break;
     case TestStatus.show_question:
       _testStatus = TestStatus.show_answer;
       print("show_questionで押すと$_testStatus/残り問題数:$_remainedQuestion");
       _isQuestionPart =true;
       _isAnswerPart = true;
       _isMemorizedCheck =true;
       //CheckboxListTileのvalue値へ取ってきたデータ(_selectedWord)内のisMemorizedを設定
       _isMemorized = _words[_index].isMemorized;
       notifyListeners();
       break;
     case TestStatus.show_answer:
       //DBへの暗記済フラグの更新処理（１行分丸ごと更新）
       //更新後の状態で1行分インスタンス化=>更新クエリの変数に設定
       Word updateWord = Word(
           strQuestion: _words[_index].strQuestion,
           strAnswer: _words[_index].strAnswer,
           strTime: _words[_index].strTime,
           isMemorized: _isMemorized);
       print("updateWordのstrQuestion：${updateWord.strQuestion}");
       await _repository.checkedUpdateFlag(updateWord);//この後notifyListener?
       if(_remainedQuestion<=0){
         print("show_answer問題0以下で押すと$_testStatus/残り問題数:$_remainedQuestion");
         _isFabVisible = false;
         _isEndMessageVisible =true;
         _testStatus = TestStatus.finished;
           notifyListeners();
       }else{
         _testStatus = TestStatus.show_question;
         print("show_answer問題0以上で押すと$_testStatus/残り問題数:$_remainedQuestion");
         _isQuestionPart =true;
         _isAnswerPart = false;
         _isMemorizedCheck =false;
         //Word作らず変数はwordsとindexのみ
         notifyListeners();
         _index +=1;
         _remainedQuestion -= 1;
       }
       break;
     case TestStatus.finished:
       print("$_testStatus");
       notifyListeners();
       break;
   }
  }

  Future<void> clickCheckButton(bool value) async{
    _isMemorized=value;
    notifyListeners();
  }




}
