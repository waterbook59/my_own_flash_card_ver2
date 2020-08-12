//word_list_screenをMVVMへリファクタリング

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myownflashcardver2/data/edit_status.dart';
import 'package:myownflashcardver2/data/event.dart';
import 'package:myownflashcardver2/view/components/word_item.dart';
import 'package:myownflashcardver2/view/screens/pages/di_add_edit_screen.dart';
import 'package:myownflashcardver2/viewmodels/di_list_word_viewmodel.dart';
//import 'package:myownflashcardver2/viewmodels/list_word_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';


class DiListWordScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //todo Builderを入れてviewModel呼び出してみる

    return
      Builder(builder: (context) {
        //initState的にデータベースからWordのリストを取ってくる(buildするわけではないので、listen:false)
        // リストがゼロの時エラー発生=>isEmptyで回避
        final viewModel = Provider.of<DiListWordViewModel>(context, listen: false);
        Future(() {
          viewModel.getWordList();
          // 普通にここのFuture内でstream.listenして通知すればbodyをStatefulにしたり、Providerをこのページ内に儲けたりしなくていいのでは？？
          //todo ancestor is unsafeエラーは更新時の編集画面から一覧画面への遷移が原因かも（登録・削除の方は画面遷移やめたらエラー消えた）
          if(viewModel.eventStatus == Event.delete){
            Fluttertoast.showToast(msg:"削除完了しました");
          }
        });

      return SafeArea( //todo SafeAreaはScaffoldの下じゃないとダメみたい
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
    });
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
//                         memorizedCheckedIcon:MemorizedCheckedIcon(isCheckedIcon: model.words[position].isMemorized),
                    )
            );
          }
      ),
    );
  }

  //TODO 連続削除時findAncestorStateOfTypeエラーが発生：Unhandled Exception: NoSuchMethodError: The method 'findAncestorStateOfType' was called on null.Receiver: null
  //ChangeNotifierProviderで削除ごとに余分に作られたwidgetにちゃんとStateのBuildContextが入ってこずエラー
  //add_edit_screenで同様に出たエラーの時は、main.dartにあったChangeNotifierProviderをAddEditScreenのbuild下に設定
  // =>viewModel.onDeletedWordの段階ではnotifyListenerしない＆
  // 最後の一つを削除しようとするとエラー：Unhandled Exception: RangeError (index): Invalid value: Valid value range is empty: 0=>isEmptyで回避
  Future<void> _onWordDeleted(word, BuildContext context) async {

    //todo もしかしてviewModel作りすぎが問題なのでは？？？=>widget.viewModelにしてみたがエラー
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
                await viewModel.onDeletedWord(word);
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
