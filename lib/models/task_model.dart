class TaskModel {
  final String id;
  final String todoId;
  final String title;
  final String description;
  final bool checkBox;

  const TaskModel({
    required this.id,
    required this.todoId,
    required this.title,
    required this.description,
    required this.checkBox,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "todoId":todoId,
      "title": title,
      "description": description,
      "checkBox": checkBox ? 1:0,
    };
  }

  TaskModel copyWith({
    String? id,
    String? todoId,
    String? title,
    String? description,
    bool? checkBox,
  }) {
    return TaskModel(
      id: id ?? this.id,
      todoId: todoId ?? this.todoId,
      title: title ?? this.title,
      description: description ?? this.description,
      checkBox: checkBox ?? this.checkBox,
    );
  }
}
