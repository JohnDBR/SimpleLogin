import 'package:flutter/material.dart';
import 'package:login_flutter/base/base_model.dart';
import 'package:login_flutter/base/base_view.dart';
import 'package:login_flutter/viewmodels/signup_view_model.dart';
import 'package:login_flutter/models/user_model.dart';

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class SignUp extends StatelessWidget {
  final UserModel userModel;

  SignUp({Key key, @required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SignUpViewModel>(
        builder: (context, model, child) => Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(title: Text("SignUp")),
        body: model.state == ViewState.Busy
            ? Center(child: CircularProgressIndicator())
            : Container(
            margin: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: SignUpForm(model: model))));
  }
}

class SignUpForm extends StatefulWidget {
  final SignUpViewModel model;

  SignUpForm({Key key, @required this.model}) : super(key: key);

  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _username;
  String _name;
  String _confirmPassword;
  bool _requesting = false;

  void _ackAlert(
      {BuildContext context,
      String title,
      String message,
      bool redirect = false}) async {
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
                if (redirect) {
                  Navigator.popUntil(context, (route) {
                    return route.settings.name == "/";
                  });
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _username = value;
                });
              }),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  })),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
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
                  })),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
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
                  })),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
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
                        _confirmPassword = value;
                      });
                    }
                  })),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                  onPressed: () {
                    if (!_requesting &&
                        _formKey.currentState.validate() &&
                        _password == _confirmPassword) {
                      _requesting = true;
                      widget.model.signUp(
                        email: _email,
                        password: _password,
                        username: _username,
                        name: _name,
                        resultFunction: () {
                          debugPrint('IM THE FIRST MOTHER FUCKER ALIVE ON EARTH!');
                          _requesting = false;
                          return _ackAlert(
                            context: _scaffoldKey.currentContext,
                            title: 'SignUp',
                            message:
                                'You have successfuly SignUp! and you are going to be redirected',
                            redirect: true);
                        },
                        errorFunction: (error) {
                          _requesting = false;
                          return _ackAlert(
                            context: _scaffoldKey.currentContext,
                            title: 'Error',
                            message: error.toString());
                            // Code to restore the previous wrong form.. 
                            // TextFields need controllers...
                        },
                        timeoutFunction: () {
                          _requesting = false;
                          return _ackAlert(
                            context: _scaffoldKey.currentContext,
                            title: 'Error',
                            message: 'Timeout > 10secs');
                            // Code to restore the previous wrong form.. 
                            // TextFields need controllers...
                        }
                      );
                    }
                  },
                  child:
                      Text('Submit', style: TextStyle(height: 1, fontSize: 25)),
                  textColor: Colors.white,
                  color: Colors.blue,
              )),
          Container(
              alignment: Alignment.center,
              child: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:
                    Text('Sign In!', style: TextStyle(height: 1, fontSize: 30)),
                textColor: Colors.blue,
              ))
        ],
      ),
    ));
  }
}
