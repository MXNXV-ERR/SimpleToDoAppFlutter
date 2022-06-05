import 'package:flutter/material.dart';
import 'package:todos/golbals.dart';
import 'databasehelper.dart';
//import 'models/task.dart';

class TaskCard extends StatefulWidget {
  final String? title;
  final String? desc;
  const TaskCard({Key? key, required this.title, required this.desc})
      : super(key: key);
  //const TaskCard({ Key? key }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
        decoration: BoxDecoration(
            color: cardcolor, borderRadius: BorderRadius.circular(20.0)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            widget.title ?? "(Unnamed Task)",
            style: TextStyle(
                color: primary, fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(widget.desc ?? "No Description added...",
                  style: TextStyle(color: primary)))
        ]));
  }
}

// ignore: must_be_immutable
class TodoWidget extends StatefulWidget {
  int? taskId;
  //final ToDo? todo;
  late String text;
  late bool isChecked;

  TodoWidget(
      {Key? key, required this.text, required this.isChecked, this.taskId})
      : super(key: key);
  @override
  State<TodoWidget> createState() =>
      // ignore: no_logic_in_create_state
      _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  DataBaseHelper _dbhelper = DataBaseHelper();
  TextDecoration getStrike() {
    if (widget.isChecked) {
      return TextDecoration.lineThrough;
    }
    return TextDecoration.none;
  }

  Color? getColor() {
    if (widget.isChecked) {
      return secondaryfaded;
    }
    return primary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 7.0),
          child: Transform.scale(
            scale: 1.25,
            child: Checkbox(
                checkColor: back,
                fillColor: MaterialStateProperty.resolveWith((states) => theme),
                value: widget.isChecked,
                splashRadius: 20.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                onChanged: (bool? value) async {
                  setState(() {
                    widget.isChecked = value!;
                  });
                  await _dbhelper.upTodoDone(
                      widget.taskId, widget.text, widget.isChecked ? 1 : 0);
                }),
          ),
        ),
        Flexible(
            child: TextField(
          onSubmitted: (value) async {
            if (value != "") {
              if (widget.taskId != 0) {
                await _dbhelper.upTodo(widget.taskId, widget.text, value);
                setState(() {
                  widget.text = value;
                });
                print("updated  ");
              }
            }
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter a new to do......',
            hintStyle: TextStyle(color: secondaryfaded),
          ),
          style: TextStyle(
            color: getColor(),
            decoration: getStrike(),
            overflow: TextOverflow.fade,
          ),
          controller: TextEditingController()..text = widget.text,
        )),
        /*Container(
            padding: EdgeInsets.only(right: 7.0),
            child: InkWell(
              onTap: () {
                setState(() {
                  _dbhelper.delTodo(widget.text);
                });
              },
              child: Icon(
                Icons.close,
                color: primary,
              ),
            ))*/
      ],
    ));
  }
}
