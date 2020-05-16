import 'package:flutter/material.dart';
import 'package:login_flutter/base/base_model.dart';
import 'package:login_flutter/base/base_view.dart';
import 'package:login_flutter/viewmodels/signin_view_model.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/models/user_model.dart';
import 'package:login_flutter/widgets/signup.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    List result = await widget.userModel.retrieveRememberMe();
    if (result[2]) {
      setState(() {
        _email = result[0];
        _password = result[1];
        _emailController.text = result[0];
        _passwordController.text = result[1];
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
    return BaseView<SignInViewModel>(
      builder: (context, model, child) => Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('SignIn'),
      ),
      body: model.state == ViewState.Busy
        ? Center(child: CircularProgressIndicator())
        : Center(
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
                  RaisedButton(
                        onPressed: () {
                          if (!_requesting && _formKey.currentState.validate()) {
                            _requesting = true;
                            model.signIn(
                              email: _email,
                              password: _password,
                              resultFunction: () {
                                _requesting = false;
                                return _ackAlert(
                                    context: _scaffoldKey.currentContext,
                                    title: 'SignIn',
                                    message: 'You have successfuly SignIn!');
                              },
                              errorFunction: (error) {
                                _requesting = false;
                                return _ackAlert(
                                  context: _scaffoldKey.currentContext,
                                  title: 'Error',
                                  message: error.toString());
                              },
                              timeoutFunction: () {
                                _requesting = false;
                                return _ackAlert(
                                  context: _scaffoldKey.currentContext,
                                  title: 'Error',
                                  message: 'Timeout > 10secs');
                              }
                          );
                          }
                        },
                        child: Text('Submit'),
                        textColor: Colors.white,
                        color: Colors.blue
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
    ));
  }
}
