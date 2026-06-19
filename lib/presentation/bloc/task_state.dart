import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

enum TaskStatus { initial, loading, success, failure }

class TaskState extends Equatable {
  final TaskStatus status;
  final List<TaskEntity> tasks;
  final String searchQuery;
  final String statusFilter; // 'All', 'Completed', 'Uncompleted'
  final String priorityFilter; // 'All', 'Low', 'Medium', 'High'
  final String? errorMessage;

  const TaskState({
    this.status = TaskStatus.initial,
    this.tasks = const [],
    this.searchQuery = '',
    this.statusFilter = 'All',
    this.priorityFilter = 'All',
    this.errorMessage,
  });

  // Helper/Derived list of tasks matching the active filters & search query
  List<TaskEntity> get filteredTasks {
    return tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(searchQuery.toLowerCase());
      
      final matchesStatus = statusFilter == 'All' ||
          (statusFilter == 'Completed' && task.isCompleted) ||
          (statusFilter == 'Uncompleted' && !task.isCompleted);

      final matchesPriority = priorityFilter == 'All' ||
          task.priority == priorityFilter;

      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();
  }

  TaskState copyWith({
    TaskStatus? status,
    List<TaskEntity>? tasks,
    String? searchQuery,
    String? statusFilter,
    String? priorityFilter,
    String? errorMessage,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      priorityFilter: priorityFilter ?? this.priorityFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        tasks,
        searchQuery,
        statusFilter,
        priorityFilter,
        errorMessage,
      ];
}
