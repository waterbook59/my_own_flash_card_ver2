import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/memorized_status.dart';
import 'package:myownflashcardver2/data/test_status.dart';
import 'package:myownflashcardver2/view/components/answer_image.dart';
import 'package:myownflashcardver2/view/components/fab.dart';
import 'package:myownflashcardver2/view/components/memorized_check.dart';
import 'package:myownflashcardver2/view/components/question_image.dart';
import 'package:myownflashcardver2/viewmodels/check_test_viewmodel.dart';
import 'package:provider/provider.dart';

class CheckTestScreen extends StatelessWidget {

  final Memorized testType;

  CheckTestScreen({this.testType});

  @override
  Widget build(BuildContext context) {

    //TODO 受け取ったtestTypeによって取得するデータをviewModel内の条件で変える、問題数ゼロで入った時エラー
    final viewModel = Provider.of<CheckTestViewModel>(context,listen: false);
    Future(()=>viewModel.getWordList(testType));
    //listen:trueにするとデータ取得し続けてしまう
//    final viewModel = Provider.of<CheckTestViewModel>(context);
//    Future((){
//      viewModel.isQuestionPart;
//      viewModel.isAnswerPart;
//      viewModel.isMemorizedCheck;
//      viewModel.isFabVisible;
//      viewModel.isEndMessageVisible;
//      viewModel.index;
//    });


    return WillPopScope(
      onWillPop:()=>_finishTestScreen(context) ,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("かくにんテスト"),
        ),
        body: Stack(
          children: <Widget>[
            Column(children: <Widget>[
              const SizedBox(height: 30.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:8.0),
                child: Table(
                    border:  TableBorder.all(color: Colors.white),
                    children: [
                      TableRow(
                        children: [
                          const Center(child: Text("残り問題数", style: TextStyle(fontSize: 20.0),)),
                          Consumer<CheckTestViewModel>(
                            builder: (context,model,child){
                              return Center(child: Text(model.remainedQuestion.toString(), style: TextStyle(fontSize: 20.0),));
                            },
                          ),
                        ],
                      ),
                    ]
                ),
              ),
              const SizedBox(height: 25.0,),
              // Containerの代わりにTextで空の箱を作る
              Consumer<CheckTestViewModel>(
                builder: (context,model,child){
                  return model.isQuestionPart
                      ? QuestionImage(questionWord: model.words[model.index].strQuestion.toString(),)
                      : const Text("");
                },
              ),
              const SizedBox(height: 30.0,),
              // Containerの代わりにTextで空の箱を作る
              Consumer<CheckTestViewModel>(
                builder: (context,model,child){
                  return model.isAnswerPart
                      ? AnswerImage(answerWord: model.words[model.index].strAnswer.toString(),)
                      : const Text("");
                },
              ),
              const SizedBox(height: 25.0,),
              Consumer<CheckTestViewModel>(
                builder: (context,model,child){
                  return model.isMemorizedCheck
                      ? MemorizedCheck(
                        isMemorized: model.isMemorized,
                        checkButton: (value) =>clickCheckButton(value,context),
                        )
                      : const Text("");
                },
              ),
            ],),
            Consumer<CheckTestViewModel>(
              builder: (context,model,child){
                return model.isEndMessageVisible
                    ? Center(child: Text("テスト終了",style: TextStyle(fontSize: 50.0),))
                    : const Text("");
              },
            ),
          ],
        ),
        floatingActionButton:
          Consumer<CheckTestViewModel>(
             builder: (context,model,child){
                return model.isFabVisible
                    ? Fab(goNextState: ()=>changTestState(context,model.testStatus),)
                    : const Text("");//nullじゃなくてText
             },
          ),
      ),
    );
  }

  Future<void> changTestState(BuildContext context,TestStatus testState) async{
    print("ここに条件:$context");
    final viewModel = Provider.of<CheckTestViewModel>(context,listen: false);
    await viewModel.changeTestStatus(testState);

  }

// finishTestScreenはそのまま
  Future<bool> _finishTestScreen(BuildContext context) async{

    //1. onWillPopの戻り値はFuture<bool>なのでメソッドの頭にFuture<bool>,returnでshowDialogで返す
    //2. showDialogの戻り値はFutureなので非同期処理でasync/awaitにする
    //3. Navigator.pop×2だと、showDialogは戻り値としてboolが返ってこないので、nullを避けるため、
    //4. showDialog()??false;で三項条件演算子でfalseにして元々AppBarのでデフォルトで設定されているNavigator.popを避ける

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

  //isMemorizedの値がvalueに入ってくるので、checkTestViewModel内で_isMemorized=valueへ変更する
  //Futureじゃなくていいかも
 Future<void> clickCheckButton(bool value,BuildContext context) async{
   final viewModel = Provider.of<CheckTestViewModel>(context,listen: false);
   viewModel.clickCheckButton(value);
 }



}
