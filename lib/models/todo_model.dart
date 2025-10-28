import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

@immutable

class TodoModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final bool checkBox;

  const TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.checkBox,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date,
      "checkBox": checkBox ? 1:0,
    };
  }

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    bool? checkBox,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      checkBox: checkBox ?? this.checkBox,
    );
  }
}
