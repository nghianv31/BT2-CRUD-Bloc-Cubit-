import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task_entity.dart';
import '../../core/values/AppStrings.dart';
import '../bloc/task_cubit.dart';

class TaskFormPage extends StatefulWidget {
  final TaskEntity? task;

  const TaskFormPage({super.key, this.task});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _dueDate;
  late String _priority;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _description = widget.task?.description ?? '';
    _dueDate = widget.task?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    _priority = widget.task?.priority ?? AppStrings.priorityMedium;
    _isCompleted = widget.task?.isCompleted ?? false;
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2575FC),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      
      final taskId = widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
      final newTask = TaskEntity(
        id: taskId,
        title: _title,
        description: _description,
        dueDate: _dueDate,
        isCompleted: _isCompleted,
        priority: _priority,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
      );

      final cubit = context.read<TaskCubit>();
      if (widget.task == null) {
        cubit.addTask(newTask);
      } else {
        cubit.updateTask(newTask);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    final formattedDate = DateFormat('EEEE, MMM dd, yyyy').format(_dueDate);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: _buildAppBar(isEditing),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleField(),
                const SizedBox(height: 16),
                _buildDescriptionField(),
                const SizedBox(height: 16),
                _buildDateSelector(context, formattedDate),
                const SizedBox(height: 16),
                _buildPrioritySelector(),
                const SizedBox(height: 40),
                _buildSaveButton(isEditing),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }

  PreferredSizeWidget _buildAppBar(bool isEditing) {
    return AppBar(
      title: Text(isEditing ? AppStrings.editTask : AppStrings.newTask, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.black87,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget _buildTitleField() {
    return _buildCardSection(
      child: TextFormField(
        initialValue: _title,
        decoration: const InputDecoration(
          labelText: AppStrings.titleLabel,
          hintText: AppStrings.titleHint,
          border: InputBorder.none,
          prefixIcon: Icon(Icons.title_rounded, color: Color(0xFF2575FC)),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return AppStrings.titleValidation;
          }
          return null;
        },
        onSaved: (value) => _title = value?.trim() ?? '',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return _buildCardSection(
      child: TextFormField(
        initialValue: _description,
        maxLines: 4,
        decoration: const InputDecoration(
          labelText: AppStrings.descriptionLabel,
          hintText: AppStrings.descriptionHint,
          border: InputBorder.none,
          prefixIcon: Icon(Icons.description_outlined, color: Color(0xFF2575FC)),
        ),
        onSaved: (value) => _description = value?.trim() ?? '',
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, String formattedDate) {
    return GestureDetector(
      onTap: () => _selectDueDate(context),
      child: _buildCardSection(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_rounded, color: Color(0xFF2575FC)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.dueDate,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.black38),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            AppStrings.priority,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        Row(
          children: [
            Expanded(child: _buildPriorityChip(AppStrings.priorityLow, Colors.green)),
            const SizedBox(width: 8),
            Expanded(child: _buildPriorityChip(AppStrings.priorityMedium, Colors.amber)),
            const SizedBox(width: 8),
            Expanded(child: _buildPriorityChip(AppStrings.priorityHigh, Colors.redAccent)),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton(bool isEditing) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _saveTask,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: const Color(0xFF2575FC).withValues(alpha: 0.4),
          elevation: 8,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              isEditing ? AppStrings.saveChanges : AppStrings.createTask,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardSection({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildPriorityChip(String level, Color color) {
    final isSelected = _priority == level;
    return GestureDetector(
      onTap: () {
        setState(() {
          _priority = level;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            level,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
