import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/task_usecases.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  TaskCubit({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
  }) : super(const TaskState());

  Future<void> loadTasks() async {
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      final tasks = await getTasksUseCase();
      emit(state.copyWith(
        status: TaskStatus.success,
        tasks: tasks,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TaskStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> addTask(TaskEntity task) async {
    try {
      await addTaskUseCase(task);
      await loadTasks();
    } catch (e) {
      emit(state.copyWith(
        status: TaskStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    try {
      await updateTaskUseCase(task);
      await loadTasks();
    } catch (e) {
      emit(state.copyWith(
        status: TaskStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> toggleTaskCompletion(TaskEntity task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(updatedTask);
  }

  Future<void> deleteTask(String id) async {
    try {
      await deleteTaskUseCase(id);
      await loadTasks();
    } catch (e) {
      emit(state.copyWith(
        status: TaskStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setStatusFilter(String filter) {
    emit(state.copyWith(statusFilter: filter));
  }

  void setPriorityFilter(String filter) {
    emit(state.copyWith(priorityFilter: filter));
  }
}
