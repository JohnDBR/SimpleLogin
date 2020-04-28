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

  @override
  void initState() {
    super.initState();
    _retrieveLoginStatus();    
  }

  void _retrieveLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _logged = (prefs.getBool('logged') ?? false);
    });
  }

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
              return (userModel.logged || _logged) ? Text('Home') : Text('SignIn');
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
                  return (userModel.logged || _logged) ? Home(userModel: userModel, notifyParent: _retrieveLoginStatus) : SignIn(userModel: userModel);
                }
              )
            )
          )
        )
      )
    );
  }
}
