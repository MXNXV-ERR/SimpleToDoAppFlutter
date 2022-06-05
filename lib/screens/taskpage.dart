import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:todos/databasehelper.dart';
import 'package:todos/golbals.dart';
import 'package:todos/models/task.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task? task;

  const TaskPage({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int? _taskid = 0;
  String _taskTitle = "";
  String _taskDesc = "";
  //String _todo = "";
  bool isvisible = false;
  late FocusNode _titleF, _descF;

  DataBaseHelper _dbhelper = DataBaseHelper();

  Color getBackcolor() {
    if (back == Colors.white)
      return Colors.black;
    else
      return Colors.white;
  }

  @override
  void initState() {
    if (widget.task != null) {
      isvisible = true;
      _taskTitle = widget.task!.title;
      _taskDesc = widget.task!.desc;
      _taskid = widget.task!.id;
    }
    _titleF = FocusNode();
    _descF = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleF.dispose();
    _descF.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: back,
        body: Container(
            margin: EdgeInsets.only(top: 35),
            child: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.arrow_back,
                              size: 45,
                              color: getBackcolor(),
                            )
                            /*Image.asset(
                              'assets/images/backarrow.png',
                              scale: 5,
                            )*/
                            ),
                      ),
                      Expanded(
                        child: TextField(
                          key: Key(_taskTitle.toString()),
                          focusNode: _titleF,
                          onSubmitted: (value) async {
                            if (value != "") {
                              if (widget.task == null) {
                                Task _newtask = Task(title: value, desc: '');
                                _taskid = await _dbhelper.insTask(_newtask);
                                setState(() {
                                  isvisible = true;
                                  _taskTitle = value;
                                });
                                print("task created  $_taskTitle");
                              } else {
                                await _dbhelper.upTaskTile(_taskid, value);
                                _taskTitle = value;
                                setState(() {});
                              }
                              _descF.requestFocus();
                            }
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              hintText: 'Task Title',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: secondaryfaded,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          style: TextStyle(
                              color: secondary,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                          controller: TextEditingController()
                            ..text = _taskTitle,
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible: isvisible,
                    child: TextField(
                      onSubmitted: (value) {
                        if (value != "") {
                          if (_taskid != 0) {
                            _dbhelper.upTaskDesc(_taskid, value);
                            _taskDesc = value;
                          }
                        }
                      },
                      focusNode: _descF,
                      decoration: InputDecoration(
                          hintText: 'Enter the description...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 24.0),
                          hintStyle: TextStyle(
                              color: secondaryfaded,
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal)),
                      style: TextStyle(
                        color: secondary,
                      ),
                      controller: TextEditingController()..text = _taskDesc,
                    ),
                  ),
                  FutureBuilder<dynamic>(
                    initialData: [],
                    future: _dbhelper.getTodos(_taskid),
                    builder: (context, snapshot) {
                      return Flexible(
                          child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return SwipeActionCell(
                              backgroundColor: back,
                              key: ObjectKey(snapshot.data[index]),
                              trailingActions: <SwipeAction>[
                                SwipeAction(
                                    color: Colors.transparent,
                                    content: Container(
                                      child: OverflowBox(
                                        alignment: Alignment(-1.10, -0.75),
                                        maxWidth: double.infinity,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5.0,
                                                    horizontal: 10.0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                    color: Colors.red),
                                                child: Row(children: [
                                                  Icon(Icons.delete,
                                                      color: back),
                                                  Text(
                                                    "Delete   ",
                                                    style:
                                                        TextStyle(color: back),
                                                  )
                                                ])),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: (CompletionHandler handler) async {
                                      await handler(true);
                                      await _dbhelper.delTodo(
                                          snapshot.data[index].id,
                                          snapshot.data[index].title,
                                          _taskid);
                                      setState(() {});
                                    })
                              ],
                              child: Column(children: [
                                TodoWidget(
                                  text: snapshot.data[index]!.title,
                                  isChecked: snapshot.data[index].isDone == 0
                                      ? false
                                      : true,
                                  taskId: _taskid,
                                ),
                              ]));
                        },
                      ));
                    },
                  ),
                  Visibility(
                      visible: isvisible,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 47.0, bottom: 15.0, top: 10),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                    onTap: () {},
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: InkWell(
                                            onTap: () {
                                              ToDo toDo = new ToDo(
                                                  taskId: _taskid,
                                                  title: '',
                                                  isDone: 0);
                                              setState(() {
                                                _dbhelper.insTodo(toDo);
                                              });
                                            },
                                            child: SizedBox(
                                                height: 25.0,
                                                width: 100,
                                                child: Text(
                                                  "+ New Todo",
                                                  style: TextStyle(
                                                      color: secondaryfaded,
                                                      fontSize: 15.0),
                                                )))))
                              ])))
                ],
              ),
            ])));
  }
}
