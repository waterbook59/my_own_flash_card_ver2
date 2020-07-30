import 'package:flutter/material.dart';
//db参照してはいけない
//import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/model/words_model.dart';
import 'memorized_checked_icon.dart';

class WordItem extends StatelessWidget {
  final Word word;
  final ValueChanged onLongTapped;
  final ValueChanged onWordTapped;

//  final MemorizedCheckedIcon memorizedCheckedIcon;
//  final bool isMemorizedCheckIcon;

//words[position]をwordに置き換え
  const WordItem({this.word,this.onLongTapped, this.onWordTapped});

  @override
  Widget build(BuildContext context) {
//    print("isMemorizedCheckIconは$memorizedCheckedIcon");
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: Colors.cyan,
      child: ListTile(
        title: Text("${word.strQuestion}", style: TextStyle(color: Colors.black87,fontSize: 23.0),),
        subtitle: Text("答え：${word.strAnswer}・登録日時：${word.strTime}",
          style: TextStyle(fontFamily: "Corporate", color: Colors.brown),
        ),
        /*
        MemorizedCheckedIcon内でif条件つけなければちゃんと返ってくるので、trailing：で条件分岐すべき
        widget分割するときには、分割先でそのwidgetを返す・返さないはやったらダメ
         */
        //widget分割するときには、そのwidgetを返す・返さないは分割先でやったらダメ
        trailing: word.isMemorized ? MemorizedCheckedIcon(isCheckedIcon: word.isMemorized,):null,
        // trailing: _memorizedCheckIcon(word.isMemorized),
        onLongPress: () => onLongTapped(word),
//            _deleteWord(_wordList[position]),
        onTap: () => onWordTapped(word),
      ),
    );
  }
}

//widget分割しないver
//Widget _memorizedCheckIcon(isMemorizedCheckIcon) {
//  if (isMemorizedCheckIcon) {
//    return Icon(Icons.check_circle);
//  } else {
//    return null;
//  }
//}