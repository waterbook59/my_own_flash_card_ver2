
import 'package:flutter/material.dart';
import 'package:moor_ffi/database.dart';
import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/main.dart';
import 'package:myownflashcardver2/view/components/words_textfield.dart';
//import 'package:myownflashcardver2/parts/words_textfield.dart';
import 'package:myownflashcardver2/view/screens_before/word_list_screen.dart';
import 'package:toast/toast.dart';

//enumは分岐される側で設定がわかりやすいかも
enum EditStatus { add, edit }

class EditScreen extends StatefulWidget {
  final EditStatus status;
  final WordRecord word;

  //Navigatorでこのページにくるときにstatusで分けるためコンストラクタ設定
  //statusとデータをwordListScreenから持ってくるために1行分のデータを設定
  EditScreen({@required this.status, this.word});


  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _questionController =TextEditingController();
  TextEditingController _answerController=TextEditingController();

  String _titleText;
  bool _isQuestionEnabled;

  //外に出したWidgetでも
  TextEditingController testText=TextEditingController();
  //dao追加
  //todo テスト用に//
   //final dao = database.wordsDao;


  //enumの分岐表示はinitStateで実装
  //wordListScreenの各ボタン(FABとLisTileのonTap)から異なる形のEditScreen()が作られている
  //EditScreen(status:EditStatus.add) or
  //EditScreen(status:EditStatus.edit,word:updateWord(_wordList[position]))
  //Stateウィジェット(育ての親)からStatefulウィジェット(生みの親)のfieldにアクセスする場合は、widget.field名
  @override
  void initState() {
  if(widget.status == EditStatus.add){
    _isQuestionEnabled = true;
    _questionController.text ="";
    _answerController.text = "";
    _titleText = "新しい単語の追加";
    return;
  }
  if(widget.status == EditStatus.edit){
    //_questionControllerはprimary keyとして設定しているため、変更できないようないようにする
    _isQuestionEnabled =false;
    _questionController.text = widget.word.strQuestion;
    _answerController.text = widget.word.strAnswer;
    _titleText = "登録した単語を修正";
    return;
  }
    super.initState();
  }


//  TextEditingController questionText;
//  WordsTextField _questionInput =WordsTextField(label:"問題");
//  WordsTextField _answerInput =WordsTextField(label: "こたえ",);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(//戻るときに単にpopではなく、pushReplace
      onWillPop: ()=>_backToListScreen(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titleText),
          actions: <Widget>[
            IconButton(
              tooltip: "登録",
              icon: Icon(Icons.check),
              onPressed: ()=>_onWordRegistered(),
            ),
          ],
        ),
        body:SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0,),
              const Text("問題と答えを入力して「登録」ボタンを押してください"),
              const SizedBox(height: 40.0,),
              _questionInput(),
              //WordsTextField(label: "問題",),
              const SizedBox(height: 30.0,),
               _answerInput(),
              WordsTextField(label: "外に出したWidget",textEditingController: testText,),
            ],
          ),
        ),
      ),
    );

  }

  Future<bool> _backToListScreen() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=>WordListScreen())
        );
        //trueにすると、デフォルトの戻るやり方、つまりEditScreenをNavigator.pop(削除)する
        //Navigator.pushReplacementなし＆ return Future.value(true)だとHomeScreenへ戻る
    //戻り値trueにすると、デフォルトの戻るやり方＝>Navigator.popを呼び出す形でpushReplacementなしだとpopされてHomeScreenへ戻る

        //falseにするとデフォルトの戻るやり方は行われず、EditScreenのNavigator.pop(削除)されない
        //Navigator.pushReplacementなし＆ return Future.value(false)だとHomeScreenへ戻れない
    //つまり、EditScreenが削除されないので、その画面から戻らない
        return Future.value(false);
  }



  Widget _questionInput() {
    return Column(
      children: <Widget>[
        Text("問題",style: TextStyle(fontSize: 30.0),),
        Padding(
          padding: const EdgeInsets.only(right:25.0,left:25.0,top:15.0),
          child: TextField(
            controller: _questionController,
            enabled: _isQuestionEnabled,
            style: TextStyle(fontSize: 25.0),
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _answerInput() {
    return Column(
      children: <Widget>[
        Text("答え",style: TextStyle(fontSize: 30.0),),
        Padding(
          padding: const EdgeInsets.only(right:25.0,left:25.0,top:15.0),
          child: TextField(
            controller: _answerController,
            style: TextStyle(fontSize: 25.0),
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  _onWordRegistered() {
  if(widget.status == EditStatus.add) {
    _insertWord();
    //外に出したWidgetから入力したテキストを取ってくる
    print("入力した問題「${_questionController.text}」");
    return;
  }
  if(widget.status == EditStatus.edit){
    _modifiedWord();
    return;
  }
  }

//  _onWordRegistered() {
//    if(widget.status == EditStatus.add) {
//      showDialog(
//        context: context,
//        builder: (_) =>
//            AlertDialog(
//              title: Text("${_questionController.text}の登録"),
//              content: Text("登録してもいいですか？"),
//              actions: <Widget>[
//                FlatButton(
//                  child: Text("はい"),
//                  onPressed: () {
//                     _insertWord();
//                    Navigator.pop(context);
//                  },
//                ),
//                FlatButton(
//                    child: Text("いいえ"),
//                    onPressed: () => Navigator.pop(context),
//                ),
//              ],
//            ),
//      );
//    }
//
//    if(widget.status == EditStatus.edit){
//      showDialog(
//        context: context,
//        builder: (_) =>
//            AlertDialog(
//              title: Text("${_questionController.text}の変更"),
//              content: Text("変更してもいいですか？"),
//              actions: <Widget>[
//                FlatButton(
//                  child: Text("はい"),
//                  onPressed: () {
//                    _modifiedWord();
//                    Navigator.pop(context);
//                  },
//                ),
//                FlatButton(
//                    child: Text("いいえ"),
//                    onPressed: () => Navigator.pop(context),
//                ),
//              ],
//            ),
//      );
//    }
//  }


   _insertWord() async{
    //TextEditingControllerの入力がされていない時
    if(_questionController.text== ""|| _answerController.text == ""){
      Toast.show("問題または答えを入力してください", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    return;
    }


    showDialog(context: context, builder: (_) => AlertDialog(
          title: Text("${_questionController.text}の登録"),
          content: Text("登録してもいいですか？"),
          actions: <Widget>[
          FlatButton(
            child: Text("はい"),
            onPressed: () async {
            /* primary keyを設定しているので、同じ文字は登録できない
              try,catch文を用いて重複の時はエラーをだす
            */
              //データ１行分のコンストラクタに入力値を初期設定
              var wordRecord = WordRecord(
                strQuestion: _questionController.text,
                strAnswer: _answerController.text,
                strTime: DateTime.now(),
                isMemorized: false,
              );

            try {
              //database.dartで定義したaddWordメソッドへ上記のword（コンストトラクタ）を渡す
              //ちなみにdatabaseはmain.dartでインスタンス化済
              //todo テスト用にdao//
//              await dao.addWord(wordRecord);
              //databaseへ文字登録が終わったらTextField空白にする
              _questionController.clear();
              _answerController.clear();
//              print("登録できた");//
              Toast.show("登録完了しました", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
            } on SqliteException catch (e) {
              print(e.toString());
              Toast.show("この問題はすでに登録されているので登録できません", context,
                  duration: Toast.LENGTH_LONG);
              // return; //finallyの処理を実行させるためにfinallyをつける
            }finally{//finallyはtryの場合でもcatchの場合でも実行する,ダイアログ閉じるために行う
              Navigator.pop(context);
            }
          },
        ),
          FlatButton(
            child: Text("いいえ"),
            onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
    );

             //1.Create文の変数をメソッド内で宣言->2.addWordメソッドで登録
//             var word = Word(
//               strQuestion: _questionController.text, //問題のTextFieldに入力したやつ
//               strAnswer: _answerController.text,
//               strTime: DateTime.now(),
//               isMemorized: false,
//             );

             //同じプラマイリーキーをもつ言葉を登録した時にエラーメッセージを出す
//             try {
//               //addWordメソッド=>CRUD戻り値全てFutureなので投げる側ではasync await
//               await database.addWord(word);
//               print("OK");
//               //入力したものをクリア
//               _questionController.clear();
//               _answerController.clear();
//               // 登録完了メッセージ
//               Toast.show("登録が完了しました", context, duration: Toast.LENGTH_LONG);
//             } on SqliteException catch (e) {
//               Toast.show("この問題はすでに登録されているので登録できません", context,
//                   duration: Toast.LENGTH_LONG);
//                return; //finallyの処理を実行させるためにfinallyをつける
//             }
  }



   _modifiedWord() async{
     if(_questionController.text== ""|| _answerController.text == ""){
       Toast.show("問題または答えを入力してください", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
       return;
     }

     showDialog(context: context, builder: (_)=>AlertDialog(
       title: Text("${_questionController.text}の変更"),
       content: Text("変更してもいいですか？"),
       actions: <Widget>[
         FlatButton(
           child: Text("はい"),
           onPressed: () async{
             var wordRecord = WordRecord(
               strQuestion: _questionController.text,
               strAnswer: _answerController.text,
               strTime: DateTime.now(),
               isMemorized: false,
             );
             try{
               //database.dartで定義したaddWordメソッドへ上記のword（コンストトラクタ）を渡す
               //ちなみにdatabaseはmain.dartでインスタンス化済
               //todo テスト用にdao//
             //  await dao.updateWord(wordRecord);

               /* chapter251 AlertDialogから直接一覧画面ページへ行くには
               Navigator.popでまずダイアログを除去
               それから _backToListScreen（pushReplacementのこと）を実行
                */
               Navigator.pop(context);
              //appbarの左側でwordListScreenへ戻るのと同じ
               _backToListScreen();
//               print("更新できた");
               Toast.show("更新完了しました", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

             } on SqliteException catch (e){
               Toast.show("エラー：$e", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
               Navigator.pop(context);
             }
           },
         ),
         FlatButton(
           child: Text("いいえ"),
           onPressed: ()=>Navigator.pop(context),
         ),

       ],
     ));











   }



}
