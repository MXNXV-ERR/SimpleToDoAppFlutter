//import 'package:todos/models/todo.dart';

class Task {
  late final int? id;
  final String title;
  final String desc;

  Task({this.id, required this.title, required this.desc});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'desc': desc};
  }
}
