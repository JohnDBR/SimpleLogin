import 'package:flutter/material.dart';
import 'package:login_flutter/base/base_model.dart';
import 'package:login_flutter/base/base_view.dart';
import 'package:login_flutter/models/student_info.dart';
import 'package:login_flutter/viewmodels/course_detail_view_model.dart';
import 'package:login_flutter/models/user_model.dart';
import 'package:login_flutter/widgets/student_detail.dart';
import 'package:provider/provider.dart';

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class CourseDetail extends StatefulWidget {
  final UserModel userModel;
  final Function() notifyParent;
  final String courseId;

  CourseDetail({Key key, @required this.userModel, @required this.notifyParent, @required this.courseId})
      : super(key: key);

  @override
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  bool requesting = false;
  Future<List<StudentInfo>> students;

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
                  Navigator.of(context).popUntil((route) => route.isFirst);
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
    return BaseView<CourseDetailViewModel>(
        onModelReady: (model) { 
          model.showCourse(
            username: widget.userModel.userInfo.username,
            token: widget.userModel.userInfo.token,
            courseId: widget.courseId,
            resultFunction: (val) {
              students = Future.value(model.course.studentsInfo);
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
        appBar: AppBar(title: Text('Course Detail')),
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
                          '${model.course.name}',
                          style: TextStyle(height: 1, fontSize: 20))
                        ),
                    Divider(
                      color: Colors.black,
                    ),
                    Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.fromLTRB(5, 5, 200, 5),
                        child: Text(
                          'Teacher\'s info',
                          style: TextStyle(height: 1, fontSize: 25))
                        ),
                        Container(
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.fromLTRB(5, 5, 1000, 5),
                            width: 300.0,
                            height: 20.0,
                            
                            child: Icon(Icons.person_outline , size: 100),
                          ),
                    Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.fromLTRB(150, 5, 5, 5),
                        child: Text(
                          'Name: ${model.course.teacherInfo.name}',
                          style: TextStyle(height: 1, fontSize: 15))
                        ),
                    Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.fromLTRB(150, 5, 5, 5),
                        child: Text(
                          'Email: ${model.course.teacherInfo.email}',
                          style: TextStyle(height: 1, fontSize: 15))
                        ),
                    Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.fromLTRB(150, 5, 5, 5),
                        child: Text(
                          'Username: ${model.course.teacherInfo.username}',
                          style: TextStyle(height: 1, fontSize: 15))
                        ),
                        
                    Divider(
                      color: Colors.black,
                    ),
                    Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                        child: Text(
                          'Student\'s list',
                          style: TextStyle(height: 1, fontSize: 25))
                        ),
                    Divider(
                      color: Colors.black,
                    ),
                    Expanded(
                        child: FutureBuilder<List<StudentInfo>>(
                          future: students,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return _list(snapshot.data);
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }

                            // By default, show a loading spinner.
                            // return CircularProgressIndicator();
                            return Center(
                              child: Text('There are no students available yet!')
                            );
                          },
                        )),
                  ],
                )),
        // drawer: DrawerMenu(userModel: widget.userModel),
        floatingActionButton: Consumer<UserModel>(
            //                  <--- Consumer
            builder: (context, userModel, child) {
          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomRight,
                child: new FloatingActionButton(
                  heroTag: "add_student_btn",
                  onPressed: () {
                    if (!requesting) {
                      requesting = true;
                      model.addStudent(
                        username: widget.userModel.userInfo.username,
                        token: widget.userModel.userInfo.token,
                        courseId: '${widget.courseId}',
                        resultFunction: (val) {
                            students.then((list) {
                              setState(() {
                                list.add(model.student);
                              });
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
        })
        ));
  }

  Widget _list(List<StudentInfo> students) {
    return students.isEmpty ? Center(child: Text('There are no courses available yet!')
      ) : ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 70),
      itemCount: students.length,
      itemBuilder: (context, position) {
        var element = students[position];
        return _item(element, position);
      },
    );
  }

  Widget _item(StudentInfo element, int position) {
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
                        builder: (context) => StudentDetail(userModel: widget.userModel, studentId: '${element.id}', notifyParent: widget.notifyParent)),
                  );
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
