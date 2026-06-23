// ignore_for_file: file_names

class AppStrings {
  // Common
  static const String priorityHigh = 'High';
  static const String priorityMedium = 'Medium';
  static const String priorityLow = 'Low';
  static const String statusAll = 'All';
  static const String statusCompleted = 'Completed';
  static const String statusUncompleted = 'Uncompleted';
  static const String statusPending = 'Pending';
  static const String undo = 'Undo';

  // Task Form Page
  static const String editTask = 'Edit Task';
  static const String newTask = 'New Task';
  static const String titleLabel = 'Title';
  static const String titleHint = 'Enter task title...';
  static const String titleValidation = 'Please enter a title';
  static const String descriptionLabel = 'Description';
  static const String descriptionHint = 'Describe this task...';
  static const String dueDate = 'Due Date';
  static const String priority = 'Priority';
  static const String saveChanges = 'Save Changes';
  static const String createTask = 'Create Task';

  // Task List Page
  static const String taskSpace = 'Task Space';
  static const String searchHint = 'Search tasks...';
  static const String status = 'Status';
  static const String noTasksFound = 'No tasks found';
  static const String tryCreatingTask = 'Try creating a task or changing your search filters.';
  static const String addTask = 'Add Task';

  static String taskDeleted(String title) => '"$title" deleted';
  static String errorLoadingTasks(String error) => 'Error loading tasks: $error';
}
