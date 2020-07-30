//word_list_screenをMVVMへリファクタリング

import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/edit_status.dart';
import 'package:myownflashcardver2/view/components/word_item.dart';
import 'package:myownflashcardver2/viewmodels/list_word_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'add_edit_screen.dart';

class ListWordScreen extends StatelessWidget {

  //viewModelを直下に置いたらだめ？？=>contextがないでやんす
//  final viewModel = Provider.of<ListWordViewModel>(context,listen: false);

  @override
  Widget build(BuildContext context) {

    //initState的にデータベースからWordのリストを取ってくる(buildするわけではないので、listen:false)
    // リストがゼロの時エラー発生=>isEmptyで回避
//    final viewModel = Provider.of<ListWordViewModel>(context,listen: false);
//      Future(()=> viewModel.getWordList());
    return
    MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context)=>ListWordViewModel(),),
        ],
        //ChangeNotifierProviderを上に置きつつ、開いたときにgetTitleTextするためにBuilder設定
        //model.getTitleTextよりも上にChangeNotifierProvider置かないと使えないよ
        child:Builder(builder: (context){
          //initState的にデータベースからWordのリストを取ってくる(buildするわけではないので、listen:false)
          // リストがゼロの時エラー発生=>isEmptyで回避
          final viewModel = Provider.of<ListWordViewModel>(context,listen: false);
          Future(()=> viewModel.getWordList());
          return SafeArea(//todo SafeAreaはScaffoldの下じゃないとダメみたい
            child: Scaffold(
              appBar: AppBar(
                title: Text("単語一覧(リファクタリングver)"),
                actions: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.sort),
                        tooltip: "暗記済が下になるよう並び替え",
                        onPressed: () =>  checkSort(context),
                      ),
                      IconButton(
                        icon: Icon(Icons.timer),
                        tooltip: "登録日時で並び替え",
                        onPressed: () =>  dateSort(context),
                      ),
                    ],
                  )
                ],
              ),
              //todo viewModel渡してみたが、同様にエラー
//          body:ListWordScreenBody(viewModel: viewModel,),
              body:ListWordScreenBody(),

              floatingActionButton: FloatingActionButton(
                //何か表示したい時は,childにwidgetでIcon widget入れる
                child: Icon(Icons.add),
                tooltip: "新しい単語を登録する",
                onPressed: () => _startEditScreen(context),
              ),
            ),
          );
        },
        )
    );


//      return SafeArea(//todo SafeAreaはScaffoldの下じゃないとダメみたい
//        child: Scaffold(
//          appBar: AppBar(
//            title: Text("単語一覧(リファクタリングver)"),
//            actions: <Widget>[
//              Row(
//                children: <Widget>[
//                  IconButton(
//                    icon: Icon(Icons.sort),
//                    tooltip: "暗記済が下になるよう並び替え",
//                    onPressed: () =>  checkSort(context),
//                  ),
//                  IconButton(
//                    icon: Icon(Icons.timer),
//                    tooltip: "登録日時で並び替え",
//                    onPressed: () =>  dateSort(context),
//                  ),
//                ],
//              )
//            ],
//          ),
//          //todo viewModel渡してみたが、同様にエラー
////          body:ListWordScreenBody(viewModel: viewModel,),
//          body:ListWordScreenBody(),
//
//           floatingActionButton: FloatingActionButton(
//            //何か表示したい時は,childにwidgetでIcon widget入れる
//            child: Icon(Icons.add),
//            tooltip: "新しい単語を登録する",
//            onPressed: () => _startEditScreen(context),
//          ),
//        ),
//      );

  }

  Future<void> checkSort(BuildContext context) async{
    final viewModel = Provider.of<ListWordViewModel>(context,listen: false);
    await viewModel.allWordsSorted();
  }

  Future<void> dateSort(BuildContext context) async{
    final viewModel = Provider.of<ListWordViewModel>(context,listen: false);
    await viewModel.timeSorted();
  }


  _startEditScreen(BuildContext context) {
    //分岐した後の表示は遷移先で実装
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditScreen(
            status: EditStatus.add,
          )
      ),
    );
  }
}

class ListWordScreenBody extends StatefulWidget {
  //ListWordScreenから共通のviewModelを使う検討はしたが、これもエラー
//  final viewModel;
//  ListWordScreenBody({this.viewModel});
  @override
  _ListWordScreenBodyState createState() => _ListWordScreenBodyState();
}
class _ListWordScreenBodyState extends State<ListWordScreenBody> {

  @override
  void initState() {
    super.initState();
    print("ListWordScreenBodyのState:$context");
    //ここでviewModel作らなくてよくない？=>stream使えないでしょ
    final viewModel = Provider.of<ListWordViewModel>(context, listen: false);
    viewModel.deleteAction.stream.listen((event) {
    Toast.show("削除完了しました", context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Consumer<ListWordViewModel>(
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
    final viewModel = Provider.of<ListWordViewModel>(context,listen: false);


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
          builder: (context) => AddEditScreen(
            status: EditStatus.edit,
            word: updateWord,
          )
      ),
    );
  }
}