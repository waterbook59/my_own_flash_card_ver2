import 'package:flutter/material.dart';

class MemorizedCheckedIcon extends StatelessWidget {
  final bool isCheckedIcon;


//エラーは一つのタイルにアイコンが全部詰まってしまっている？？
  MemorizedCheckedIcon({this.isCheckedIcon});

  @override
  Widget build(context) {
//    print("isCheckedIconの中身：$isCheckedIcon");
//    if(isCheckedIcon){
      return  Icon(Icons.check_circle);
//    }else{
//      return Container();
//    }

  }
}


//if条件つけなければちゃんと返ってくるので、trailing：で条件分岐すべき
//widget分割するときには、そのwidgetを返す・返さないは分割先でやったらダメ