import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_flow/core/config/app_colors.dart';
import 'package:task_flow/core/config/app_constants.dart';
import 'package:task_flow/core/utils/date_utils.dart';
import 'package:task_flow/core/utils/responsive_utils.dart';
import 'package:task_flow/data/models/task_model.dart';
import 'package:task_flow/presentation/common/widgets/custom_app_bar.dart';
import 'package:task_flow/presentation/common/widgets/custom_button.dart';
import 'package:task_flow/presentation/common/widgets/custom_text_field.dart';
import 'package:task_flow/presentation/task/add_edit_task_viewmodel.dart';
import 'package:task_flow/presentation/task/widgets/priority_selector.dart';

/// Add/Edit Task screen
class AddEditTaskScreen extends StatelessWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = AddEditTaskViewModel();
        if (task != null) {
          viewModel.initializeWithTask(task!);
        }
        return viewModel;
      },
      child: const _AddEditTaskScreenContent(),
    );
  }
}

class _AddEditTaskScreenContent extends StatefulWidget {
  const _AddEditTaskScreenContent();

  @override
  State<_AddEditTaskScreenContent> createState() =>
      _AddEditTaskScreenContentState();
}

class _AddEditTaskScreenContentState extends State<_AddEditTaskScreenContent> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<AddEditTaskViewModel>();
      _titleController.text = viewModel.title;
      _descriptionController.text = viewModel.description;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddEditTaskViewModel>();
    final screenHeight = ResponsiveUtils.screenHeight(context);
    final screenWidth = ResponsiveUtils.screenWidth(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: viewModel.isEditMode ? 'Edit Task' : 'Add Task',
        actions: viewModel.isEditMode
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _showDeleteConfirmation(context, viewModel),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: AppConstants.paddingLarge,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task Title
                CustomTextField(
                  label: 'Task Title',
                  hint: 'Enter task title',
                  controller: _titleController,
                  onChanged: viewModel.setTitle,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppConstants.paddingLarge),

                // Description
                CustomTextField(
                  label: 'Description',
                  hint: 'Enter task description (optional)',
                  controller: _descriptionController,
                  maxLines: 4,
                  onChanged: viewModel.setDescription,
                ),

                const SizedBox(height: AppConstants.paddingLarge),

                // Due Date & Time
                const Text(
                  'Due Date',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingSmall),

                GestureDetector(
                  onTap: () => viewModel.selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMedium,
                      ),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppConstants.paddingSmall),
                        const Icon(
                          Icons.access_time,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppConstants.paddingSmall),
                        Expanded(
                          child: Text(
                            DateTimeUtils.formatTaskDateTime(
                              viewModel.combinedDateTime,
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.paddingLarge),

                // Priority Selector
                PrioritySelector(
                  selectedPriority: viewModel.priority,
                  onPriorityChanged: viewModel.setPriority,
                ),

                SizedBox(height: screenHeight * 0.04),

                // Save Button
                CustomButton(
                  text: viewModel.isEditMode ? 'Save Task' : 'Create Task',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      viewModel.saveTask(context);
                    }
                  },
                  variant: ButtonVariant.primary,
                ),

                if (viewModel.isEditMode) ...[
                  const SizedBox(height: AppConstants.paddingMedium),

                  // Delete Button
                  CustomButton(
                    text: 'Delete Task',
                    onPressed: () =>
                        _showDeleteConfirmation(context, viewModel),
                    variant: ButtonVariant.danger,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    AddEditTaskViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.deleteTask(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
