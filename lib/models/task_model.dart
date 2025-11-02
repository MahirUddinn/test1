class TaskModel {
  final String id;
  final String todoId;
  final String title;
  final bool checkBox;

  const TaskModel({
    required this.id,
    required this.todoId,
    required this.title,
    required this.checkBox,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "todoId":todoId,
      "title": title,
      "checkBox": checkBox ? 1:0,
    };
  }

  TaskModel copyWith({
    String? id,
    String? todoId,
    String? title,
    bool? checkBox,
  }) {
    return TaskModel(
      id: id ?? this.id,
      todoId: todoId ?? this.todoId,
      title: title ?? this.title,
      checkBox: checkBox ?? this.checkBox,
    );
  }
}
