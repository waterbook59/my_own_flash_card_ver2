import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/edit_status.dart';
import 'package:myownflashcardver2/data/event.dart';
//import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/model/words_model.dart';
import 'package:myownflashcardver2/view/components/word_text_input.dart';
import 'package:myownflashcardver2/viewmodels/edit_word_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'di_list_word_screen.dart';
import 'list_word_screen.dart';

class AddEditScreen extends StatelessWidget {
  final EditStatus status;
  final Word word;

  AddEditScreen({@required this.status,this.word});

  @override
  Widget build(BuildContext context) {
//    String _titleText="試しのタイトル(statusで分ける)";
    return
      MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context)=>EditWordViewModel(),),
          ],
          //ChangeNotifierProviderを上に置きつつ、開いたときにgetTitleTextするためにBuilder設定
          //model.getTitleTextよりも上にChangeNotifierProvider置かないと使えないよ
          child:Builder(builder: (context){
            //画面遷移したときinitState的にstatusの違いでText(新しい単語の追加 or 登録した単語の修正)というインスタンスをモデルの方で作っておく
            final model = Provider.of<EditWordViewModel>(context,listen: false);
            Future((){
              model.getTitleText(status,word);
              model.loginSuccessAction.stream.listen((event) {
              print("view層で受けた$event");
              switch(event){
                case Event.empty:
                  Toast.show("問題と答えを入力してください。",context,duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                  break;
                case Event.add:
                  Toast.show("「${model.questionController.text}」登録完了",context,duration: Toast.LENGTH_LONG);
                  model.textClear();
                  break;
                case Event.adderror:
                  Toast.show("この問題はすでに登録されているので登録できません", context,duration: Toast.LENGTH_LONG);
                  break;
                case Event.update:
                  Toast.show("「${model.questionController.text}」更新しました", context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context)=>ListWordScreen()));
                  break;
                  //deleteは入ってこないけど下のdescriptionに出るので追加
                case Event.delete:
                  break;
                }
              });
            });




              return
                WillPopScope(//戻るときに単にpopではなく、pushReplace
                   onWillPop: ()=> _backToListScreen(context),
                   child: Scaffold(
                     appBar: AppBar(
                       title:
                       Consumer<EditWordViewModel>(builder: (context,model,child){
                         return model.titleText;
                       }),
                       actions: <Widget>[
                         IconButton(
                           tooltip: "登録",
                           icon: Icon(Icons.check),
                           onPressed: ()=>_onWordRegistered(context,status),),
                       ],
                     ),
                     body:AddEditBody(),
      ),
    );
          },)
      );
  }

//   単語登録をview=>EditWordViewModel=>レポジトリ経由で外注
  Future<void>  _onWordRegistered(BuildContext context, EditStatus status) async{
    final viewModel = Provider.of<EditWordViewModel>(context,listen: false);
//    print(viewModel.questionController.text);
//    print(viewModel.answerController.text);
    //awaitの追加！！！
    await viewModel.onRegisteredWord(status);
      }
    }

    //statusの分岐をここで行うがinsertWord,updateWordというメソッドには切り分けず、部分的に必要なところをviewModelへ外注してみる
    /*
    if(status == EditStatus.add) {
      await viewModel.insertWord();
      return;
    }
    if(status == EditStatus.edit){
      await viewModel.modifiedWord();
      return;
    }
    */

//単語一覧画面へ戻る関数がAddEditScreenクラスの外
  Future<bool> _backToListScreen(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=>ListWordScreen())
    );
    return Future.value(false);
  }



//イベント通知するのにbodyだけStatefulに
//class AddEditBody extends StatefulWidget {
//  @override
//  _AddEditBodyState createState() => _AddEditBodyState();
//}
//class _AddEditBodyState extends State<AddEditBody> {
//
//  @override
//  void initState() {
//    super.initState();
//    final viewModel = Provider.of<EditWordViewModel>(context, listen: false);
//    viewModel.loginSuccessAction.stream.listen((event) {
//      print("view層で受けた$event");
//      switch(event){
//        case Event.empty:
//          Toast.show("問題と答えを入力してください。",context,duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
//          break;
//        case Event.add:
//          Toast.show("「${viewModel.questionController.text}」登録完了",context,duration: Toast.LENGTH_LONG);
//          viewModel.textClear();
////          Navigator.pushReplacement(
////              context,
////              MaterialPageRoute(builder: (context)=>ListWordScreen()));
//          break;
//        case Event.adderror:
//          Toast.show("この問題はすでに登録されているので登録できません", context,duration: Toast.LENGTH_LONG);
//          break;
//        case Event.update:
//          Toast.show("「${viewModel.questionController.text}」更新しました", context);
//          Navigator.pushReplacement(
//              context,
//              MaterialPageRoute(builder: (context)=>ListWordScreen()));
//          break;
//          //deleteは入ってこないけど下のdescriptionに出るので追加
//        case Event.delete:
//          break;
//        }
//      });
//    }
//
//  @override
//  Widget build(BuildContext context) {
//    return SingleChildScrollView(
//      child: Column(
//        children: <Widget>[
//          const SizedBox(height: 20.0,),
//          const Text("問題と答えを入力して「登録」ボタンを押してください"),
//          const SizedBox(height: 40.0,),
//          Consumer<EditWordViewModel>(
//              builder: (context,model,child){
//                return WordTextInput(
//                  label: "問題",
//                  textEditingController: model.questionController,
//                  isQuestionEnabled: model.isQuestionEnabled,);
//              }),
//          const SizedBox(height: 30.0,),
//          Consumer<EditWordViewModel>(
//              builder: (context,model,child){
//                return WordTextInput(
//                    label: "答え",
//                    textEditingController: model.answerController);
//                // isQuestionEnabled: model.isQuestionEnabled,);
//              }),
//          const SizedBox(height: 30.0,),
//
////              WordTextInput(label: "答え",textEditingController: _answerController),
//        ],
//      ),
//    );
//  }
//}

//bodyもStatelessに
class AddEditBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          const SizedBox(height: 30.0,),

//              WordTextInput(label: "答え",textEditingController: _answerController),
        ],
      ),
    );
  }
}
