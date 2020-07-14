import 'package:flutter/material.dart';
import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/view/screens/home_screen.dart';
import 'package:myownflashcardver2/view/screens/pages/list_word_screen.dart';
import 'package:myownflashcardver2/viewmodels/edit_word_viewmodel.dart';
import 'package:myownflashcardver2/viewmodels/list_word_viewmodel.dart';
import 'package:myownflashcardver2/viewmodels/test_word_viewmodel.dart';
import 'package:provider/provider.dart';

//step8
//コード生成後のDBインスタンス取得
// main.dartでトップレベルプロパティに
MyDatabase database;
void main() {
  //runAppする前のところでインスタンス化
  database =MyDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>ListWordViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context)=>TestWordViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context)=>EditWordViewModel(),
        ),
      ],
      child: MyApp(),
    )
  );
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
