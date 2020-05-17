import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
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
              Navigator.of(context).pop();
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
          // ListTile(
          //   title: Text(''),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (BuildContext context) => Page2()));
          //   },
          // ),
        ],
      ),
    );
  }
}
