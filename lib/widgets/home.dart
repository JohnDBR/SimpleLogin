import 'package:flutter/material.dart';
import 'package:login_flutter/base/base_model.dart';
import 'package:login_flutter/base/base_view.dart';
import 'package:login_flutter/models/course_info.dart';
import 'package:login_flutter/viewmodels/home_view_model.dart';
import 'package:login_flutter/widgets/course_detail.dart';
import 'package:provider/provider.dart';
import 'package:login_flutter/models/user_model.dart';

import 'drawer_menu.dart';

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    _scaffoldKey = new GlobalKey<ScaffoldState>();
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
                if (redirect) {
                  widget.notifyParent();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
        onModelReady: (model) { 
          model.getCourses(
            username: widget.userModel.userInfo.username,
            token: widget.userModel.userInfo.token,
            resultFunction: (val) {
              courses = Future.value(model.courses);
            },
            errorFunction: (error) {
              return _ackAlert(
                context: _scaffoldKey.currentContext,
                title: 'Error',
                message: error.toString(),
                redirect: widget.userModel.tokenTimeout(error));
            },
            timeoutFunction: () {
              return _ackAlert(
                context: _scaffoldKey.currentContext,
                title: 'Error',
                message: 'Timeout > 10secs');
            }
          );
        },
        builder: (context, model, child) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: Text('Home')),
        body: model.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator())
                : Container(
                margin: const EdgeInsets.all(0),
                    child: Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                        child: Text(
                          '${widget.userModel.userInfo.name}\'s courses',
                          style: TextStyle(height: 1, fontSize: 25))
                        ),
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
                            // return CircularProgressIndicator();
                            return Center(
                              child: Text('There are no courses available yet!')
                            );
                          },
                        )),
                  ],
                )),
        drawer: DrawerMenu(userModel: widget.userModel, screen: 'Courses', notifyParent: widget.notifyParent),
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
                  heroTag: "logout_btn",
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
                  heroTag: "add_course_btn",
                  onPressed: () {
                    if (!requesting) {
                      requesting = true;
                      model.addCourse(
                        username: widget.userModel.userInfo.username,
                        token: widget.userModel.userInfo.token,
                        resultFunction: (val) {
                          setState(() {
                            courses = Future.value(model.courses);
                          });
                          requesting = false;
                          return _ackAlert(
                            context: context,
                            title: 'SignIn',
                            message: 'You have successfuly created a course!');
                        },
                        errorFunction: (error) {            
                          requesting = false;
                          return _ackAlert(
                            context: context,
                            title: 'Error',
                            message: error.toString(),
                            redirect: widget.userModel.tokenTimeout(error));
                        },
                        timeoutFunction: () {
                          requesting = false;
                          return _ackAlert(
                            context: context,
                            title: 'Error',
                            message: 'Timeout > 10secs');
                        }
                      );
                    }
                  },
                  tooltip: 'Add course',
                  child: new Icon(Icons.add)
                )
              ),
            ],
          );
        })));
  }

  Widget _list(List<CourseInfo> courses) {
    return courses.isEmpty ? Center(child: Text('There are no courses available yet!')
      ) : ListView.builder(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CourseDetail(userModel: widget.userModel, courseId: '${element.id}', notifyParent: widget.notifyParent)),
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.school, size: 50),
                  title: Text(element.name),
                  subtitle: Text(element.professor),
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
