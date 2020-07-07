import 'package:flutter/material.dart';
import 'package:myownflashcardver2/db/database.dart';
//import 'package:path/path.dart'; //これをimportしてたらcontext変になった
import 'package:toast/toast.dart';
import '../main.dart';
import 'edit_screen.dart';

class WordListScreen extends StatefulWidget {
  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  List<Word> _wordList = List();

  //wordListScreen開くときにdbからデータを全て取ってくる
  @override
  void initState() {
    _getAllWords();
    super.initState();
  }

  void _getAllWords() async {
    //ゲッターにアクセスは、インスタンス.getの後ろのfield名
    //戻り値がList型なので、返ってきたListを格納する変数を設定
    _wordList = await database.allWords;
    //async/await内でsetStateが必要。initState内でやっても分離されたものが反映されない
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("単語一覧"),
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.sort),
                tooltip: "暗記済が下になるよう並び替え",
                onPressed: () => _checkSort(),
              ),
              _timeSortButton(),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _wordListWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        //何か表示したい時は,childにwidgetでIcon widget入れる
        child: Icon(Icons.add),
        tooltip: "新しい単語を登録する",
        onPressed: () => _startEditScreen(),
      ),
    );
  }

  //編集画面から戻ってくる時に画面をデータ更新した状態で表示したいため、pushReplacementで
  // 一覧画面と編集画面を一度入れ替える
  _startEditScreen() {
    //分岐した後の表示は遷移先で実装
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => EditScreen(
                status: EditStatus.add,
              )),
    );
  }

  Widget _wordListWidget() {
    return ListView.builder(
        itemCount: _wordList.length,
        //itemBuilderの正体がcontextとindex(データの行番号)を引数に持った関数なので、設定
        //その行数に合致したものをListTileとするので、widgetを_wordItemとして切り出し
        //positionはListViewタイルの行番号且つデータベースの行番号
        //_wordItem[position]は特定の行番号をもつWordインスタンス
        itemBuilder: (context, int position) => _wordItem( position));
  }

  Widget _wordItem(int position) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: Colors.indigo,
      child: ListTile(
        title: Text("${_wordList[position].strQuestion}"),
        subtitle: Text(
          "答え：${_wordList[position].strAnswer}・登録日時：${_wordList[position].strTime}",
          style: TextStyle(fontFamily: "Corporate"),
        ),
        trailing: _memorizedCheckIcon(position),
        onLongPress: () => _deleteWord(_wordList[position]),
        onTap: () => _updateWord(_wordList[position]),
      ),
    );
  }

  Widget _memorizedCheckIcon(position) {
    if (_wordList[position].isMemorized) {
      return Icon(Icons.check_circle);
    } else {
      return null;
    }
  }

  _deleteWord( Word selectedWord) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
              title: Text("${selectedWord.strQuestion}の削除"),
              content: Text("削除してもいいですか？"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () async {
                    await database.deleteWord(selectedWord);
                    Toast.show("削除完了しました", context);
                    _getAllWords();
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

  _updateWord( Word updateWord) {
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

  _checkSort() async {
    //データベースからのデータが格納される_wordListを更新してbuildすれば表示がその順でitemBuilderで生成される
    _wordList = await database.allWordsSorted;
    setState(() {});
  }

  Widget _timeSortButton() {
    return IconButton(
      icon: Icon(Icons.timer),
      tooltip: "登録日時で並び替え",
      onPressed: () => dateSort(),
    );
  }

  dateSort() async {
    _wordList = await database.timeSorted;
    setState(() {});
  }
}
