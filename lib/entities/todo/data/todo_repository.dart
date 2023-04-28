import 'dart:async';

import 'package:todo/entities/todo/models/todo.dart';

abstract class ITodoRepository {
  FutureOr<List<ITodo>> getAll();
  FutureOr<void> setAll(List<ITodo> todos);

  FutureOr<void> set(ITodo todo);
  FutureOr<void> get(String id);
}
