import 'package:flutter/material.dart';
import 'package:myownflashcardver2/models/db/dao.dart';
import 'package:myownflashcardver2/models/db/database.dart';
import 'package:myownflashcardver2/models/repository/words_repository.dart';
import 'package:myownflashcardver2/viewmodels/check_test_viewmodel.dart';
import 'package:myownflashcardver2/viewmodels/di_edit_word_viewmodel.dart';
import 'package:myownflashcardver2/viewmodels/edit_word_viewmodel.dart';
import 'package:myownflashcardver2/viewmodels/home_screen_viewmodel.dart';
import 'package:myownflashcardver2/viewmodels/list_word_viewmodel.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';


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

//chapter98 RepositoryにChangeNotifierProxyProvider
List viewModels =[
  ChangeNotifierProvider<CheckTestViewModel>(
  create: (context)=> CheckTestViewModel(
    repository:Provider.of<WordsRepository>(context, listen: false),
    ),
  ),
  ChangeNotifierProvider<ListWordViewModel>(
    create: (context)=>ListWordViewModel(
      repository:Provider.of<WordsRepository>(context, listen: false),
    ),
  ),
  ChangeNotifierProvider<DiEditWordViewModel>(
    create: (context)=>DiEditWordViewModel(
        repository:Provider.of<WordsRepository>(context, listen: false),
    ),
  ),
  ChangeNotifierProvider<HomeScreenViewModel>(
    create: (context)=>HomeScreenViewModel(),
        ),
];