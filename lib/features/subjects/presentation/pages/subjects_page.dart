import 'package:flutter/material.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                itemCount: state.subjects.length,
                itemBuilder: (context, index) {
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
}
