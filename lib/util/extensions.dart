import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/model/words_model.dart';




//リスト形式ではなくて１行単位
//Dartのモデルクラス(Word)=>DBのテーブルクラス(WordRecord)へ変換
extension ConvertToWordRecord on Word{

  WordRecord toWordRecord(Word word){
    var wordRecord = WordRecord();

          WordRecord(
            strQuestion:word.strQuestion ?? "",
            strAnswer:word.strAnswer ?? "",
            strTime: word.strTime ??"",
            isMemorized: word.isMemorized ?? false,
          );
    return wordRecord;
  }
}


//DBのテーブルクラス(WordRecord)=> Dartのモデルクラス(Word)へ変換
extension ConvertToWords on List<WordRecord>{

  List<Word> toWords(List<WordRecord> wordRecords){
    var words = List<Word>();

    wordRecords.forEach((wordRecord){
      words.add(
        Word(
            strQuestion:wordRecord.strQuestion ?? "",
            strAnswer:wordRecord.strAnswer ?? "",
            strTime: wordRecord.strTime ??"",
            isMemorized: wordRecord.isMemorized ?? false,
        )
      );
    });
    return words;
  }
}

//Dartのモデルクラス(Words)=>DBのテーブルクラス(WordRecords)へ変換
//extension ConvertToWordRecords on List<Word>{
//
//  List<WordRecord> toWordRecords(List<Word> words){
//    var wordRecords = List<WordRecord>();
//
//    words.forEach((word){
//      wordRecords.add(
//          WordRecord(
//            strQuestion:word.strQuestion ?? "",
//            strAnswer:word.strAnswer ?? "",
//            strTime: word.strTime ??"",
//            isMemorized: word.isMemorized ?? false,
//          )
//      );
//    });
//    return wordRecords;
//  }
//}