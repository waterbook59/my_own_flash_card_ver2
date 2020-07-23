//word_list_screenをMVVMへリファクタリング

import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/edit_status.dart';
import 'package:myownflashcardver2/view/components/memorized_checked_icon.dart';
import 'package:myownflashcardver2/view/components/word_item.dart';
import 'package:myownflashcardver2/view/screens/pages/edit_stream_screen.dart';
import 'package:myownflashcardver2/view/screens/pages/login_page.dart';
import 'package:myownflashcardver2/viewmodels/list_word_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'add_edit_screen.dart';

class ListWordScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //initState的にデータベースからWordのリストを取ってくる(buildするわけではないので、listen:false)
    final viewModel = Provider.of<ListWordViewModel>(context,listen: false);
      Future(()=>viewModel.getWordList());

      return SafeArea(
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
          body:ListWordScreenBody(),

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
  @override
  _ListWordScreenBodyState createState() => _ListWordScreenBodyState();
}
class _ListWordScreenBodyState extends State<ListWordScreenBody> {

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<ListWordViewModel>(context, listen: false);
    viewModel.deleteAction.stream.listen((event) {
      //TODO AlertDialog挿入
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

  Future<void> _onWordDeleted(word, BuildContext context) async {
    final viewModel = Provider.of<ListWordViewModel>(context,listen: false);
    await viewModel.onDeletedWord(word);
    await viewModel.getWordList();
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