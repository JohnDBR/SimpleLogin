import 'package:flutter/material.dart';
import 'package:login_flutter/models/user_model.dart';
import 'package:login_flutter/widgets/students.dart';
import 'package:login_flutter/widgets/teachers.dart';

class DrawerMenu extends StatelessWidget {
  final UserModel userModel;
  final String screen;
  final Function() notifyParent;

  DrawerMenu({Key key, @required this.userModel, @required this.screen, @required this.notifyParent}) : super(key: key);

  void navigate(BuildContext context, String destiny) {
    if (destiny == 'Courses') {
      if (screen == 'Courses') {
        Navigator.of(context).pop(); // Drawer pop!
      } else if (screen == 'Students' || screen == 'Teachers') {
        Navigator.of(context).pop(); // Drawer pop!
        Navigator.of(context).pop(); // Stack pop!
        Navigator.of(context).pop(); // Destiny Drawer pop!
      }
    } else if (destiny == 'Students') {
      if (screen == 'Courses') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  Students(userModel: userModel, notifyParent: notifyParent)));
      } else if (screen == 'Teachers') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            settings: RouteSettings(name: "Students"),
            builder: (context) => Students(userModel: userModel, notifyParent: notifyParent)
          ),
        );
      } else {
        Navigator.of(context).pop(); // Drawer pop!
      }
    } else if (destiny == 'Teachers') {
      if (screen == 'Courses') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  Teachers(userModel: userModel, notifyParent: notifyParent)));
      } else if (screen == 'Students') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            settings: RouteSettings(name: "Teachers"),
            builder: (context) => Teachers(userModel: userModel, notifyParent: notifyParent)
          ),
        );
      } else {
        Navigator.of(context).pop(); // Drawer pop!
      }
    }
  }

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
              navigate(context, 'Courses');
            },
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            title: Text('Students'),
            onTap: () {
              navigate(context, 'Students');
            },
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            title: Text('Teachers'),
            onTap: () {
              navigate(context, 'Teachers');
            }
          ),
          // Divider(
          //   color: Colors.black,
          // ),
          // ListTile(
          //   title: Text('Teachers'),
          //   onTap: () {
          //     Navigator.of(context).popUntil((route) => route.isFirst);
          //   }
          // )                
        ],
      ),
    );
  }
}
