import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/models/user_model.dart';
import 'package:login_flutter/widgets/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  final UserModel userModel;

  SignIn({Key key, @required this.userModel}) : super(key: key);

  _SignInState createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool _requesting = false;
  bool _rememberMe = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _retrieveRememberMe();    
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _retrieveRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rmbMe = (prefs.getBool('rememberMe') ?? false);
    if (rmbMe) {
      String email = (prefs.getString('email') ?? 'null');
      String password = (prefs.getString('password') ?? 'null');
      setState(() {
        _email = email;
        _password = password;
        _emailController.text = email;
        _passwordController.text = password;
        _rememberMe = true;
      });
    }
  } 

  void _ackAlert(
      {BuildContext context,
      String title,
      String message,
      bool redirect}) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: Text('$message'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.popUntil(context, (route) {
                //   return route.settings.name == "/";
                // });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('SignIn'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        // icon: const Padding(
                        //   padding: const EdgeInsets.only(top: 15.0),
                        //   child: const Icon(Icons.lock)
                        // )
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          // icon: const Padding(
                          // padding: const EdgeInsets.only(top: 15.0),
                          // child: const Icon(Icons.lock)
                          // )
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          {
                            setState(() {
                              _password = value;
                            });
                          }
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: CheckboxListTile(
                      title: Text('Remember me'),
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value;
                        });
                      },
                    )
                  ),
                  Consumer<UserModel>(
                      //                  <--- Consumer
                      builder: (context, userModel, child) {
                      return RaisedButton(
                        onPressed: () {
                          if (!_requesting && _formKey.currentState.validate()) {
                            _requesting = true;
                            userModel
                                .signInRequest(email: _email, password: _password, rmbMe: _rememberMe)
                                .then((user) {
                              _requesting = false;
                              return _ackAlert(
                                  context: context,
                                  title: 'SignIn',
                                  message: 'You have successfuly SignIn!');
                            }).catchError((error) {
                              _requesting = false;
                              return _ackAlert(
                                  context: context,
                                  title: 'Error',
                                  message: error.toString());
                            }).timeout(Duration(seconds: 10), onTimeout: () {
                              _requesting = false;
                              return _ackAlert(
                                  context: context,
                                  title: 'Error',
                                  message: 'Timeout > 10secs');
                            });
                          }
                        },
                        child: Text('Submit'),
                        textColor: Colors.white,
                        color: Colors.blue
                      );
                    }
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Consumer<UserModel>(
                          //                  <--- Consumer
                          builder: (context, userModel, child) {
                        return FlatButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp(userModel: userModel)),
                            );
                          },
                          child: Text('No account? SignUp!'),
                          textColor: Colors.blue,
                        );
                      }))
                ],
              ),
            )
          )
        )
      )
    );
  }
}
