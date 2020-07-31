import 'package:flutter/material.dart';
import 'package:myownflashcardver2/models/db/dao.dart';
import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/repository/words_repository.dart';
import 'package:provider/provider.dart';


List<SingleChildWidget> globalProviders =[
  ...independentModels,
  ...dependentModels,
  ...viewModels
];

List independentModels = [
  Provider<MyDatabase>(
    create: (_)=>MyDatabase(),
    dispose: (_,db) =>db.close(),
  )
];

List dependentModels = [
  ProxyProvider<MyDatabase,WordsDao>(
    update: (_, db, dao)=>WordsDao(db),
),
  ProxyProvider<WordsDao,WordsRepository>(
    update: (_, dao, repository)=>WordsRepository(dao: dao),
  ),
];
