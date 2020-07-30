import 'package:flutter/material.dart';
import 'package:myownflashcardver2/view/screens/pages/home_page.dart';
import 'package:myownflashcardver2/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    print("LoginPageのbuild内:$context");
    return
        MultiProvider(
      providers: [
        // Injects LoginViewModel into this widgets.
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ],
      child:
      Scaffold(
        appBar: AppBar(title:const Text("Login")),
        body: _LoginPageBody(),
      )
      );
  }
}



class _LoginPageBody extends StatefulWidget {
  @override
  __LoginPageBodyState createState() => __LoginPageBodyState();
}

class __LoginPageBodyState extends State<_LoginPageBody> {

  @override
  void initState() {
    super.initState();
//    print("__LoginPageBodyStateのinitStateの中：$context");

    // Listen events by view model.
    //はじめにページ開いたときにはここは読まれない
    //2回目以降ボタンを押すとstreamが1回ずつ読まれる数が増える＆contextに__LoginPageBodyStateが渡らずnullになる
    var viewModel = Provider.of<LoginViewModel>(context, listen: false);
    viewModel.loginSuccessAction.stream.listen((st) {
      //ChangeNotifierProviderのLoginViewModelをrunAppの所に置いてしまうと、2回目以降ここがcontextがnullになってlistenされたものが追加されてく
//      print("__LoginPageBodyStateのinitStateでProviderのcontext:$context");
      print(st);
      Toast.show("更新完了！", context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context)=>HomePage())
      );
//      print("pushReplacementの後:${viewModel.uiState}");
    });
  }//initState終わり

  //disposeでstreamを削除とか関係なさそう・・・
//  @override
//  void dispose() {
//    var viewModel = Provider.of<LoginViewModel>(context, listen: false);
//    viewModel.dispose();
//    super.dispose();
//  }




  @override
  Widget build(BuildContext context) {

//    print("__LoginPageBodyStateのbuild内:$context");

    return Center(
      child: _LoginButton(),
    );
  }
}

class _LoginButton extends StatelessWidget {

  //押してデータ取得中は表示を変える方法
//  String _getButtonText(LoginViewModel vm) => vm.isLogging ? "Wait..." : "Login";

  VoidCallback _onPressed(LoginViewModel vm,context) {
    if (vm.isLogging) {
      // When returning null, the button become disabled.
      return null;
    } else {
      return () {
//        print("Consumer下のLoginボタンonPressed押したとき:$context");
        vm.login(context);
      };
    }
  }

  @override
  Widget build(BuildContext context) {
//    print(" _LoginButtonのbuild内:$context");
    return
      Consumer<LoginViewModel>(builder: (context, viewModel, _) {
        return RaisedButton(
          color: Colors.deepOrange,
          child: const Text("Login"),
          onPressed: _onPressed(viewModel,context),

        );
      },
    );
  }
}//_LoginButtonクラスここまで
