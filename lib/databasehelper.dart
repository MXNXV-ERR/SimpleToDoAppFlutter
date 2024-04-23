import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:simpletodo/models/task.dart';
import 'models/todo.dart';

class DataBaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'tododb.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, desc TEXT)",
        );
        await db.execute(
          "CREATE TABLE toDos(id INTEGER PRIMARY KEY AUTOINCREMENT, taskId INTEGER, title TEXT, isDone INTEGER)",
        );
        return;
      },
      version: 1,
    );
  }

  Future<void> upTaskTile(int? id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void> upTaskDesc(int? id, String desc) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET desc = '$desc' WHERE id = '$id'");
  }

  Future<void> upTodo(int? id, String text, String title) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE toDos SET title = '$title' WHERE title = '$text' AND taskId = '$id'");
  }

  Future<void> upTodoDone(int? id, String text, int isdone) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE toDos SET isDone = '$isdone' WHERE taskId = '$id' AND title = '$text'");
  }

  Future<void> delTask(int? id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
  }

  Future<void> delTodo(int todoid, String title, int? taskid) async {
    Database _db = await database();
    await _db.rawDelete(
        "DELETE FROM toDos WHERE title = '$title' and taskId = '$taskid' and id='$todoid'");
  }

  Future<int> insTask(Task task) async {
    int taskId = 0;
    Database _db = await database();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskId = value;
    });
    return taskId;
  }

  Future<void> insTodo(ToDo toDo) async {
    Database _db = await database();
    await _db.insert('toDos', toDo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          desc: taskMap[index]['desc']);
    });
  }

  Future<List<ToDo>> getTodos(int? taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery("SELECT * FROM toDos WHERE  taskId=$taskId");
    return List.generate(todoMap.length, (index) {
      return ToDo(
        id: todoMap[index]['id'],
        title: todoMap[index]['title'],
        taskId: todoMap[index]['taskID'],
        isDone: todoMap[index]['isDone'],
      );
    });
  }
}
