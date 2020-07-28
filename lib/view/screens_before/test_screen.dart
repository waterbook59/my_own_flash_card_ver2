import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/memorized_status.dart';
import 'package:myownflashcardver2/models/db/database.dart';
//import 'package:myownflashcardver2/view/screens/home_screen.dart';

import '../../main.dart';

enum TestStatus { before_start, show_question, show_answer, finished }

class TestScreen extends StatefulWidget {
  final Memorized testType;

  TestScreen({this.testType});

  @override
  _TestScreenState createState() => _TestScreenState();
}


class _TestScreenState extends State<TestScreen> {
  //enum TestStatusを受けての状態を格納する変数（前の画面から値を受けなければStatefulWidget直下出なくて良い）
  TestStatus _testStatus;
  List<WordRecord> _testDataList =List();
  int _remainedQuestion =0;
  String _questionWord="もんだい";
  String _answerWord ="こたえ";

  //表示するや否や
  bool isQuestionPart =false;
  bool isAnswerPart =false;
  bool isMemorizedCheck =false;
  bool isFabVisible =false;
//  bool isEndMessage = false;

  //checkboxListTileのvalue値
  bool _isMemorized =false;

  //List内を１つずつ表示するために 今選んでいるデータの１行分とList番号を変数に設定
  WordRecord _selectedWord;
  int _index=0;

  //dao追加
  final dao = database.wordsDao;


  @override
  void initState() {
    getWords();
    super.initState();
  }

  getWords() async{
    if(widget.testType == Memorized.includedWords){
      //awaitはdatabase.allWordsの前(_allWordListの前ではない)
      _testDataList = await dao.allWords;
    }else{
      _testDataList = await dao.memorizedExcludeWords;
    }

    _remainedQuestion =_testDataList.length;
    //List内をシャッフル
    _testDataList.shuffle();
//    _questionWord = _testDataList[0].strQuestion.toString();
//    _answerWord = _testDataList[0].strAnswer.toString();
    isQuestionPart =false;
    isAnswerPart =false;
    isMemorizedCheck =false;
    isFabVisible =true;
    _testStatus = TestStatus.before_start;
    print("initStateでのtestStatusは：$_testStatus");
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    //initState=>buildとinitState=>setState=>buildの２本が回っている
    print("テストタイプ:${widget.testType}");
    return WillPopScope(
      onWillPop:()=>_finishTestScreen() ,
      child: Scaffold(
        appBar: AppBar(
          title: Text("かくにんテスト"),
        ),
        body: Stack(
          children: <Widget>[
            Column(children: <Widget>[
              SizedBox(height: 30.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Table(
                    border: TableBorder.all(color: Colors.white),
                    children: [
                      TableRow(
                        children: [
                          Center(child: Text("残り問題数", style: TextStyle(fontSize: 20.0),)),
                          Center(child: Text(_remainedQuestion.toString(), style: TextStyle(fontSize: 20.0),)),
                        ],
                      ),
                    ]
                ),
              ),
              SizedBox(height: 25.0,),
              _questionImage(),
              SizedBox(height: 30.0,),
              _answerImage(),
              SizedBox(height: 25.0,),
              _memorizedCheck(),
            ],),
            _endMessage(),
          ],
        ),
        floatingActionButton: isFabVisible ? _fab() : null,
      ),
    );
  }

  Widget _questionImage() {
    if(isQuestionPart){
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset("assets/images/image_flash_question.png"),
          Center(child: Text(_questionWord,style: TextStyle(fontSize:40.0,color: Colors.black87),)),
        ],
      );
    }else{
      return Container();
    }

  }

  Widget _answerImage() {
    if(isAnswerPart){
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset("assets/images/image_flash_answer.png"),
          Center(child: Text(_answerWord,style: TextStyle(fontSize:40.0,color: Colors.black87),)),
        ],
      );
    }else{
      return Container();
    }
  }

  Widget _memorizedCheck() {
    if(isMemorizedCheck){
      return CheckboxListTile(
        title: Text("暗記済にする単語にはチェックを入れてください"),
        secondary: Icon(Icons.beach_access),
        controlAffinity: ListTileControlAffinity.trailing,
        // 暗記済フラグをDBへ登録
        value: _isMemorized,
        onChanged: (bool value){
          setState(() {
            _isMemorized =value;
          });
        },
      );
    }else{
      return Container();
    }

  }

//  Widget _endMessage() {
//    if(isEndMessage){
//      return Text("テスト終了");
//    }
//  }

  Widget _endMessage() {
    if(_testStatus == TestStatus.finished){
      return Center(child: Text("テスト終了",style: TextStyle(fontSize: 50.0),));
    }else {
      return Container();
    }
  }



  Widget _fab() {
    return FloatingActionButton(
      // FABのonPressed
      onPressed: ()=> _goNextState(),
      tooltip: "次へ",
      child: Icon(Icons.skip_next),
    );
  }

  _goNextState() async{

      //switch(状態を管理するために設定したプロパティ)
      switch(_testStatus){
        case TestStatus.before_start:
        //_testStatusがbefore_startの場合に押すと、状態をshow_questionへ変更し、問題表示を変更する
          _testStatus = TestStatus.show_question;
          _showQuestion();
          print("before_startで押すと$_testStatus");
          break;
        case TestStatus.show_question:
          _testStatus = TestStatus.show_answer;
          print("show_questionで押すと$_testStatus");
          _showAnswer();
          break;
        case TestStatus.show_answer:
          //DBへの暗記済フラグの更新処理（１行分丸ごと更新）
        //更新後の状態で1行分インスタンス化=>更新クエリの変数に設定
          await _checkedUpdateFlag();
          print(_testStatus);
          if(_remainedQuestion<=0){
            _showFinished();
          }else{
            //ここでbefore_startに戻らず、show_questionにして、やることはbefore_start内の_showQuestion()
            _testStatus = TestStatus.show_question;
            _showQuestion();

          }
          break;
        case TestStatus.finished:
          break;
      }
  }

   _showQuestion() {
    //今の表示している１行分のデータはこれだ！
     _selectedWord =_testDataList[_index];
   //bool型の表示有無の条件はsetState内で設定なので下の書き方は変更
     //isQuestionPart =true;
   //なんかこの書き方より、今の選択データをwordのインスタンスを作成してそこからデータを取るのが綺麗な書き方かも
    // _questionWord = _testDataList[_index].strQuestion.toString();
     setState(() {
       isQuestionPart =true;
       //下の２行入れないと、前の答えの問題がそのまま次の問題で表示されてしまう
       isAnswerPart = false;
       isMemorizedCheck =false;
       //問題カードの表示を取得した１行分のデータから引っ張ってくる
       _questionWord = _selectedWord.strQuestion.toString();
     });
     //上のsetStateによりbuildで現在のリストの最初(_selectedWord.strQuestion)から問題表示した後、次の問題を表示するため、setStateの後に数の増減をする
     _remainedQuestion -= 1;
     _index +=1;
   }

   _showAnswer() {
  //   _selectedWord =_testDataList[_index];
     setState(() {
       isQuestionPart =true;
       isAnswerPart = true;
       isMemorizedCheck =true;
       _answerWord=_selectedWord.strAnswer.toString();
       //CheckboxListTileのvalue値へ取ってきたデータ(_selectedWord)内のisMemorizedを設定
       _isMemorized = _selectedWord.isMemorized;
     });

   }

  Future<void> _checkedUpdateFlag() async{
    var updateWordRecord = WordRecord(
      strQuestion: _selectedWord.strQuestion,
      strAnswer: _selectedWord.strAnswer,
      strTime: _selectedWord.strTime,
      isMemorized: _isMemorized);
     await dao.updateWord(updateWordRecord);
//     print(updateWord.toString());
  }

   _showFinished() {
    setState(() {
//      isEndMessage =true;
      _testStatus = TestStatus.finished;
      isFabVisible =false;
    });

   }

  Future<bool> _finishTestScreen() async{

    //1. onWillPopの戻り値はFuture<bool>なのでメソッドの頭にFuture<bool>,returnでshowDialogで返す
    //2. showDialogの戻り値はFutureなので非同期処理でasync/awaitにする
    //3. Navigator.pop×2だと、showDialogは戻り値としてboolが返ってこないので、nullを避けるため、
    //4. showDialog()??false;で三項条件演算子でfalseにしてNavigator.popを避ける

    return await showDialog(context: context, builder: (_) => AlertDialog(
      title: Text("テストの終了"),
      content: Text("テストを終了してもいいですか？"),
      actions: <Widget>[
        FlatButton(
          child: Text("はい"),
          onPressed: (){
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("いいえ"),
          onPressed: ()=>Navigator.pop(context),
        ),
      ],

    )
    )?? false;
  }








}
