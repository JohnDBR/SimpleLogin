import 'package:flutter/material.dart';
import 'package:login_flutter/viewmodels/signin_view_model.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/models/user_model.dart';
import 'package:login_flutter/widgets/signin.dart';
import 'package:login_flutter/widgets/home.dart';

import 'base/base_view.dart';
import 'locator.dart';

void main() {
  setupLocator();
  runApp(MainPage()); 
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _logged = false;
  UserModel userModel = UserModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModel>(
      //      <--- ChangeNotifierProvider
      create: (context) => userModel,
      child: _buildUi(userModel)
    );
  }

  Widget _buildUi(UserModel userModel) {
    return MaterialApp(
      title: 'SimpleLogin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BaseView<SignInViewModel>(
        onModelReady: (model) async {
            userModel.loadSession();
            model.checkToken(token: userModel.userInfo.token);
          },
        builder: (context, model, child) => (userModel.logged || model.tokenStatus) ? Home(userModel: userModel, notifyParent: () {
          // model.checkToken(token: userModel.userInfo.token);
          }) : SignIn(userModel: userModel, notifyParent: () {
            debugPrint('NOT EVIL! PLAYING SMART!');
          },)
      )
    );
  }
}
