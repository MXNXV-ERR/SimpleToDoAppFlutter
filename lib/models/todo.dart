class ToDo {
  final int? id;
  final int? taskId;
  final String title;
  final int isDone;

  ToDo(
      {this.id,
      required this.taskId,
      required this.title,
      required this.isDone});
  Map<String, dynamic> toMap() {
    return {'id': id, 'taskId': taskId, 'title': title, 'isDone': isDone};
  }
}
