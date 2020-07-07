import 'package:flutter/material.dart';
import 'package:myownflashcardver2/viewmodels/list_word_viewmodel.dart';
import 'package:provider/provider.dart';

class ListWordScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final viewModel = Provider.of<ListWordViewModel>(context,listen: false);
      viewModel.getWordList();

    return Container();
  }
}
