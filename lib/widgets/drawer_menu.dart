import 'package:flutter/material.dart';
import 'package:login_flutter/models/user_model.dart';
import 'package:login_flutter/widgets/students.dart';
import 'package:login_flutter/widgets/teachers.dart';

class DrawerMenu extends StatelessWidget {
  final UserModel userModel;

  DrawerMenu({Key key, @required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Courses'),
            onTap: () {
              // Navigator.of(context).pop();
              Navigator.of(context).pushNamedAndRemoveUntil(
                "MainPage",
                (route) => route.isCurrent && route.settings.name == "MainPage"
                    ? false
                    : true);
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (BuildContext context) => MainPage()));
            },
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            title: Text('Students'),
            onTap: () {
              // Navigator.of(context).pop();
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //   "Students",
              //   (route) => route.isCurrent && route.settings.name == "Students"
              //       ? false
              //       : true);

              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (BuildContext context) => Students(userModel: userModel, notifyParent: () {})));

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Students(userModel: userModel, notifyParent: () {})),
              );
            },
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            title: Text('Teachers'),
            onTap: () {
              // Navigator.of(context).pop();
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //   "Teachers",
              //   (route) => route.isCurrent && route.settings.name == "Teachers"
              //       ? false
              //       : true);

              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (BuildContext context) => Teachers(userModel: userModel, notifyParent: () {})));

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Teachers(userModel: userModel, notifyParent: () {})),
              );
            }
          )
        ],
      ),
    );
  }
}
