import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/subjects/domain/entities/grade_category_entity.dart';
import 'package:tempus/features/subjects/domain/entities/subject_detail_entity.dart';
import 'package:tempus/features/subjects/domain/entities/subject_entity.dart';
import 'package:tempus/features/subjects/presentation/bloc/subject_detail/subject_detail_bloc.dart';
import 'package:tempus/features/subjects/presentation/widgets/add_category_sheet.dart';
import 'package:tempus/features/subjects/presentation/widgets/category_tile.dart';

final _fakeDetail = SubjectDetailEntity(
  subject: const SubjectEntity(
    id: 0,
    name: 'Loading Subject Name',
    code: 'LOAD 1',
    instructor: 'Loading Instructor',
    units: 3,
  ),
  categories: const [
    GradeCategoryEntity(id: 1, name: 'Loading Category', weight: 40),
    GradeCategoryEntity(id: 2, name: 'Loading Category', weight: 30),
    GradeCategoryEntity(id: 3, name: 'Loading Category', weight: 30),
  ],
);

class SubjectDetailPage extends StatefulWidget {
  final SubjectEntity subject;

  const SubjectDetailPage({super.key, required this.subject});

  @override
  State<SubjectDetailPage> createState() => _SubjectDetailPageState();
}

class _SubjectDetailPageState extends State<SubjectDetailPage> {
  bool _isEditing = false;

  // Subject field controllers
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _instructorController;
  late final TextEditingController _unitsController;

  // Category edit controllers: categoryId -> {name, weight}
  final Map<int, TextEditingController> _catNameControllers = {};
  final Map<int, TextEditingController> _catWeightControllers = {};

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject.name);
    _codeController = TextEditingController(text: widget.subject.code);
    _instructorController = TextEditingController(text: widget.subject.instructor);
    _unitsController = TextEditingController(text: widget.subject.units.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _instructorController.dispose();
    _unitsController.dispose();
    for (final c in _catNameControllers.values) c.dispose();
    for (final c in _catWeightControllers.values) c.dispose();
    super.dispose();
  }

  void _syncCategoryControllers(List<GradeCategoryEntity> categories) {
    for (final cat in categories) {
      if (!_catNameControllers.containsKey(cat.id)) {
        _catNameControllers[cat.id] = TextEditingController(text: cat.name);
        _catWeightControllers[cat.id] = TextEditingController(
          text: cat.weight % 1 == 0
              ? cat.weight.toStringAsFixed(0)
              : cat.weight.toStringAsFixed(1),
        );
      }
    }
    // Remove controllers for deleted categories
    final ids = categories.map((c) => c.id).toSet();
    _catNameControllers.removeWhere((id, c) {
      if (!ids.contains(id)) {
        c.dispose();
        return true;
      }
      return false;
    });
    _catWeightControllers.removeWhere((id, c) {
      if (!ids.contains(id)) {
        c.dispose();
        return true;
      }
      return false;
    });
  }

  void _enterEditMode(SubjectDetailEntity detail) {
    _nameController.text = detail.subject.name;
    _codeController.text = detail.subject.code;
    _instructorController.text = detail.subject.instructor;
    _unitsController.text = detail.subject.units.toString();
    _syncCategoryControllers(detail.categories);
    setState(() => _isEditing = true);
  }

  void _cancelEdit() {
    setState(() => _isEditing = false);
  }

  void _saveChanges(BuildContext context, SubjectDetailEntity detail) {
    if (!_formKey.currentState!.validate()) return;

    final updatedSubject = detail.subject.copyWith(
      name: _nameController.text.trim(),
      code: _codeController.text.trim(),
      instructor: _instructorController.text.trim(),
      units: int.parse(_unitsController.text.trim()),
    );

    context
        .read<SubjectDetailBloc>()
        .add(SubjectDetailSubjectUpdateRequested(updatedSubject));

    // Update each category that changed
    for (final cat in detail.categories) {
      final newName = _catNameControllers[cat.id]?.text.trim() ?? cat.name;
      final newWeight =
          double.tryParse(_catWeightControllers[cat.id]?.text.trim() ?? '') ??
              cat.weight;

      if (newName != cat.name || newWeight != cat.weight) {
        context.read<SubjectDetailBloc>().add(
              SubjectDetailCategoryUpdateRequested(
                cat.id,
                newName,
                newWeight,
              ),
            );
      }
    }

    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubjectDetailBloc, SubjectDetailState>(
      listenWhen: (prev, curr) =>
          curr is SubjectDetailLoaded &&
          (curr.savedSuccessfully || curr.saveError),
      listener: (context, state) {
        if (state is SubjectDetailLoaded && state.savedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 18),
                  Gap(8),
                  Text('Changes saved',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white)),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        if (state is SubjectDetailLoaded && state.saveError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to save changes'),
              backgroundColor: AppColors.destructive,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading =
            state is SubjectDetailInitial || state is SubjectDetailLoading;
        final detail =
            state is SubjectDetailLoaded ? state.detail : _fakeDetail;

        if (state is SubjectDetailLoaded && _isEditing) {
          _syncCategoryControllers(detail.categories);
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: _isEditing
                ? IconButton(
                    icon: const Icon(Icons.close, color: AppColors.text),
                    onPressed: _cancelEdit,
                  )
                : IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: AppColors.text),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
            title: _isEditing
                ? const Text(
                    'Edit Subject',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.subject.code,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.brandBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        detail.subject.name,
                        style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
            actions: [
              if (!isLoading && !_isEditing)
                TextButton.icon(
                  onPressed: () => _enterEditMode(detail),
                  icon: const Icon(Icons.edit_outlined,
                      size: 16, color: AppColors.brandBlue),
                  label: const Text(
                    'Edit',
                    style: TextStyle(
                        color: AppColors.brandBlue,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              if (_isEditing)
                TextButton(
                  onPressed: () => _saveChanges(context, detail),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.brandBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
            ],
          ),
          body: switch (state) {
            SubjectDetailError(:final message) =>
              Center(child: Text(message)),
            _ => Skeletonizer(
                enabled: isLoading,
                child: _isEditing
                    ? _EditContent(
                        detail: detail,
                        formKey: _formKey,
                        nameController: _nameController,
                        codeController: _codeController,
                        instructorController: _instructorController,
                        unitsController: _unitsController,
                        catNameControllers: _catNameControllers,
                        catWeightControllers: _catWeightControllers,
                        onAddCategory: () => _showAddCategorySheet(context),
                        onDeleteCategory: (catId) {
                          context.read<SubjectDetailBloc>().add(
                                SubjectDetailCategoryDeleteRequested(catId),
                              );
                          _catNameControllers.remove(catId)?.dispose();
                          _catWeightControllers.remove(catId)?.dispose();
                        },
                        onSave: () => _saveChanges(context, detail),
                      )
                    : _ViewContent(
                        detail: detail,
                        isLoading: isLoading,
                        onAddCategory: () => _showAddCategorySheet(context),
                        onDeleteCategory: (catId) =>
                            context.read<SubjectDetailBloc>().add(
                                  SubjectDetailCategoryDeleteRequested(catId),
                                ),
                        onEnterEdit: () => _enterEditMode(detail),
                      ),
              ),
          },
        );
      },
    );
  }

  void _showAddCategorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<SubjectDetailBloc>(),
        child: const AddCategorySheet(),
      ),
    );
  }
}

class _ViewContent extends StatelessWidget {
  final SubjectDetailEntity detail;
  final bool isLoading;
  final VoidCallback onAddCategory;
  final void Function(int catId) onDeleteCategory;
  final VoidCallback onEnterEdit;

  const _ViewContent({
    required this.detail,
    required this.isLoading,
    required this.onAddCategory,
    required this.onDeleteCategory,
    required this.onEnterEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isOver100 = detail.totalWeight > 100;
    final isExact100 = (detail.totalWeight - 100).abs() < 0.01;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _EstimatedGradeCard(detail: detail),
        const Gap(20),
        const Text(
          'Active Categories',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground),
        ),
        const Gap(12),
        if (detail.categories.isEmpty)
          _EmptyCategories()
        else
          ...detail.categories.map(
            (cat) => CategoryTile(
              category: cat,
              onDelete: () {
                if (isLoading) return;
                onDeleteCategory(cat.id);
              },
            ),
          ),
        _InfoCard(),
        const Gap(16),
        _WeightInfoCard(
          totalWeight: detail.totalWeight,
          isExact100: isExact100,
          isOver100: isOver100,
        ),
      ],
    );
  }
}

class _EditContent extends StatelessWidget {
  final SubjectDetailEntity detail;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController codeController;
  final TextEditingController instructorController;
  final TextEditingController unitsController;
  final Map<int, TextEditingController> catNameControllers;
  final Map<int, TextEditingController> catWeightControllers;
  final VoidCallback onAddCategory;
  final void Function(int catId) onDeleteCategory;
  final VoidCallback onSave;

  const _EditContent({
    required this.detail,
    required this.formKey,
    required this.nameController,
    required this.codeController,
    required this.instructorController,
    required this.unitsController,
    required this.catNameControllers,
    required this.catWeightControllers,
    required this.onAddCategory,
    required this.onDeleteCategory,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          _SectionHeader(label: 'Subject Info'),
          const Gap(12),
          _EditCard(
            child: Column(
              children: [
                _EditField(
                  label: 'Subject Name',
                  controller: nameController,
                  hint: 'e.g. Data Structures and Algorithms',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                  textCapitalization: TextCapitalization.words,
                ),
                _FieldDivider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _EditField(
                        label: 'Subject Code',
                        controller: codeController,
                        hint: 'e.g. CIS 2101',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                    _VerticalDivider(),
                    Expanded(
                      flex: 2,
                      child: _EditField(
                        label: 'Units',
                        controller: unitsController,
                        hint: '3',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (int.tryParse(v.trim()) == null) return 'Invalid';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                _FieldDivider(),
                _EditField(
                  label: 'Instructor',
                  controller: instructorController,
                  hint: 'e.g. Christine Pena',
                  textCapitalization: TextCapitalization.words,
                  isLast: true,
                ),
              ],
            ),
          ),

          const Gap(24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SectionHeader(label: 'Grade Categories'),
              GestureDetector(
                onTap: onAddCategory,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.brandBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 14, color: Colors.white),
                      Gap(4),
                      Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),

          if (detail.categories.isEmpty)
            _EditCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.category_outlined,
                          size: 36,
                          color:
                              AppColors.foreground.withValues(alpha: 0.4)),
                      const Gap(8),
                      const Text(
                        'No categories yet. Tap Add to create one.',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.foreground),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            _EditCard(
              child: Column(
                children: [
                  for (int i = 0; i < detail.categories.length; i++) ...[
                    _CategoryEditRow(
                      category: detail.categories[i],
                      nameController:
                          catNameControllers[detail.categories[i].id]!,
                      weightController:
                          catWeightControllers[detail.categories[i].id]!,
                      onDelete: () =>
                          onDeleteCategory(detail.categories[i].id),
                    ),
                    if (i < detail.categories.length - 1) _FieldDivider(),
                  ],
                ],
              ),
            ),

          const Gap(16),
          _WeightSummaryBar(categories: detail.categories),

          const Gap(32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Save Changes',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.foreground,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _EditCard extends StatelessWidget {
  final Widget child;
  const _EditCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FieldDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(
        height: 1,
        thickness: 0.5,
        color: Colors.grey.shade100,
        indent: 16,
        endIndent: 16,
      );
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 56,
        color: Colors.grey.shade100,
      );
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final bool autofocus;
  final bool isLast;

  const _EditField({
    required this.label,
    required this.controller,
    required this.hint,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.autofocus = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
              letterSpacing: 0.3,
            ),
          ),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            textCapitalization: textCapitalization,
            textInputAction: textInputAction,
            autofocus: autofocus,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppColors.foreground,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryEditRow extends StatelessWidget {
  final GradeCategoryEntity category;
  final TextEditingController nameController;
  final TextEditingController weightController;
  final VoidCallback onDelete;

  const _CategoryEditRow({
    required this.category,
    required this.nameController,
    required this.weightController,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.brandBlue,
            ),
          ),
          const Gap(12),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                    letterSpacing: 0.3,
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),
          SizedBox(
            width: 64,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weight',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                    letterSpacing: 0.3,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: weightController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.text,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Req.';
                          final d = double.tryParse(v.trim());
                          if (d == null || d <= 0 || d > 100) return '1-100';
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                    ),
                    const Text(
                      '%',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.foreground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(8),
          GestureDetector(
            onTap: onDelete,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: AppColors.destructive.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightSummaryBar extends StatelessWidget {
  final List<GradeCategoryEntity> categories;
  const _WeightSummaryBar({required this.categories});

  @override
  Widget build(BuildContext context) {
    final total = categories.fold<double>(0, (s, c) => s + c.weight);
    final isExact = (total - 100).abs() < 0.01;
    final isOver = total > 100;

    final color = isOver
        ? AppColors.destructive
        : isExact
            ? const Color(0xFF0E9F6E)
            : const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            isOver
                ? Icons.error_outline
                : isExact
                    ? Icons.check_circle_outline
                    : Icons.info_outline,
            size: 16,
            color: color,
          ),
          const Gap(8),
          Expanded(
            child: Text(
              isOver
                  ? 'Total weight ${total.toStringAsFixed(0)}% exceeds 100%'
                  : isExact
                      ? 'Total weight is exactly 100% ✓'
                      : 'Total weight: ${total.toStringAsFixed(0)}% — ${(100 - total).toStringAsFixed(0)}% remaining',
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _EstimatedGradeCard extends StatelessWidget {
  final SubjectDetailEntity detail;

  const _EstimatedGradeCard({required this.detail});

  Color _gradeColor(double grade) {
    if (grade == 0.0) return AppColors.foreground; // no data
    if (grade <= 2.0) return AppColors.success;
    if (grade <= 3.0) return const Color(0xFFF59E0B);
    return AppColors.destructive; // 5.0 failing
  }

  String _gradeLabel(double grade) {
    if (grade == 0.0) return '--';
    return grade.toStringAsFixed(2);
  }

  String _gradeRemark(double grade) {
    if (grade == 0.0) return 'Add scores to see your estimate';
    if (grade <= 1.50) return 'Excellent';
    if (grade <= 2.00) return 'Very Good';
    if (grade <= 2.50) return 'Good';
    if (grade <= 3.00) return 'Passing';
    return 'Failed';
  }

  @override
  Widget build(BuildContext context) {
    final grade = detail.estimatedGrade;
    final pct = detail.estimatedPercent;
    final color = _gradeColor(grade);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.inputFill.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          // Ring indicator
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  _gradeLabel(grade),
                  style: TextStyle(
                    fontSize: grade == 0.0 ? 14 : 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),

          const Gap(20),

          // Labels
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Estimated Grade',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.foreground,
                  ),
                ),
                const Gap(4),
                Text(
                  _gradeRemark(grade),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: grade == 0.0 ? AppColors.foreground : color,
                  ),
                ),
                if (grade != 0.0) ...[
                  const Gap(4),
                  Text(
                    '${pct.toStringAsFixed(1)}% weighted average',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.foreground,
                    ),
                  ),
                ],
                if (grade == 0.0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Add scores to see your estimate',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.foreground,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(Icons.category_outlined,
              size: 48,
              color: AppColors.foreground.withValues(alpha: 0.4)),
          const Gap(12),
          const Text(
            'No grade categories yet',
            style: TextStyle(color: AppColors.foreground, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: AppColors.brandBlue.withValues(alpha: 0.5)),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 1,
            child: Icon(Icons.info_outline,
                color: AppColors.brandBlue, size: 20),
          ),
          Expanded(
            flex: 4,
            child: Text(
              'Grades use the Philippine university scale (1.0–5.0). '
              '1.0 is the highest, 3.0 is the minimum passing grade, '
              'and 5.0 is failing. Ensure all category weights total 100%.',
              style:
                  TextStyle(fontSize: 12, color: AppColors.brandBlue),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightInfoCard extends StatelessWidget {
  final double totalWeight;
  final bool isExact100;
  final bool isOver100;

  const _WeightInfoCard({
    required this.totalWeight,
    required this.isExact100,
    required this.isOver100,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = isOver100
        ? AppColors.destructive
        : isExact100
            ? const Color(0xFF0E9F6E)
            : const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.inputFill.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            spacing: 4,
            children: [
              const Text(
                'Total Weight',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              ),
              const Spacer(),
              Text(
                '${totalWeight.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      isOver100 ? AppColors.destructive : AppColors.text,
                ),
              ),
            ],
          ),
          if (!isExact100 && isOver100) ...[
            const Gap(12),
            const Divider(height: 1),
            const Gap(12),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.error_outline,
                    size: 16, color: AppColors.destructive),
                Gap(8),
                Expanded(
                  child: Text(
                    'Total weight exceeds 100%. Please adjust category weights.',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.destructive),
                  ),
                ),
              ],
            ),
          ],
          if (!isOver100 && !isExact100) ...[
            const Gap(12),
            Row(
              children: [
                const Icon(Icons.warning_amber_outlined,
                    size: 14, color: AppColors.destructive),
                const Gap(6),
                Text(
                  'Missing ${(totalWeight - 100).abs().toStringAsFixed(0)}% to reach full allocation',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.destructive,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}