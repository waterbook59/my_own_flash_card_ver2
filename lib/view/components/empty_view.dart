import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("You don't have a task!!!"),
          SizedBox(height: 16),
          Text(
            'Complete!!!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}

