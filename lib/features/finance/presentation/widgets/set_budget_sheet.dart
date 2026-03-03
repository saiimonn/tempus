import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/features/finance/presentation/blocs/finance/finance_bloc.dart';

class SetBudgetSheet extends StatefulWidget {
  final double currentBudget;

  const SetBudgetSheet({
    super.key,
    required this.currentBudget,
  });

  @override
  State<SetBudgetSheet> createState() => _SetBudgetSheetState();
}

class _SetBudgetSheetState extends State<SetBudgetSheet> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.currentBudget > 0) {
      _controller.text = widget.currentBudget.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    final value = double.tryParse(_controller.text.trim());
    if(value == null || value <= 0) return;

    context
      .read<FinanceBloc>()
      .add(FinanceBudgetUpdateRequested(value));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocBuilder<FinanceBloc, FinanceState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + bottomInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, size: 22, color: AppColors.text),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'Set spending budget',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      _controller.clear();
                    },
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        color: AppColors.brandBlue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const Gap(24),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text(
                      '₱',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),

                    const Gap(4),

                    IntrinsicWidth(
                      child: TextField(
                        controller: _controller,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '0',
                          hintStyle: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.foreground,
                          ),

                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(24),

              Row(
                children: [
                  const Text(
                    'Cycle',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.text,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: state.selectedBudgetCycle,
                        isDense: true,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 14,
                        ),
                        items: ['Daily', 'Weekly', 'Monthly'].map((c) {
                          return DropdownMenuItem(value: c, child: Text(c));
                        }).toList(),
                        onChanged: (v) {
                          if (v != null) {
                            context.read<FinanceBloc>().add(
                              FinanceBudgetCycleChanged(v),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const Gap(24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _confirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}