import 'package:flutter/material.dart';

import 'login_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    print("HomePageのStatelessWidget buildの中:$context");
    return
//      MultiProvider(
//      providers: [
//        // Injects HomeViewModel into this widgets.
//        ChangeNotifierProvider(create: (_) => HomeViewModel()),
//      ],
//      child:
      Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: HomePageBody(),
//        floatingActionButton: _HomePageFloatingActionButton(),

    );
  }
}

//class _HomePageFloatingActionButton extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return FloatingActionButton(
//      onPressed:
//      Provider.of<HomeViewModel>(context, listen: false).incrementCounter,
//      tooltip: 'Increment',
//      child: Icon(Icons.add),
//    );
//  }
//}

class HomePageBody extends StatefulWidget {

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  void initState() {
    super.initState();
//    print("_HomePageBodyStateのinitStateの中:$context");
    // Listen events by view model.
//    var viewModel = Provider.of<HomeViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
//    print("_HomePageBodyStateのStateウィジェット buildの中:$context");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
          ),
//          Text(
//            Provider.of<HomeViewModel>(context).counter.toString(),
//            style: Theme.of(context).textTheme.display1,
//          ),
          RaisedButton(
            child: Text("ログインページへ"),
            onPressed: ()=>_toLoginPage(context),
          ),
        ],
      ),
    );
  }

  _toLoginPage(BuildContext context) {
//    print("_toLoginPageに渡したBuildContextの値:$context");
//    final viewModel= Provider.of<HomeViewModel>(context,listen: false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context)=>LoginPage(),
      ),
    );
  }
}
