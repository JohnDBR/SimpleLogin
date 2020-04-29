import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/models/user_model.dart';

class Home extends StatelessWidget {
  final UserModel userModel;
  final Function() notifyParent;

  Home({Key key, @required this.userModel, @required this.notifyParent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
          children: <Widget>[
            Center(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                alignment: Alignment.center,
                color: Colors.amber[600],
                // height: 48.0,  // this restricts height, it takes the width of the parent
                child: Consumer<UserModel>(
                  //                  <--- Consumer
                  builder: (context, userModel, child) {
                    return Text('${userModel.userInfo.name}\'s Home - Token ${userModel.userInfo.token}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black.withOpacity(0.6))
                    );
                  }
                )
              )
            ),
            Consumer<UserModel>(
              //                  <--- Consumer
              builder: (context, userModel, child) {
                return RaisedButton(
                  onPressed: () {
                    userModel.logout();
                    this.notifyParent();
                  },
                  child: Text('Logout'),
                );
              }
            )
          ],
        );
  }
}


