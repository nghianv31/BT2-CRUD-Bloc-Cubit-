import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

enum TaskStatus { initial, loading, success, failure }

class TaskState extends Equatable {
  final TaskStatus status;
  final List<TaskEntity> tasks;
  final String searchQuery;
  final String statusFilter; // 'All', 'Completed', 'Uncompleted'
  final String priorityFilter; // 'All', 'Low', 'Medium', 'High'
  final String sortBy; // 'DueDate', 'CreatedAt', 'Priority', 'Title'
  final bool sortAscending;
  final String? errorMessage;

  const TaskState({
    this.status = TaskStatus.initial,
    this.tasks = const [],
    this.searchQuery = '',
    this.statusFilter = 'All',
    this.priorityFilter = 'All',
    this.sortBy = 'CreatedAt',
    this.sortAscending = false,
    this.errorMessage,
  });

  // Helper/Derived list of tasks matching the active filters, search query, and sorting
  List<TaskEntity> get filteredTasks {
    final filtered = tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(searchQuery.toLowerCase());
      
      final matchesStatus = statusFilter == 'All' ||
          (statusFilter == 'Completed' && task.isCompleted) ||
          (statusFilter == 'Uncompleted' && !task.isCompleted);

      final matchesPriority = priorityFilter == 'All' ||
          task.priority == priorityFilter;

      return matchesSearch && matchesStatus && matchesPriority;
    }).toList();

    filtered.sort((a, b) {
      int comparison = 0;
      switch (sortBy) {
        case 'DueDate':
          comparison = a.dueDate.compareTo(b.dueDate);
          break;
        case 'Priority':
          final weightA = _getPriorityWeight(a.priority);
          final weightB = _getPriorityWeight(b.priority);
          comparison = weightA.compareTo(weightB);
          break;
        case 'Title':
          comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
          break;
        case 'CreatedAt':
        default:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
      }
      return sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  int _getPriorityWeight(String priority) {
    switch (priority) {
      case 'High':
        return 3;
      case 'Medium':
        return 2;
      case 'Low':
      default:
        return 1;
    }
  }

  TaskState copyWith({
    TaskStatus? status,
    List<TaskEntity>? tasks,
    String? searchQuery,
    String? statusFilter,
    String? priorityFilter,
    String? sortBy,
    bool? sortAscending,
    String? errorMessage,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      priorityFilter: priorityFilter ?? this.priorityFilter,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
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
        sortBy,
        sortAscending,
        errorMessage,
      ];
}
