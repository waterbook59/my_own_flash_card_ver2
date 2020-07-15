//homeScreenでConsumer使うならStatelessでhomeScreen書いてみる

import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/memorized_status.dart';
import 'package:myownflashcardver2/view/components/button_with_icon.dart';
import 'package:myownflashcardver2/view/components/radio_buttons.dart';
import 'package:myownflashcardver2/view/screens/pages/list_word_screen.dart';
import 'package:myownflashcardver2/view/screens_before/test_screen.dart';
import 'package:myownflashcardver2/view/screens_before/word_list_screen.dart';
import 'package:myownflashcardver2/viewmodels/home_screen_viewmodel.dart';
import 'package:provider/provider.dart';

class ScreenHome extends StatelessWidget {

  //とりあえずページ遷移のところはincludedで
 final Memorized testType = Memorized.includedWords;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ScaffoldのbodyでSafeAreaを持ってくる
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(child: Image.asset("assets/images/image_title.png")),
            const Text("私だけの単語帳", style: TextStyle(fontSize: 40.0,)),
            const Text("My Own Flashcard", style: TextStyle(fontSize: 15.0, fontFamily: "Regular"),),
            const Divider(
              color: Colors.white,
              height: 30.0,
              indent: 8.0,
              endIndent: 8.0,
            ),
            ButtonWithIcon(
              // かくにんテストボタン onPressed
              onPressed: () => _testStart(context),
              label: "かくにんテスト",
              icon: Icon(Icons.accessibility),
              color: Colors.purpleAccent,
            ),
            const SizedBox(height: 10.0,),
            //ここだけConsumerでRadioButtons変更もあるが、homeScreenをstatefulウィジェットにしているのでこのままでも
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child:Consumer<HomeScreenViewModel>(
                builder: (context,model,child){
                  return RadioButtons(
                    wordTestType: model.testRadioType,
                    onRadioSelected:(value){
                      //ここのvalueにはradio_selected_typeからきたtestTypeValueが入る
                      print("ScreenHomeでのvalue:$value");
                      //modelのメソッドは直接参照
                      model.selected(value);
                      //このクラス内にメソッド設定してmodelのメソッドへ参照
//                    changeRadioButton(value,context);
                    });
                }
              )
            ),
//           ); _radioButtons(),
            //_switch(),
            const SizedBox(height: 25.0,),
            ButtonWithIcon(
              // 一覧画面ボタン onPressed
              onPressed: () => _confirmWordList(context),
              label: "登録単語一覧をみる",
              icon: Icon(Icons.list),
              color: Colors.indigo,
            ),
            const SizedBox(height: 15.0,),
            ButtonWithIcon(
              onPressed: () => _lookListTest(context),
              label: "リファクタリングボタン",
              icon: Icon(Icons.account_balance_wallet),
              color: Colors.amber,
            ),
            const SizedBox(height: 20.0,),
            const Text("powered by Ikuto/Tatsuki 2020"),
            const SizedBox(height: 20.0,),
          ],
        ),
      ),
    );
  }




  _testStart(BuildContext context) {
    final viewModel= Provider.of<HomeScreenViewModel>(context,listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TestScreen(testType: viewModel.testRadioType,)),
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

   changeRadioButton(Memorized value,BuildContext context) {

    final viewModel= Provider.of<HomeScreenViewModel>(context,listen: false);
    viewModel.selected(value);

  }

// Future<void> checkSort(,BuildContext context) async{
//   final viewModel = Provider.of<ListWordViewModel>(context,listen: false);
//   await viewModel.allWordsSorted();
// }




}
