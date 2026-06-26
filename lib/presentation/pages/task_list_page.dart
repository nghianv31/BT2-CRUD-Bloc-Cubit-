import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_cubit.dart';
import '../bloc/task_state.dart';
import '../../core/values/AppStrings.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/task_card_widget.dart';
import 'task_form_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().loadTasks();
    _searchController.addListener(() {
      context.read<TaskCubit>().setSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            _buildSearchBarAndFilterSection(),
            _buildTaskListSection(),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 110.0,
      floating: false,
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.sort_rounded, color: Colors.white),
          onPressed: () => _showSortBottomSheet(context),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
        title: const Text(
          AppStrings.taskSpace,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              Positioned(
                left: -20,
                bottom: 20,
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBarAndFilterSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchField(),
            const SizedBox(height: 16.0),
            _buildStatusFilter(),
            const SizedBox(height: 16.0),
            _buildPriorityFilter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF2575FC)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.status,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8.0),
        BlocBuilder<TaskCubit, TaskState>(
          buildWhen: (previous, current) => previous.statusFilter != current.statusFilter,
          builder: (context, state) {
            return Row(
              children: [
                FilterChipWidget(
                  value: AppStrings.statusAll,
                  selectedValue: state.statusFilter,
                  onSelected: (val) => context.read<TaskCubit>().setStatusFilter(val),
                ),
                const SizedBox(width: 8.0),
                FilterChipWidget(
                  value: AppStrings.statusCompleted,
                  selectedValue: state.statusFilter,
                  onSelected: (val) => context.read<TaskCubit>().setStatusFilter(val),
                  displayName: AppStrings.statusCompleted,
                ),
                const SizedBox(width: 8.0),
                FilterChipWidget(
                  value: AppStrings.statusUncompleted,
                  selectedValue: state.statusFilter,
                  onSelected: (val) => context.read<TaskCubit>().setStatusFilter(val),
                  displayName: AppStrings.statusPending,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildPriorityFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.priority,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8.0),
        BlocBuilder<TaskCubit, TaskState>(
          buildWhen: (previous, current) => previous.priorityFilter != current.priorityFilter,
          builder: (context, state) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChipWidget(
                    value: AppStrings.statusAll,
                    selectedValue: state.priorityFilter,
                    onSelected: (val) => context.read<TaskCubit>().setPriorityFilter(val),
                    prefixColor: Colors.grey,
                  ),
                  const SizedBox(width: 8.0),
                  FilterChipWidget(
                    value: AppStrings.priorityHigh,
                    selectedValue: state.priorityFilter,
                    onSelected: (val) => context.read<TaskCubit>().setPriorityFilter(val),
                    prefixColor: Colors.redAccent,
                  ),
                  const SizedBox(width: 8.0),
                  FilterChipWidget(
                    value: AppStrings.priorityMedium,
                    selectedValue: state.priorityFilter,
                    onSelected: (val) => context.read<TaskCubit>().setPriorityFilter(val),
                    prefixColor: Colors.amber,
                  ),
                  const SizedBox(width: 8.0),
                  FilterChipWidget(
                    value: AppStrings.priorityLow,
                    selectedValue: state.priorityFilter,
                    onSelected: (val) => context.read<TaskCubit>().setPriorityFilter(val),
                    prefixColor: Colors.green,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTaskListSection() {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state.status == TaskStatus.loading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2575FC)),
              ),
            ),
          );
        }

        if (state.status == TaskStatus.failure) {
          return SliverFillRemaining(
            child: Center(
              child: Text(AppStrings.errorLoadingTasks(state.errorMessage ?? '')),
            ),
          );
        }

        final tasks = state.filteredTasks;

        if (tasks.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.noTasksFound,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.tryCreatingTask,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 80.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final task = tasks[index];
                return TaskCardWidget(task: task);
              },
              childCount: tasks.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TaskFormPage(),
          ),
        );
      },
      label: const Text(AppStrings.addTask, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      icon: const Icon(Icons.add, color: Colors.white),
      backgroundColor: const Color(0xFF2575FC),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            final options = [
              {'label': 'Date Created (Newest)', 'sortBy': 'CreatedAt', 'ascending': false},
              {'label': 'Date Created (Oldest)', 'sortBy': 'CreatedAt', 'ascending': true},
              {'label': 'Priority (High -> Low)', 'sortBy': 'Priority', 'ascending': false},
              {'label': 'Priority (Low -> High)', 'sortBy': 'Priority', 'ascending': true},
              {'label': 'Title (A -> Z)', 'sortBy': 'Title', 'ascending': true},
              {'label': 'Title (Z -> A)', 'sortBy': 'Title', 'ascending': false},
            ];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sort Tasks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final opt = options[index];
                        final isSelected = state.sortBy == opt['sortBy'] &&
                            state.sortAscending == opt['ascending'];

                        return ListTile(
                          title: Text(
                            opt['label'] as String,
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF2575FC) : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_rounded, color: Color(0xFF2575FC))
                              : null,
                          onTap: () {
                            context.read<TaskCubit>().setSortBy(
                                  opt['sortBy'] as String,
                                  opt['ascending'] as bool,
                                );
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
