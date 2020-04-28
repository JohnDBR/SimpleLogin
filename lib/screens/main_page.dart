import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/models/user_model.dart';
import 'package:login_flutter/widgets/signin.dart';
import 'package:login_flutter/widgets/home.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModel>(
      //      <--- ChangeNotifierProvider
      create: (context) => UserModel(email : 'john-brs@hotmail.com', password: 'godmode01'),
      child: _buildUi()
    );
  }

  Widget _buildUi() {
    return MaterialApp(
      title: 'SimpleLogin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: new AppBar(
          title: Consumer<UserModel>(
            //                  <--- Consumer
            builder: (context, userModel, child) {
              return userModel.logged ? Text('Home') : Text('SignIn');
            },
          ),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Consumer<UserModel>(
                //                  <--- Consumer
                builder: (context, userModel, child) {
                  return userModel.logged ? Home(userModel: userModel) : SignIn(userModel: userModel);
                }
              )
            )
          )
        )
      )
    );
  }
}
