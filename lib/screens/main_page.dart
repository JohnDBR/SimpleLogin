import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/models/user_model.dart';
import 'package:login_flutter/widgets/signin.dart';
import 'package:login_flutter/widgets/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _logged = false;
  UserModel userModel = UserModel();

  @override
  void initState() {
    super.initState();
    _retrieveLoginStatus();    
  }

  void _retrieveLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() { // This could be optimized!
      bool lggd = (prefs.getBool('logged') ?? false);
      if (lggd) {
        String name = (prefs.getString('name') ?? 'null');
        String token = (prefs.getString('token') ?? 'null');
        String username = (prefs.getString('username') ?? 'null');
        userModel
          .checkTokenRequest(token: token)
          .then((valid) {
          if (valid) {
            _logged = true;
            userModel.load(name, token, username, _logged);
          }
        }).catchError((error) {
          _logged = false;
          // return _ackAlert(
          //     context: context,
          //     title: 'Error',
          //     message: error.toString());
        }).timeout(Duration(seconds: 10), onTimeout: () {
          _logged = false;
          // return _ackAlert(
          //     context: context,
          //     title: 'Error',
          //     message: 'Timeout > 10secs');
        });
      } else {
        _logged = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModel>(
      //      <--- ChangeNotifierProvider
      create: (context) => userModel,
      child: _buildUi()
    );
  }

  Widget _buildUi() {
    return MaterialApp(
      title: 'SimpleLogin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer<UserModel>(
        //                  <--- Consumer
        builder: (context, userModel, child) {
          return (userModel.logged || _logged) ? Home(userModel: userModel, notifyParent: _retrieveLoginStatus) : SignIn(userModel: userModel);
        }
      )
    );
  }
}
