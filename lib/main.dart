import 'package:flutter/material.dart';
import 'package:myownflashcardver2/db/database.dart';
import 'package:myownflashcardver2/screens/home_screen.dart';

//step8
//コード生成後のDBインスタンス取得
// main.dartでトップレベルプロパティに
MyDatabase database;
void main() {
  //runAppする前のところでインスタンス化
  database =MyDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "myOwnFlashCard",
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "Corporate",
      ),
      home: HomeScreen(),
    );
  }
}
