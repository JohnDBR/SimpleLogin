import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/models/user_model.dart';
import 'package:login_flutter/screens/main_page.dart';

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
  String _confirmPassword;

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
                      if (_formKey.currentState.validate()) {
                        //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                        if (_password == _confirmPassword) {
                          debugPrint('IM HERE!');
                          userModel.storeUsername(_email, _password);
                        }
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