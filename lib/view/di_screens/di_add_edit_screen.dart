import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myownflashcardver2/data/edit_status.dart';
import 'package:myownflashcardver2/data/event.dart';
//import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/model/words_model.dart';
import 'package:myownflashcardver2/view/components/word_text_input.dart';
import 'package:myownflashcardver2/viewmodels/di_viewmodels/di_edit_word_viewmodel.dart';
import 'package:provider/provider.dart';
import 'di_list_word_screen.dart';



class DiAddEditScreen extends StatelessWidget {
  final EditStatus status;
  final Word word;

  DiAddEditScreen({@required this.status,this.word});

  @override
  Widget build(BuildContext context) {
    //Builder削除
        final model = Provider.of<DiEditWordViewModel>(context,listen: false);
        Future((){
          model.getTitleText(status,word);
          //ここでイベント通知を受けてtoast出すのも削除（ボタン押すロジックのところで実装）
          // model.eventStatusとしてモデル層からstreamではなくnotifylistenerで取ってきて、Fluttertoast.showToastで実行
          });

         return WillPopScope(//戻るときに単にpopではなく、pushReplace
                onWillPop: ()=> _backToListScreen(context),
                child:
            Scaffold(
               appBar: AppBar(
                 title:
                   Consumer<DiEditWordViewModel>(builder: (context, model, child) {
                   return model.titleText;
                }),
                 actions: <Widget>[
                   IconButton(
                      tooltip: "登録",
                      icon: Icon(Icons.check),
                      onPressed: () => _onWordRegistered(context, status),),
                  ],
                 ),
                body: DiAddEditBody(),
        ),
      );
          }


//   単語登録をview=>DiEditWordViewModel=>レポジトリ経由で外注
    _onWordRegistered(BuildContext context, EditStatus status) async{
    final model = Provider.of<DiEditWordViewModel>(context,listen: false);
    //awaitの追加！！！
    await model.onRegisteredWord(status); //eventがnotifyListenersで返ってくる
    switch(model.eventStatus){
      case Event.empty:
        Fluttertoast.showToast(msg:"問題と答えを入力してください。");
        break;
      case Event.add:
        Fluttertoast.showToast(msg:"「${model.questionController.text}」登録完了");
        model.textClear();
        break;
      case Event.adderror:
        Fluttertoast.showToast(msg:"この問題はすでに登録されているので登録できません");
        break;
      case Event.update:
        Fluttertoast.showToast(msg:"「${model.questionController.text}」更新しました");
              _backToListScreen(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DiListWordScreen()));
        break;
     //deleteは入ってこないけど下のdescriptionに出るので追加
      case Event.delete:
        break;
    }
  }
}

class DiAddEditBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20.0,),
          const Text("問題と答えを入力して「登録」ボタンを押してください"),
          const SizedBox(height: 40.0,),
          Consumer<DiEditWordViewModel>(
              builder: (context,model,child){
                return WordTextInput(
                  label: "問題",
                  textEditingController: model.questionController,
                  isQuestionEnabled: model.isQuestionEnabled,);
              }),
          const SizedBox(height: 30.0,),
          Consumer<DiEditWordViewModel>(
              builder: (context,model,child){
                return WordTextInput(
                    label: "答え",
                    textEditingController: model.answerController);
                // isQuestionEnabled: model.isQuestionEnabled,);
              }),
          const SizedBox(height: 30.0,),
        ],
      ),
    );
  }
}


//単語一覧画面へ戻る関数がAddEditScreenクラスの外
Future<bool> _backToListScreen(BuildContext context) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context)=>DiListWordScreen())
  );
  return Future.value(false);
}