import 'package:flutter/material.dart';
import 'package:todopushnotification/models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  final List<TodoModel> td = [];
  List<TodoModel> get todo => td;

  void addTodo(TodoModel t) {
    todo.add(t);

    notifyListeners();
  }

  void deleteTodo(TodoModel t) {
    todo.remove(t);

    notifyListeners();
  }
}
