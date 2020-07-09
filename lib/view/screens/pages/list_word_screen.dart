import 'package:flutter/material.dart';
import 'package:myownflashcardver2/view/components/word_item.dart';
import 'package:myownflashcardver2/viewmodels/list_word_viewmodel.dart';

import 'package:provider/provider.dart';

import '../edit_screen.dart';

class ListWordScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final viewModel = Provider.of<ListWordViewModel>(context,listen: false);
      Future(()=>viewModel.getWordList());

      return Scaffold(
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
                _timeSortButton(context),
              ],
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<ListWordViewModel>(
              builder: (context,model,child){
                 return ListView.builder(
                   itemCount: model.words.length,
                   itemBuilder: (context, int position) =>
//                       _wordItem( position)
                     WordItem(
                       word:model.words[position],
                       onWordTaped: (word)=>_upDateWord(word,context),)
                 );
              }
        ),
        ),
         floatingActionButton: FloatingActionButton(
          //何か表示したい時は,childにwidgetでIcon widget入れる
          child: Icon(Icons.add),
          tooltip: "新しい単語を登録する",
          onPressed: () => _startEditScreen(context),
        ),
      );


//      Column(
//      children: [
//        Text("getAllWords!"),
//        RaisedButton(
//          child: Text("テスト"),
//          onPressed: ()=>{
//            print("${viewModel.getWordList()}")
//          },
//        )
//      ]
//    );
  }

//  Widget _wordListWidget() {
//    return ListView.builder(
//        itemCount: model.words.length,//長さをどう取ってくるか・・・
//
//        itemBuilder: (context, int position) => _wordItem( position));
//  }

//  Widget _wordItem(int position) {
//    return Card(
//      elevation: 5.0,
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//      color: Colors.indigo,
//      child: ListTile(
//        title: Text("${words[position].strQuestion}"),
//        subtitle: Text(
//          "答え：${_words[position].strAnswer}・登録日時：${_words[position].strTime}",
//          style: TextStyle(fontFamily: "Corporate"),
//        ),
//        trailing: _memorizedCheckIcon(position),
//        onLongPress: () => _deleteWord(_wordList[position]),
//        onTap: () => _updateWord(_wordList[position]),
//      ),
//    );
//  }


  Widget _timeSortButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.timer),
      tooltip: "登録日時で並び替え",
      onPressed: () => dateSort(context),
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

  _upDateWord( updateWord, BuildContext context) {

    //分岐した後の表示は遷移先で実装
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => EditScreen(
            status: EditStatus.edit,
            word: updateWord,
          )),
    );
  }

  _startEditScreen(BuildContext context) {
    //分岐した後の表示は遷移先で実装
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => EditScreen(
            status: EditStatus.add,
          )),
    );
  }
}
