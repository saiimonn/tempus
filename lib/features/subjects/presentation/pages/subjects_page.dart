import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/subjects/logic/subject_bloc.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubjectBloc()..add(LoadSubjects()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<SubjectBloc, SubjectState>(
          builder: (context, state) {
            if (state is SubjectLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.brandBlue),
              );
            }

            if (state is SubjectLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: state.subjects.length + 1,
                itemBuilder: (context, index) {
                  
                  if(index == state.subjects.length) {
                    return _buildAddSubjectCard(context);
                  }
                  
                  final subject = state.subjects[index];

                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: AppColors.inputFill.withValues(alpha: 0.5),
                      ),
                    ),
                    
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${subject['code']}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.brandBlue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                 
                                 Text(
                                   "${subject['name']}",
                                   style: TextStyle(
                                     fontSize: 20,
                                     color: AppColors.text,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                                 
                                 Text(
                                   "${subject['units']} units",
                                   style: TextStyle(
                                     fontSize: 12,
                                     color: AppColors.foreground,
                                   ),
                                 ),
                                ],
                              ),
                              
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircularProgressIndicator(
                                      value: 0.92,
                                      strokeWidth: 6,
                                      color: AppColors.success,
                                      backgroundColor: Colors.grey.shade200,
                                    ),
                                  ),
                                  
                                  Text(
                                    "92%",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.success,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Divider(
                            color: Colors.grey.withAlpha(80),
                            height: 1
                          ),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "View",
                                  style: TextStyle(color: AppColors.brandBlue),
                                ),
                              ),
                              
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Manage Grading", 
                                  style: TextStyle(color: AppColors.brandBlue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Center(child: Text("No Subjects Found"));
          },
        ),
      ),
    );
  }

  Widget _buildAddSubjectCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => _AddSubjectBottomSheet(),
          );
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade400,
              style: BorderStyle.solid,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add, 
                size:32, 
                color: Colors.blueGrey.shade400
              ),

              const SizedBox(height: 8),

              Text(
                "Add Subject",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddSubjectBottomSheet extends StatefulWidget {
  const _AddSubjectBottomSheet({super.key});

  @override
  State<_AddSubjectBottomSheet> createState() =>
      _AddSubjectBottomSheetState();
}

class _AddSubjectBottomSheetState
    extends State<_AddSubjectBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _profController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _profController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final newSubject = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': _nameController.text.trim(),
      'code': _codeController.text.trim(),
      'instructor': _profController.text.trim(), // match bloc mock key
      'units': int.parse(_unitsController.text.trim()),
      'grades': {
        'prelim': '--',
        'midterm': '--',
        'final': '--',
      }
    };

    context.read<SubjectBloc>().add(AddSubject(newSubject));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Drag indicator
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                Text(
                  "Add Subject",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration("Subject Name", "e.g. Data Structures and Algorithms"),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _profController,
                  decoration: _inputDecoration("Instructor", "e.g. Christine Pena"),
                ),

                const SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _codeController,
                        decoration: _inputDecoration("Subject Code", "e.g. CIS 2101"),
                        validator: (value) =>
                            value == null || value.isEmpty ? "Required" : null,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _unitsController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration("Units", "3"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Req."; // Shorter text for small fields
                          }
                          if (int.tryParse(value) == null) {
                            return "NaN"; 
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24), // Moved outside the Row

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _submit,
                    child: const Text(
                      "Create Subject",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


InputDecoration _inputDecoration(String label, String hint) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600),
    hintText: hint,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
    ),
  );
}