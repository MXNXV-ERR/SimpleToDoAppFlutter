import 'package:flutter/material.dart';
import 'package:simpletodo/databasehelper.dart';
import 'package:simpletodo/screens/taskpage.dart';
import 'package:simpletodo/widgets.dart';
import 'package:simpletodo/golbals.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

// ignore: must_be_immutable
class Homepage extends StatefulWidget {
  bool isdarkMode = true;
  Homepage({Key? key, required this.isdarkMode}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String retmimg() {
    if (widget.isdarkMode == true) return "assets/images/ld.png";
    return "assets/images/dl.png";
  }

  void colorchanger() {
    if (widget.isdarkMode) {
      back = Colors.black;
      primary = Colors.white;
      theme = Colors.blue;
      secondaryfaded = Colors.blueGrey;
      accent = Colors.blueAccent;
      secondary = Colors.blueGrey[50];
      cardcolor = Colors.blueGrey[900];
    } else {
      back = Colors.white;
      primary = Colors.black;
      secondary = Colors.black;
      secondaryfaded = Colors.black38;
      cardcolor = Colors.blueGrey[100];
    }
  }

  DataBaseHelper _dbh = DataBaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: back,
        body: Container(
          margin: const EdgeInsets.only(top: 40),
          padding: const EdgeInsets.all(10.0),
          color: back,
          child: Stack(children: [
            Positioned(
              top: 0.0,
              right: 0.0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.isdarkMode = !widget.isdarkMode;
                    colorchanger();
                  });
                },
                child: Image.asset(
                  retmimg(),
                  alignment: Alignment.topRight,
                  fit: BoxFit.scaleDown,
                  scale: 17,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  scale: 5,
                ),
                Expanded(
                    child: FutureBuilder<dynamic>(
                  initialData: [],
                  future: _dbh.getTasks(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return SwipeActionCell(
                            backgroundColor: back,
                            key: ObjectKey(snapshot.data[index]),
                            trailingActions: <SwipeAction>[
                              SwipeAction(
                                color: Colors.transparent,
                                performsFirstActionWithFullSwipe: false,
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
                                                vertical: 47.0,
                                                horizontal: 15.0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                color: Colors.red),
                                            child: Row(children: [
                                              Icon(Icons.delete, color: back),
                                              Text(
                                                "Delete   ",
                                                style: TextStyle(color: back),
                                              )
                                            ])),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: (CompletionHandler handler) async {
                                  await handler(true);
                                  await _dbh.delTask(snapshot.data[index].id);
                                  setState(() {});
                                },
                              )
                            ],
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TaskPage(
                                                task: snapshot.data[index],
                                              ))).then((value) {
                                    setState(() {});
                                  });
                                },
                                child: TaskCard(
                                  title: snapshot.data[index].title,
                                  desc: snapshot.data[index].desc,
                                )));
                      },
                    );
                  },
                ))
              ],
            ),
            Positioned(
                bottom: 5.0,
                right: 5.0,
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskPage(
                                  task: null,
                                )),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        right: 15.0,
                        left: 15.0,
                        bottom: 2.0,
                        top: 2.0,
                      ),
                      decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Text("+",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 50.0)),
                    )))
          ]),
        ));
  }
}
