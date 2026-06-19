import 'package:flutter_test/flutter_test.dart';
import 'package:bt2_bloc/main.dart';
import 'package:bt2_bloc/domain/entities/task_entity.dart';
import 'package:bt2_bloc/domain/repositories/task_repository.dart';
import 'package:bt2_bloc/domain/usecases/task_usecases.dart';

class MockTaskRepository implements TaskRepository {
  @override
  Future<List<TaskEntity>> getTasks() async => [];
  
  @override
  Future<void> addTask(TaskEntity task) async {}
  
  @override
  Future<void> updateTask(TaskEntity task) async {}
  
  @override
  Future<void> deleteTask(String id) async {}
}

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    final repo = MockTaskRepository();
    final getTasks = GetTasksUseCase(repo);
    final addTask = AddTaskUseCase(repo);
    final updateTask = UpdateTaskUseCase(repo);
    final deleteTask = DeleteTaskUseCase(repo);

    await tester.pumpWidget(
      MyApp(
        getTasksUseCase: getTasks,
        addTaskUseCase: addTask,
        updateTaskUseCase: updateTask,
        deleteTaskUseCase: deleteTask,
      ),
    );

    // Verify that the screen has loaded
    expect(find.text('Task Space'), findsWidgets);
  });
}
