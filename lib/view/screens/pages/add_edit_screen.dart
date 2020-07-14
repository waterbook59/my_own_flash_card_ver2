import 'package:flutter/material.dart';
import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/view/components/word_text_input.dart';
import 'package:myownflashcardver2/viewmodels/edit_word_viewmodel.dart';
import 'package:provider/provider.dart';

import '../edit_screen.dart';
import 'list_word_screen.dart';


class AddEditScreen extends StatelessWidget {
  final EditStatus status;
  final Word word;

//  final String _appBarTitleText="パッパラー";
  final TextEditingController _questionController=TextEditingController();
  final TextEditingController _answerController=TextEditingController();

  AddEditScreen({@required this.status,this.word});


  @override
  Widget build(BuildContext context) {
//    String _titleText="試しのタイトル(statusで分ける予定)";

    //画面遷移したときinitState的にstatusの違いでText(新しい単語の追加 or 登録した単語の修正)というインスタンスをモデルの方で作っておく
    final model = Provider.of<EditWordViewModel>(context,listen: false);
    Future(()=>model.getTitleText(status));



    return WillPopScope(//戻るときに単にpopではなく、pushReplace
      onWillPop: ()=> _backToListScreen(context),
      child: Scaffold(
        appBar: AppBar(
          title:
//          Text(_titleText),
          Consumer<EditWordViewModel>(
              builder: (context,model,child){
            return model.titleText;
          }),

          actions: <Widget>[
            IconButton(
              tooltip: "登録",
              icon: Icon(Icons.check),
              onPressed: ()=>_onWordRegistered(context),
            ),
          ],
        ),
        body:SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0,),
              const Text("問題と答えを入力して「登録」ボタンを押してください"),
              const SizedBox(height: 40.0,),
              WordTextInput(label: "問題",textEditingController: _questionController),
              const SizedBox(height: 30.0,),
              WordTextInput(label: "答え",textEditingController: _answerController),
              //WordsTextField(label: "問題",),

//              _answerInput(),
//              WordsTextField(label: "外に出したWidget",textEditingController: testText,),
            ],
          ),
        ),
      ),
    );
  }

  Future<void>  _onWordRegistered(BuildContext context) async{
    print(_questionController.text);
    print(_answerController.text);
 /*
    if(status == EditStatus.add) {
      await _insertWord();
      //外に出したWidgetから入力したテキストを取ってくる
//      print(testText.text);
      return;
    }
    if(status == EditStatus.edit){
      await _modifiedWord();
      return;
    }

  */
}

  Future<bool> _backToListScreen(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=>ListWordScreen())
    );
    return Future.value(false);
  }
}
