import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/models/user_model.dart';
import 'package:login_flutter/widgets/signup.dart';

class SignIn extends StatelessWidget {
  final UserModel userModel;

  SignIn({Key key, @required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInForm();
  }
}

class SignInForm extends StatefulWidget {
  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool _requesting = false;

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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
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
              child: Consumer<UserModel>(
                  //                  <--- Consumer
                  builder: (context, userModel, child) {
                return RaisedButton(
                  onPressed: () {
                    if (!_requesting && _formKey.currentState.validate()) {
                      _requesting = true;
                      userModel
                          .signInRequest(email: _email, password: _password)
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
                  color: Colors.blue,
                );
              })),
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
                  child: Text('No account? SignUp !'),
                  textColor: Colors.blue,
                );
              }))
        ],
      ),
    );
  }
}
