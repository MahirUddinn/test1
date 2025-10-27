import 'package:uuid/uuid.dart';

const uuid = Uuid();

class TodoModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final bool checkBox;

  TodoModel({
    required this.title,
    required this.description,
    required this.date,
    required this.checkBox,
  }): id = uuid.v4();
}
