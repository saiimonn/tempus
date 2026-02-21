// used in add_button.dart -> _showSheet()
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/schedule/logic/add_schedule_sheet_bloc.dart';
import 'package:tempus/features/schedule/logic/schedule_bloc.dart';

const dayAbbr = {
  'Monday' : 'Mon',
  'Tuesday' : 'Tue',
  'Wednesday' : 'Wed',
  'Thursday' : 'Thu',
  'Friday' : 'Fri',
  'Saturday' : 'Sat',
  'Sunday' : 'Sun',
};

class AddScheduleSheet extends StatelessWidget {
  final List<Map<String, dynamic>> subjects;

  const AddScheduleSheet({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddScheduleBloc(),
      child: AddScheduleSheetBody(subjects: subjects),
    );
  }
}

class AddScheduleSheetBody extends StatelessWidget {
  final List<Map<String,dynamic>> subjects;

  const AddScheduleSheetBody({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}