//モデルクラス(エンティティ？)

class Word{
  final String strQuestion;
  final String strAnswer;
  //たぶんStringじゃない,とりあえず型指定なしでいけそう？？
  final strTime;
  final bool isMemorized;
  Word({this.strQuestion,this.strAnswer,this.strTime,this.isMemorized});
}