import 'package:hive/hive.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> addTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  static const String boxName = 'tasks_box';

  Future<Box<TaskModel>> _getBox() async {
    return await Hive.openBox<TaskModel>(boxName);
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    final box = await _getBox();
    return box.values.toList();
  }

  @override
  Future<void> addTask(TaskModel task) async {
    final box = await _getBox();
    await box.put(task.id, task);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final box = await _getBox();
    await box.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
