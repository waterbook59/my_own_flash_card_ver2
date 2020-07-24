import 'package:flutter/material.dart';

class Fab extends StatelessWidget {
  final VoidCallback goNextState;

//  final VoidCallback _goNextState;


  //初期化リスト形式
//  Fab(goNextState):
//      _goNextState = goNextState;

  Fab({this.goNextState});


  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // FABのonPressed
      //右辺にも()必要 TODO メソッド参照のやり方かくにん
      onPressed: ()=> goNextState(),
      tooltip: "次へ",
      child: Icon(Icons.skip_next),
    );
  }
}


