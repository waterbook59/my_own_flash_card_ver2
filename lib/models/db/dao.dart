import 'package:moor/moor.dart';
import 'package:myownflashcardver2/models/db/database.dart';

part 'dao.g.dart';

@UseDao(tables:[WordRecords])
class WordsDao extends DatabaseAccessor<MyDatabase> with _$WordsDaoMixin{
  //MyDatabase attachedDatabaseをMyDatabase dbに書き換えるとdao.g.dartエラー？？
  WordsDao(MyDatabase attachedDatabase) : super(attachedDatabase);

  //step7 Databaseクラス内でCRUDクエリメソッド作成
  //データベースは全て行単位なので、引数Wordクラスで単数の名前(sつかない)
  //databaseクラス１行分のデータクラス(extends DataClass)はdatabase.g.dart生成時に作られる

  //Create(挿入) 参考:Inserts
  /*addWord(1行分のデータを引数で渡す)=>into(テーブルクラス名).insert(1行分データの引数)
   行単位の引数の時は、戻り値はvoidで良さそう
   insertメソッドの戻り値は行番号を返すのでFuture<int>になっている
   */
  Future addWord(WordRecord wordRecord) =>into(wordRecords).insert(wordRecord);

  //Read(抽出)  参考：loads all todo entries
  // 1.全データ取ってくる Databaseクラス内のプロパティに設定して取ってくる
  //全データなので、戻り値List
  //select(テーブルクラス名)

  //DBからWordRecordのリストを取ってくるクエリ
  Future<List<WordRecord>> get allWords => select(wordRecords).get();
  //2.暗記済がfalse(暗記してないもの)だけを取ってくるクエリ
  Future<List<WordRecord>> get memorizedExcludeWords => (select(wordRecords)..where((t)=>t.isMemorized.equals(false))).get();
  //3.暗記済のものが後ろになるように取ってくるクエリ（並び替えなのでorder by）
  //bool型はOrderingTermデフォルトのasc(昇順)ならtrueが0,falseが1の順
  Future<List<WordRecord>> get allWordsSorted => (select(wordRecords)..orderBy([(t)=>OrderingTerm(expression: t.isMemorized)])).get();

  //4.練習で登録日時順で取ってくる
  Future<List<WordRecord>> get timeSorted => (select(wordRecords)..orderBy([(t)=>OrderingTerm(expression: t.strTime,mode: OrderingMode.desc)])).get();

  //Update(更新) 参考：Updates and deletes
  Future updateWord(WordRecord wordRecord) =>update(wordRecords).replace(wordRecord);

  //Delete(削除) 参考：Updates and delete
  //tableの中に設定したstrQuestionというfieldが引数の１行分のデータベースのstrQuestionと等しかったら削除
  //今回、strQuestionにprimary keyを設定しているのでword.strQuestionで抽出
  Future deleteWord(WordRecord wordRecord)=>
      (delete(wordRecords)..where((t)=>t.strQuestion.equals(wordRecord.strQuestion)))
          .go();

  //DBからWordRecordのリストを取ってくるクエリ:allWordsと同じ
 // Future<List<WordRecord>> get wordsFromDB => select(wordRecords).get();
}


