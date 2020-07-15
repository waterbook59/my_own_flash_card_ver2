import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/edit_status.dart';
import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/view/components/word_text_input.dart';
import 'package:myownflashcardver2/viewmodels/edit_word_viewmodel.dart';
import 'package:provider/provider.dart';


import 'list_word_screen.dart';


class AddEditScreen extends StatelessWidget {
  final EditStatus status;
  final Word word;

//  final String _appBarTitleText="パッパラー";
//  final TextEditingController _questionController=TextEditingController();
//  final TextEditingController _answerController=TextEditingController();

  AddEditScreen({@required this.status,this.word});


  @override
  Widget build(BuildContext context) {
//    String _titleText="試しのタイトル(statusで分ける予定)";

    //画面遷移したときinitState的にstatusの違いでText(新しい単語の追加 or 登録した単語の修正)というインスタンスをモデルの方で作っておく
    final model = Provider.of<EditWordViewModel>(context,listen: false);
    Future(()=>model.getTitleText(status,word));



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
              Consumer<EditWordViewModel>(
                  builder: (context,model,child){
                    return WordTextInput(
                      label: "問題",
                      textEditingController: model.questionController,
                      isQuestionEnabled: model.isQuestionEnabled,);
                  }),
              const SizedBox(height: 30.0,),
              Consumer<EditWordViewModel>(
                  builder: (context,model,child){
                    return WordTextInput(
                      label: "答え",
                      textEditingController: model.answerController);
                     // isQuestionEnabled: model.isQuestionEnabled,);
                  }),
//              WordTextInput(label: "答え",textEditingController: _answerController),
            ],
          ),
        ),
      ),
    );
  }

//  todo 単語登録をview=>EditWordViewModel=>レポジトリ経由で外注
  Future<void>  _onWordRegistered(BuildContext context) async{
    final viewModel = Provider.of<EditWordViewModel>(context,listen: false);
    print(viewModel.questionController.text);
    print(viewModel.answerController.text);
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
