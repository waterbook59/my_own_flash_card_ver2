import 'package:flutter/material.dart';
//import 'package:moor/moor.dart';
import 'package:myownflashcardver2/view/components/button_with_icon.dart';
import 'package:myownflashcardver2/view/screens/pages/list_word_screen.dart';

import 'test_screen.dart';
import 'word_list_screen.dart';

enum Memorized { includedWords, excludedWords }

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Memorized _testType = Memorized.includedWords;
  // Memorized.includedWordsをtrue,Memorized.excludedWordsをfalseに変換するには？？？
//  bool isIncludedMemorizedWords= boolean(Memorized.includedWords.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ScaffoldのbodyでSafeAreaを持ってくる
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(child: Image.asset("assets/images/image_title.png")),
            const Text("私だけの単語帳",
                style: TextStyle(
                  fontSize: 40.0,
                )),
            const Text(
              "My Own Flashcard",
              style: TextStyle(fontSize: 15.0, fontFamily: "Regular"),
            ),
            Divider(
              color: Colors.white,
              height: 30.0,
              indent: 8.0,
              endIndent: 8.0,
            ),
            //RaisedButtonをクラスで外に出さないならベタ書き
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 25.0),
//              child: SizedBox(
//                width: double.infinity,
//                child: RaisedButton.icon(
//                  icon: Icon(Icons.play_arrow),
//                  color: Colors.brown,
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(8.0)),
//                  label: Text(
//                    "かくにんテストをする",
//                    style: TextStyle(fontSize: 18.0),
//                  ),
//                  // 確認テストボタン onPressed
//                  onPressed: () => _testStart(),
//                ),
//              ),
//            ),
            ButtonWithIcon(
              // かくにんテストボタン onPressed
              onPressed: () => _testStart(),
              label: "かくにんテスト",
              icon: Icon(Icons.accessibility),
              color: Colors.purpleAccent,
            ),
            SizedBox(
              height: 10.0,
            ),
             _radioButtons(),
            //_switch(),
            SizedBox(
              height: 25.0,
            ),
            ButtonWithIcon(
              // 一覧画面ボタン onPressed
              onPressed: () => _confirmWordList(context),
              label: "登録単語一覧をみる",
              icon: Icon(Icons.list),
              color: Colors.indigo,
            ),
            SizedBox(
              height: 50.0,
            ),
            ButtonWithIcon(
              // 一覧画面ボタン onPressed
              onPressed: () => _lookListTest(context),
              label: "リファクタリングボタン",
              icon: Icon(Icons.list),
              color: Colors.amber,
            ),
            Text("powered by Ikuto/Tatsuki 2020"),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  _testStart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TestScreen(testType: _testType,)),
    );
  }

  _confirmWordList(BuildContext context) {//引数にcontextを入れずとも画面遷移できるが必要か
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WordListScreen()),
    );
  }

  //テスト用
  _lookListTest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListWordScreen()),
    );
  }


  Widget _radioButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: Column(children: <Widget>[
          RadioListTile(
            secondary: Icon(Icons.category),
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text("全ての単語"),
            value: Memorized.includedWords,
            groupValue: _testType,
            // ラジオボタン(暗記済除外)onChanged
            onChanged: (value) => _onRadioSelected(value),
          ),
          RadioListTile(
            secondary: Icon(Icons.thumb_up),
            controlAffinity: ListTileControlAffinity.trailing,
            title: Text("暗記済単語を除外"),
            value: Memorized.excludedWords,
            groupValue: _testType,
            // ラジオボタン(暗記済含む)onChanged
            onChanged: (value) => _onRadioSelected(value),
          ),
        ],
      ),
    );
  }

  _onRadioSelected(value) {
    //onChangedの引数にRadioListTile(value:xx)の値が入ってくる
    setState(() {
      _testType = value;
      print("testTypeは$value");
    });
  }




//  Widget _switch() {
//    return SwitchListTile(
//      title: Text("暗記済の単語を含む"),
//      value: _testType,
//      onChanged: (value){
//        setState(() {
//          _testType =value;
//        });
//      },
//      secondary: Icon(Icons.sort),
//    );
//  }


}
