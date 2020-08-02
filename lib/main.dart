import 'package:flutter/material.dart';
import 'package:myownflashcardver2/di/providers.dart';
import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/view/screens/screen_home.dart';
import 'package:myownflashcardver2/viewmodels/home_screen_viewmodel.dart';
import 'package:myownflashcardver2/viewmodels/list_word_viewmodel.dart';
import 'package:myownflashcardver2/viewmodels/check_test_viewmodel.dart';
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
      providers:
//      globalProviders,

      [
        ChangeNotifierProvider(
          create: (context)=>HomeScreenViewModel(),
        ),
        //findAncestorStateOfTypeエラーをなくすため直下に設置
//        ChangeNotifierProvider(
//          create: (context)=>ListWordViewModel(),
//        ),
        ChangeNotifierProvider(
          create: (context)=>CheckTestViewModel(),
        ),
          //HomeScreenViewModelを上に持って行ってみる
//        ChangeNotifierProvider(
//          create: (context)=>HomeScreenViewModel(),
//        ),
//ここにあったLoginViewModelは移動
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
      //MVVMとしてHomeScreen()からScreenHome()へ変更
      home: ScreenHome(),
    );
  }
}
