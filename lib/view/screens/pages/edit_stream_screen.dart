import 'package:flutter/material.dart';
import 'package:myownflashcardver2/data/edit_status.dart';
import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/viewmodels/edit_word_viewmodel.dart';
import 'package:provider/provider.dart';

import 'list_word_screen.dart';

class EditStreamScreen extends StatelessWidget {

  final EditStatus status;
  final Word word;
  EditStreamScreen({@required this.status,this.word});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:
//          Text(_titleText),
          Consumer<EditWordViewModel>(
              builder: (context,model,child){
                return model.titleText;
              }),

          actions: <Widget>[
            IconButton(
              tooltip: "登録",
              icon: Icon(Icons.check),
              onPressed: ()=>(context,status){},
            ),
          ],
        ),
        body: _LoginPageBody(),
      ),
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

    var viewModel = Provider.of<EditWordViewModel>(context, listen: false);
//    viewModel.dispose();
    viewModel.loginSuccessAction.stream.listen((addData) {
      print(addData);
      //リッスンされた履歴をクリアしないと何度もNavigator.pushReplacement呼び出される
      //とりあえずNavigator.pop
      Navigator.pop(context);

    });

  }
  @override
  Widget build(BuildContext context) {
    return Consumer<EditWordViewModel>(
      builder: (context, viewModel, _) {
        return Center(
          child: RaisedButton(
            child: Text("streamテスト"),
            onPressed: _onPressed(viewModel),
          ),
        );
      },
    );
  }

  _onPressed(EditWordViewModel viewModel) {
    if(viewModel.isLogging){
      return null;
    }else{
      return(){
//        viewModel.login();
     print("viewModel.login()してた");
      };
    }

  }
}


