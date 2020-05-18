import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_flutter/base/base_model.dart';
import 'package:login_flutter/base/base_view.dart';
import 'package:login_flutter/models/teacher_info.dart';
import 'package:login_flutter/models/user_model.dart';
import 'package:login_flutter/viewmodels/teacher_detail_view_model.dart';
import 'package:provider/provider.dart';

import 'drawer_menu.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class TeacherDetail extends StatefulWidget {
  final UserModel userModel;
  final Function() notifyParent;
  final String teacherId;

  TeacherDetail(
      {Key key,
      @required this.userModel,
      @required this.notifyParent,
      @required this.teacherId})
      : super(key: key);

  @override
  _TeacherDetailState createState() => _TeacherDetailState();
}

class _TeacherDetailState extends State<TeacherDetail> {
  bool requesting = false;

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
    return BaseView<TeacherDetailViewModel>(
        onModelReady: (model) {
          model.showTeacher(
              username: widget.userModel.userInfo.username,
              token: widget.userModel.userInfo.token,
              teacherId: widget.teacherId,
              resultFunction: (val) {
                // teachers = Future.value(model.teachers);
              },
              errorFunction: (error) {
                widget.userModel.tokenTimeout(error);
                return _ackAlert(
                    context: _scaffoldKey.currentContext,
                    title: 'Error',
                    message: error.toString());
              },
              timeoutFunction: () {
                return _ackAlert(
                    context: _scaffoldKey.currentContext,
                    title: 'Error',
                    message: 'Timeout > 10secs');
              });
        },
        builder: (context, model, child) => Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(title: Text('Teacher Detail')),
              body: model.state == ViewState.Busy
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      margin: const EdgeInsets.all(0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            width: 100.0,
                            height: 100.0,
                            child: Icon(Icons.person),
                          ),
                          Container(
                              alignment: Alignment.topCenter,
                              height: (MediaQuery.of(context).size.height -
                                      AppBar().preferredSize.height) /
                                  10,
                              child: Text('${model.teacher.name}',
                                  style: TextStyle(height: 1, fontSize: 20))),
                          Container(
                              alignment: Alignment(0.0, -0.9),
                              height: (MediaQuery.of(context).size.height -
                                      AppBar().preferredSize.height) /
                                  10,
                              child: Text('${model.teacher.email}',
                                  style: TextStyle(height: 1, fontSize: 20))),
                          Container(
                              alignment: Alignment(0.0, -0.8),
                              height: (MediaQuery.of(context).size.height -
                                      AppBar().preferredSize.height) /
                                  10,
                              child: Text("ID : " + '${model.teacher.id}',
                                  style: TextStyle(height: 1, fontSize: 20))),
                          Divider(
                            color: Colors.black,
                          ),
                        ],
                      )),
              drawer: DrawerMenu(userModel: widget.userModel),
              // floatingActionButton: Consumer<UserModel>(
              //     //                  <--- Consumer
              //     builder: (context, userModel, child) {
              //   return Stack(
              //     children: <Widget>[
              //       Align(
              //         alignment: Alignment.bottomLeft,
              //         child: Container(
              //           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 1.5),
              //           child: Consumer<UserModel>(
              //         //                  <--- Consumer
              //         builder: (context, userModel, child) {
              //         return FloatingActionButton.extended(
              //           onPressed: () {
              //             userModel.logout();
              //             setState(() {
              //               widget.notifyParent();
              //             });
              //           },
              //           icon: Icon(Icons.power_settings_new),
              //           label: Text('Logout',
              //               style: TextStyle(height: 1, fontSize: 25)),
              //         );
              //       })
              //       )),
              //       Align(
              //         alignment: Alignment.bottomRight,
              //         child: new FloatingActionButton(
              //           onPressed: () {
              //             if (!requesting) {
              //               requesting = true;
              //               debugPrint("HOLAAAAA");
              //               model.addTeacher(
              //                 username: widget.userModel.userInfo.username,
              //                 token: widget.userModel.userInfo.token,
              //                 resultFunction: (val) {
              //                   setState(() {
              //                     teacher = Future.value(model.teachers);
              //                   });
              //                   requesting = false;
              //                   return _ackAlert(
              //                     context: context,
              //                     title: 'SignIn',
              //                     message: 'You have successfuly created a course!');
              //                 },
              //                 errorFunction: (error) {
              //                   debugPrint("HOLAAAAA");
              //                   requesting = false;
              //                   return _ackAlert(
              //                     context: context,
              //                     title: 'Error',
              //                     message: error.toString());
              //                 },
              //                 timeoutFunction: () {
              //                   debugPrint("HOLAAAAA");
              //                   requesting = false;
              //                   return _ackAlert(
              //                     context: context,
              //                     title: 'Error',
              //                     message: 'Timeout > 10secs');
              //                 }
              //               );
              //             }
              //           },
              //           tooltip: 'Add course',
              //           child: new Icon(Icons.add)
              //         )
              //       ),
              //     ],
              //   );
              // })
            ));
  }

  Widget _list(List<TeacherInfo> courses) {
    return courses.isEmpty
        ? Center(child: Text('There are no teachers available yet!'))
        : ListView.builder(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 70),
            itemCount: courses.length,
            itemBuilder: (context, position) {
              var element = courses[position];
              return _item(element, position);
            },
          );
  }

  Widget _item(TeacherInfo element, int position) {
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
                  subtitle: Text(element.email),
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
