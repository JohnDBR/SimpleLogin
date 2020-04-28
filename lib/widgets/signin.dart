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
            }
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
              labelText: 'Password',
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
              }
            ),
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
                      userModel.checkLogin(_email, _password);
                    }
                  },
                  child: Text('Submit'),
                );
              }
            )
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Consumer<UserModel>(
              //                  <--- Consumer
              builder: (context, userModel, child) {
                return FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp(userModel: userModel)),
                    );
                  },
                  child: Text('Do you have an account?')
                );
              }
            )
          )
        ],
      ),
    );
  }
}