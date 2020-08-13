//word_list_screenをMVVMへリファクタリング

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myownflashcardver2/data/edit_status.dart';
import 'package:myownflashcardver2/data/event.dart';
import 'package:myownflashcardver2/view/components/word_item.dart';
import 'package:myownflashcardver2/view/di_screens/di_add_edit_screen.dart';
import 'package:myownflashcardver2/viewmodels/di_viewmodels/di_list_word_viewmodel.dart';
import 'package:provider/provider.dart';

class DiListWordScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //Builder削除・ リストがゼロの時エラー発生=>isEmptyで回避
        final viewModel = Provider.of<DiListWordViewModel>(context, listen: false);
        Future(() {
          viewModel.getWordList();
          //todo isEmptyの時に「文字登録してください」的な表示できるか
//           Future内でstream.listenしたり、Fluttertoastせずにボタン押すところでイベント受けてFluttertoastする
        });

      return SafeArea( //todo SafeAreaはScaffoldの下じゃないとダメみたい??
        child: Scaffold(
          appBar: AppBar(
            title: Text("単語一覧(リファクタリングver)"),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.sort),
                    tooltip: "暗記済が下になるよう並び替え",
                    onPressed: () => checkSort(context),
                  ),
                  IconButton(
                    icon: Icon(Icons.timer),
                    tooltip: "登録日時で並び替え",
                    onPressed: () => dateSort(context),
                  ),
                ],
              )
            ],
          ),
          body: DiListWordScreenBody(),

          floatingActionButton: FloatingActionButton(
            //何か表示したい時は,childにwidgetでIcon widget入れる
            child: Icon(Icons.add),
            tooltip: "新しい単語を登録する",
            onPressed: () => _startEditScreen(context),
          ),
        ),
      );
  }

  Future<void> checkSort(BuildContext context) async{
    final viewModel = Provider.of<DiListWordViewModel>(context,listen: false);
    await viewModel.allWordsSorted();
  }

  Future<void> dateSort(BuildContext context) async{
    final viewModel = Provider.of<DiListWordViewModel>(context,listen: false);
    await viewModel.timeSorted();
  }


  _startEditScreen(BuildContext context) {
    //分岐した後の表示は遷移先で実装
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => DiAddEditScreen(
            status: EditStatus.add,
          )
      ),
    );
  }
}

class DiListWordScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(15.0),
      child: Consumer<DiListWordViewModel>(
          builder: (context,model,child){
            return ListView.builder(
                itemCount: model.words.length,
                itemBuilder: (context, int position) =>
                    WordItem(
                      word:model.words[position],
                      onLongTapped: (word)=>_onWordDeleted(word,context),
                      onWordTapped: (word)=>_upDateWord(word,context),
                    )
            );
          }
      ),
    );
  }

  Future<void> _onWordDeleted(word, BuildContext context) async {
    final viewModel = Provider.of<DiListWordViewModel>(context,listen: false);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text("『${word.strQuestion}』の削除"),
          content:const Text("削除してもいいですか？"),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                await viewModel.onDeletedWord(word);//イベントEvent.delete返ってくる
                if(viewModel.eventStatus == Event.delete){
                  Fluttertoast.showToast(msg:"削除完了しました");
                }
                // ここで最後の１つを削除後取得しようとするとList内が空っぽでエラーが出るがisEmptyで回避
                await viewModel.getWordList();
                Navigator.pop(context);
              },
              child: Text("はい"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("いいえ"),
            ),
          ],
        ));
  }

  _upDateWord( updateWord, BuildContext context) {
    //分岐した後の表示は遷移先で実装
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => DiAddEditScreen(
            status: EditStatus.edit,
            word: updateWord,
          )
      ),
    );
  }
}
