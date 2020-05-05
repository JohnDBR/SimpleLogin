import 'package:flutter/material.dart';
import 'package:login_flutter/models/course_info.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/models/user_model.dart';

class Home extends StatefulWidget {
  final UserModel userModel;
  final Function() notifyParent;

  Home({Key key, @required this.userModel, @required this.notifyParent}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CourseInfo> courses = new List<CourseInfo>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Home')
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child:
              Column(
                children: <Widget>[
                  Center(
                      child: Container(
                          padding: EdgeInsets.only(top: 0),
                          alignment: Alignment.topCenter,
                          // height: 48.0,  // this restricts height, it takes the width of the parent
                          child: Consumer<UserModel>(
                              //                  <--- Consumer
                              builder: (context, userModel, child) {
                            return Text('${userModel.userInfo.name}\'s Home',
                                style: TextStyle(height: 1, fontSize: 25));
                          }))),
                  Consumer<UserModel>(
                      //                  <--- Consumer
                      builder: (context, userModel, child) {
                    return RaisedButton(
                      onPressed: () {
                        userModel.logout();
                        setState(() {
                          widget.notifyParent();
                        });
                      },
                      child: Text('Logout', style: TextStyle(height: 1, fontSize: 25)),
                      textColor: Colors.white,
                      color: Colors.blue,
                    );
                  })
                ],
              )
          )
        )
      )
    );
  }

  Widget _list() {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, position) {
        var element = courses[position];
        return _item(element, position);
      },
    );
  }

  Widget _item(CourseInfo element, int position) {
    return Dismissible(
      background: _backgroundSlide(),
      key: UniqueKey(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final bool res = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(
                    "Are you sure you want to delete ${element.name}?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Remove",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        // There is not an actual endpoint to desroy a course!...
                        // setState(() {
                        //   notes.removeAt(position);
                        // });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
          return res;
        } else {
          // TODO: Navigate to edit page;
        }
      },
      child: Card(
        color: Colors.blueGrey,
        child: InkWell(
          onTap: () {
            // print("${notes[position]} clicked");
            // _onTap(context, element, position);
          },
          child: ListTile(
            title: Text(element.name),
            // subtitle: Text(element.body),
          )
        )
      )
    );
  }

  Widget _backgroundSlide() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      )
    );
  }

  // void _addCourseInfo() async {
  //   final note = await showDialog<CourseInfo>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return NewNoteDialog();
  //     },
  //   );

  //   if (note != null) {
  //     setState(() {
  //       notes.add(note);
  //     });
  //   }
  // }
}
