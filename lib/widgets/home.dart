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
  bool requesting = false;
  List<CourseInfo> courses = new List<CourseInfo>();

  @override
  void initState() {
    super.initState();
    _retrieveCourses();    
  }

  void _retrieveCourses() async {
    widget.userModel
      .getCourses(
        token: widget.userModel.userInfo.token,
        username: widget.userModel.userInfo.username
      )
      .then((listCourses) {
        setState(() { //This could be optimized!
          //for (final course in listCourses) {
          //  courses.add(course);
          //}
          courses = listCourses;
        });
    }).catchError((error) {
      // return _ackAlert(
      //     context: context,
      //     title: 'Error',
      //     message: error.toString());
    }).timeout(Duration(seconds: 10), onTimeout: () {
      // return _ackAlert(
      //     context: context,
      //     title: 'Error',
      //     message: 'Timeout to get courses > 10secs');
    });
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
                  // Center(
                  //     child:
                       Container(
                          // padding: EdgeInsets.only(top: 0),
                          // alignment: Alignment.topCenter,
                          // height: 48.0,  // this restricts height, it takes the width of the parent
                          child: Consumer<UserModel>(
                              //                  <--- Consumer
                              builder: (context, userModel, child) {
                            return Text('${userModel.userInfo.name}\'s Home',
                                style: TextStyle(height: 1, fontSize: 25));
                          })),//),
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
                  }),
                  SizedBox(
                    height: 300,
                    child: _list()
                  )
                ],
              )
          )
        )
      ),
      floatingActionButton: Consumer<UserModel>(
        //                  <--- Consumer
        builder: (context, userModel, child) {
          return new FloatingActionButton(
            onPressed: () { // () => _addCourseInfo(),
              if (!requesting) {
                requesting = true;
                userModel
                    .createCourse(token: userModel.userInfo.token, username: userModel.userInfo.username)
                    .then((course) {
                  setState(() {
                    courses.add(course);
                  });
                  requesting = false;
                  return _ackAlert(
                    context: context,
                    title: 'SignIn',
                    message: 'You have successfuly created a course!');
                }).catchError((error) {
                  requesting = false;
                  return _ackAlert(
                    context: context,
                    title: 'Error',
                    message: error.toString());
                }).timeout(Duration(seconds: 10), onTimeout: () {
                  requesting = false;
                  return _ackAlert(
                    context: context,
                    title: 'Error',
                    message: 'Timeout > 10secs');
                });
              }
            },
            tooltip: 'Add course',
            child: new Icon(Icons.add)
          );
        }
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
                        setState(() {
                          courses.removeAt(position);
                        });
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
  //       courses.add(note);
  //     });
  //   }
  // }
}
