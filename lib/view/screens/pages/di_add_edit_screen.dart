import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/edit_status.dart';
import 'package:myownflashcardver2/data/event.dart';
//import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/model/words_model.dart';
import 'package:myownflashcardver2/view/components/word_text_input.dart';
import 'package:myownflashcardver2/view/screens/screen_home.dart';
import 'package:myownflashcardver2/viewmodels/di_edit_word_viewmodel.dart';
import 'package:myownflashcardver2/viewmodels/edit_word_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'di_list_word_screen.dart';
import 'list_word_screen.dart';



class DiAddEditScreen extends StatelessWidget {
  final EditStatus status;
  final Word word;

  DiAddEditScreen({@required this.status,this.word});

  @override
  Widget build(BuildContext context) {


    return
      //todo Builderを入れてviewModel呼び出してみる

      Builder(builder: (context) {
        final model = Provider.of<DiEditWordViewModel>(context,listen: false);
        Future((){
          model.getTitleText(status,word);
          //todo Unhandled Exception: Looking up a deactivated widget's ancestor is unsafe.のエラー：画面遷移時のcontextのエラー
          model.loginSuccessAction.stream.listen((event) {
            print("view層で受けた$event");
            switch(event){
              case Event.empty:
                Toast.show("問題と答えを入力してください。",context,duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                break;
              case Event.add:
              //ancestor is unsafeエラーが出る前に追加したらエラー出ない、エラー出たあと追加するとEvent.addがいっぱい流れてくる
                Toast.show("「${model.questionController.text}」登録完了",context,duration: Toast.LENGTH_LONG);
                model.textClear();
//            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>DiListWordScreen()));
                break;
              case Event.adderror:
                Toast.show("この問題はすでに登録されているので登録できません", context,duration: Toast.LENGTH_LONG);
                break;
              case Event.update:
                Toast.show("「${model.questionController.text}」更新しました", context);
                //todo ancestor is unsafeエラーは画面遷移が原因かも（登録の方は画面遷移やめたらエラー消えた）
//            _backToListScreen(context);
//            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DiListWordScreen()));
                break;
            //deleteは入ってこないけど下のdescriptionに出るので追加
              case Event.delete:
                break;
            }
          });
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
//                ),
        ),
      );
      });
          }


//   単語登録をview=>DiEditWordViewModel=>レポジトリ経由で外注
  //todo 押すといきなりストップ！！(providersが怪しい)
  Future<void>  _onWordRegistered(BuildContext context, EditStatus status) async{
    final model = Provider.of<DiEditWordViewModel>(context,listen: false);
    //awaitの追加！！！
    await model.onRegisteredWord(status);

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

//              WordTextInput(label: "答え",textEditingController: _answerController),
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


//Future<bool> _backToListScreen(BuildContext context) {
//  Navigator.pushAndRemoveUntil(
//      context,
//      MaterialPageRoute(builder: (context)=>ScreenHome()),
//        (_)=>false);
//  return Future.value(false);
//}