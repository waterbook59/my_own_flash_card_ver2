//daoへクエリ外注予定

//step1でpubspec.yamlのdependencies,dev.dependenciesに各項目入れてpub.get
//libフォルダ内にデータベースの記載を格納するdartファイルを準備(今回はdatabase.dart)

import 'dart:io';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';

//step2.コード生成用ファイル定義
// libフォルダの中に自分で作った名前(今回はdatabase).dartの名前から名前.g.dartを記載
part 'database.g.dart';

//step3.問題と答えの項目を入れるテーブルクラス定義
//moorのTableをimportすること
//TODO エンティティとしてWordではなくWordRecordを作って格納する
class Words extends Table {
  //Table内でTextColumnメソッドを使ってカラム設置
  //ちなみにautoIncrementで行番号自動で増やしたりなどの制約をかけることができる
  //ちなみにtext()()となってるのはtext()だけだとnullになってしまうので
    TextColumn get strQuestion => text()();
    TextColumn get strAnswer => text()();
    DateTimeColumn get strTime => dateTime()();
    //暗記済かどうかの項目をあとで追加、初期設定をfalseにして生成
    //項目追加後の新規文字登録時に発動（項目追加前は自分で_onWordRegisteredのところで追加必要）
    BoolColumn get isMemorized =>boolean().withDefault(Constant(false))();

  //重複登録を避けるためstrQuestionをprimaryキー設定
  /*  get primaryKey => super.primaryKey;のところを
      get primaryKey => {strQuestion};
   */
    @override
  Set<Column> get primaryKey => {strQuestion};
}

//step4 @UseMoorでクラス記載した後、LazyDatabaseの関数を記載
@UseMoor (tables: [Words])
class MyDatabase extends _$MyDatabase {
  // we tell the database where to store the data with this constructor
  MyDatabase() : super(_openConnection());

  //step6 MyDatabaseをoption+enterでCreate 1 missing overridesでschemaVersion出でくるので、
  //はじめ１に設定
  @override
  //  初期値throw UnimplementedError()
  //Migrationするのに1から2へ変更
  int get schemaVersion => 2;

  //後からDBの項目変更したときに前からあったデータをスムーズに移行するためのMigration
  @override
  MigrationStrategy get migration => MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAllTables();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          // we added the dueDate property in the change from version 1
          await m.addColumn(words, words.isMemorized);
        }
      }
  );



  //step7 Databaseクラス内でCRUDクエリメソッド作成
  //データベースは全て行単位なので、引数Wordクラスで単数の名前(sつかない)
  //databaseクラス１行分のデータクラス(extends DataClass)はdatabase.g.dart生成時に作られる

  //Create(挿入) 参考:Inserts
  /*addWord(1行分のデータを引数で渡す)=>into(テーブルクラス名).insert(1行分データの引数)
   行単位の引数の時は、戻り値はvoidで良さそう
   insertメソッドの戻り値は行番号を返すのでFuture<int>になっている
   */
  Future addWord(Word word) =>into(words).insert(word);

  //Read(抽出)  参考：loads all todo entries
  // 全データ取ってくる Databaseクラス内のプロパティに設定して取ってくる
  //全データなので、戻り値List
  //select(テーブルクラス名)
  Future<List<Word>> get allWords => select(words).get();
  //暗記済がfalse(暗記してないもの)だけを取ってくるクエリ
  Future<List<Word>> get memorizedExcludeWords => (select(words)..where((t)=>t.isMemorized.equals(false))).get();
  //暗記済のものが後ろになるように取ってくるクエリ（並び替えなのでorder by）
  //bool型はOrderingTermデフォルトのasc(昇順)ならtrueが0,falseが1の順
  Future<List<Word>> get allWordsSorted => (select(words)..orderBy([(t)=>OrderingTerm(expression: t.isMemorized)])).get();

  //練習で登録日時順で取ってくる
  Future<List<Word>> get timeSorted => (select(words)..orderBy([(t)=>OrderingTerm(expression: t.strTime,mode: OrderingMode.desc)])).get();

  //Update(更新) 参考：Updates and deletes
  Future updateWord(Word word) =>update(words).replace(word);

  //Delete(削除) 参考：Updates and delete
  //tableの中に設定したstrQuestionというfieldが引数の１行分のデータベースのstrQuestionと等しかったら削除
  //今回、strQuestionにprimary keyを設定しているのでword.strQuestionで抽出
  Future deleteWord(Word word)=>
      (delete(words)..where((t)=>t.strQuestion.equals(word.strQuestion)))
          .go();
}


  //step4のLazyDatabaseはメソッドではなく、関数で独立
  //ここは基本的にコピペhttps://moor.simonbinder.eu/docs/getting-started/
  LazyDatabase _openConnection() {
    // the LazyDatabase util lets us find the right location for the file async.
    return LazyDatabase(() async {
      // put the database file, called db.sqlite here, into the documents folder
      // for your app.
      /*スマホの中でフォルダを作っている、
       getApplicationDocumentsDirectoryは'package:path_provider/path_provider.dart';をimport
       */
      final dbFolder = await getApplicationDocumentsDirectory();

      /*上のdbFolderの中にwords.dbというファイルを作る
        Fileはimport 'dart:io';
        pはimport 'package:path/path.dart' as p;
       */
      final file = File(p.join(dbFolder.path, 'words.db'));

      /*スマホの中に作ったフォルダの中のwords.dbというファイルをVmDatabaseで引っ張ってくる
      VmDatabaseはimport 'package:moor_ffi/moor_ffi.dart';
       */
      return VmDatabase(file);
    });
  }


//flutterコマンドでコード生成はMyDatabaseクラス作って、LazyDatabase関数作ってから
//step5 ターミナルでコード生成
// flutter packages pub run build_runner watch(変更を都度databese.g.dartへ反映) or
// flutter packages pub run build_runner build(1回だけdatabase.g.dartを作る)