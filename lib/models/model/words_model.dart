//モデルクラス(エンティティ？)

class Word{
  final String strQuestion;
  final String strAnswer;
  //Stringじゃない、型指定なしでいけるがDateTimeが正しい
  final DateTime strTime;
  final bool isMemorized;
  Word({this.strQuestion,this.strAnswer,this.strTime,this.isMemorized});
}