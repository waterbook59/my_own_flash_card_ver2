import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/memorized_status.dart';
import 'package:myownflashcardver2/view/components/fab.dart';
import 'package:myownflashcardver2/view/components/question_image.dart';
import 'package:myownflashcardver2/viewmodels/check_test_viewmodel.dart';
import 'package:provider/provider.dart';

class CheckTestScreen extends StatelessWidget {

  final Memorized testType;
  final bool  isFabVisible =true;
  final bool isQuestionPart =false;

  CheckTestScreen({this.testType});

  @override
  Widget build(BuildContext context) {

    //TODO 受け取ったtestTypeによって取得するデータをviewModel内の条件で変える
    final viewModel = Provider.of<CheckTestViewModel>(context,listen: false);
    Future(()=>viewModel.getWordList(testType));


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
              //TODO QuestionImageへ渡す文字とContainerの代わりにExpandで空の箱を作る
//              Consumer<CheckTestViewModel>(
//                builder: (context,model,child){
//                  return isQuestionPart?QuestionImage(model.words[index].strQuetison.toString()):Container();
//                },
//              ),

              const SizedBox(height: 30.0,),
              //TODO AnswerImageへ渡す文字とContainerの代わりにExpandで空の箱を作る
         //     _answerImage(),
              const SizedBox(height: 25.0,),
              //TODO MemorizedCheck作る
             // _memorizedCheck(),
            ],),
            //TODO endMessage作る
            //_endMessage(),
          ],
        ),
        floatingActionButton: isFabVisible ? Fab(goNextState: ()=>changeState(),) : null,
      ),
    );
  }

  changeState() {
    print("ここに条件");
  }

//TODO FinihTestScreen仕上げる
  Future<bool> _finishTestScreen(BuildContext context) async{

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
