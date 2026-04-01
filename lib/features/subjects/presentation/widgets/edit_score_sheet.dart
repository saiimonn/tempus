import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/core/widgets/underline_text_field.dart';
import 'package:tempus/features/subjects/domain/entities/scores_entity.dart';
import 'package:tempus/features/subjects/presentation/bloc/scores/scores_bloc.dart';

class EditScoreSheet extends StatefulWidget {
  final ScoresEntity score;
  final int categoryId;

  const EditScoreSheet({
    super.key,
    required this.score,
    required this.categoryId,
  });

  @override
  State<EditScoreSheet> createState() => _EditScoreSheetState();
}

class _EditScoreSheetState extends State<EditScoreSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _scoreController;
  late final TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.score.title);

    _scoreController = TextEditingController(
      text: widget.score.scoreValue % 1 == 0
          ? widget.score.scoreValue.toStringAsFixed(0)
          : widget.score.scoreValue.toStringAsFixed(2),
    );

    _maxController = TextEditingController(
      text: widget.score.maxScore % 1 == 0
          ? widget.score.maxScore.toStringAsFixed(0)
          : widget.score.maxScore.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _scoreController.dispose();
    _maxController.dispose();
    super.dispose();
  }
  
  
}
