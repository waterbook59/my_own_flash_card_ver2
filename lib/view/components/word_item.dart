import 'package:flutter/material.dart';
//ほんとは参照しない方がいい？
import 'package:myownflashcardver2/models/db/database.dart';

class WordItem extends StatelessWidget {
  final Word word;
  final ValueChanged onWordTaped;
//words[position]をwordに置き換え
  const WordItem({this.word, this.onWordTaped});

  @override
  Widget build(BuildContext context) {
    return    Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: Colors.cyan,
      child: ListTile(
        title: Text("${word.strQuestion}", style: TextStyle(color: Colors.black87,fontSize: 23.0),),
        subtitle: Text("答え：${word.strAnswer}・登録日時：${word.strTime}",
          style: TextStyle(fontFamily: "Corporate", color: Colors.brown),
        ),
//        trailing: _memorizedCheckIcon(position),
//        onLongPress: () => _deleteWord(_wordList[position]),
        onTap: () => onWordTaped(word),
      ),
    );
  }
}
