import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/models/user_model.dart';

class SignUp extends StatelessWidget {
  final UserModel userModel;

  SignUp({Key key, @required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("SignUp")
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: SignUpForm()
      )
    );
  }
}

class SignUpForm extends StatefulWidget {
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

  void _ackAlert({BuildContext context, String title, String message, bool redirect = false}) async {
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
              }
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
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
                }
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
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
                }
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                labelText: 'Password',
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
                }
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                labelText: 'Confirm Password',
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
                }
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Consumer<UserModel>(
                //                  <--- Consumer
                builder: (context, userModel, child) {
                  return RaisedButton(
                    onPressed: () {
                      if (!_requesting && _formKey.currentState.validate() && _password == _confirmPassword) {
                        _requesting = true;
                        //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                        userModel.signUpRequest(email: _email, password: _password, username: _username, name: _name)
                        .then((user) {
                          _requesting = false;
                          return _ackAlert(
                            context: context,
                            title: 'SignUp',
                            message: 'You have successfuly SignUp! and you are going to be redirected',
                            redirect: true
                          );
                        }).catchError((error) {
                          _requesting = false;
                          return _ackAlert(
                            context: context,
                            title: 'Error',
                            message: error.toString()
                          );
                        }).timeout(Duration(seconds: 10), onTimeout: () {
                          _requesting = false;
                          return _ackAlert(
                            context: context,
                            title: 'Error',
                            message: 'Timeout > 10secs'
                          );
                        });
                      }
                    },
                    child: Text('Submit'),
                  );
                }
              )
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: FlatButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MainPage()),
                  // );
                  Navigator.pop(context);
                },
                child: Text('SignIn')
              )
            )
          ],
        ),
      )
    );
  }
}