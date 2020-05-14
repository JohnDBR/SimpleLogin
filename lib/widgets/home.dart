import 'package:flutter/material.dart';
import 'package:login_flutter/models/course_info.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/models/user_model.dart';

class Home extends StatefulWidget {
  final UserModel userModel;
  final Function() notifyParent;

  Home({Key key, @required this.userModel, @required this.notifyParent})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool requesting = false;
  Future<List<CourseInfo>> courses;

  @override
  void initState() {
    super.initState();
    _retrieveCourses();
  }

  void _retrieveCourses() async {
    courses = widget.userModel.getCourses(
        token: widget.userModel.userInfo.token,
        username: widget.userModel.userInfo.username);
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
        appBar: new AppBar(title: Text('Home')),
        body: Container(
                margin: const EdgeInsets.all(0),
                // alignment: Alignment.center,
                // child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    // Center(
                    //     child:
                    Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                        child: Consumer<UserModel>(
                            //                  <--- Consumer
                            builder: (context, userModel, child) {
                          return Text('${userModel.userInfo.name}\'s courses',
                              style: TextStyle(height: 1, fontSize: 25));
                        })), //),
                    Divider(
                      color: Colors.black,
                    ),
                    Expanded(
                        child: FutureBuilder<List<CourseInfo>>(
                          future: courses,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return _list(snapshot.data);
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }

                            // By default, show a loading spinner.
                            return CircularProgressIndicator();
                          },
                        )),
                  ],
                )),
        floatingActionButton: Consumer<UserModel>(
            //                  <--- Consumer
            builder: (context, userModel, child) {
          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 1.5),
                  child: Consumer<UserModel>(
                //                  <--- Consumer
                builder: (context, userModel, child) {
                return FloatingActionButton.extended(
                  onPressed: () {
                    userModel.logout();
                    setState(() {
                      widget.notifyParent();
                    });
                  },
                  icon: Icon(Icons.power_settings_new),
                  label: Text('Logout',
                      style: TextStyle(height: 1, fontSize: 25)),
                );
              })
              )),
              Align(
                alignment: Alignment.bottomRight,
                child: new FloatingActionButton(
                  onPressed: () {
                    if (!requesting) {
                      requesting = true;
                      userModel
                          .createCourse(
                              token: userModel.userInfo.token,
                              username: userModel.userInfo.username)
                          .then((course) {
                              // setState(() {
                              // _retrieveCourses();
                              // });
                            courses.then((list) {
                              setState(() {
                                list.add(course);
                              });
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
                )
              ),
            ],
          );
        }));
  }

  Widget _list(List<CourseInfo> courses) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 70),
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
                            // courses.data.removeAt(position);
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
            elevation: 5,
            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  // print("${notes[position]} clicked");
                  // _onTap(context, element, position);
                },
                child: ListTile(
                  leading: Icon(Icons.school, size: 50),
                  title: Text(element.name),
                  subtitle: Text(element.professor),
                  // subtitle: Text(element.body),
                ))));
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
        ));
  }
}
