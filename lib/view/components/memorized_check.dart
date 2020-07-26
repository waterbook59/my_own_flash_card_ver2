import 'package:flutter/material.dart';

class MemorizedCheck extends StatelessWidget {
  final bool isMemorized ;
  final ValueChanged checkButton;
  MemorizedCheck({this.isMemorized,this.checkButton});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text("暗記済にする単語にはチェックを入れてください"),
      secondary:const Icon(Icons.beach_access),
      controlAffinity: ListTileControlAffinity.trailing,
      // 暗記済フラグをDBへ登録
      value: isMemorized,
      onChanged: (value)=>checkButton(value),
//      {
//          isMemorized =value;
//      },
    );
  }
}

