import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/core/widgets/custom_text_field.dart';
import 'package:tempus/features/finance/presentation/blocs/transaction/transaction_bloc.dart';

class AddTransactionSheet extends StatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isIncome = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _confirm() {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());

    if (title.isEmpty || amount == null || amount <= 0) return;

    context.read<TransactionBloc>().add(
      TransactionAddRequested(
        title: title,
        amount: amount,
        isIncome: _isIncome,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
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
                child: const Icon(Icons.close, size: 24, color: AppColors.text),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Add New Transaction',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ),

              GestureDetector(
                onTap: _confirm,
                child: const Icon(
                  Icons.check,
                  size: 24,
                  color: AppColors.brandBlue,
                ),
              ),
            ],
          ),
          
          CustomTextField(
            controller: _titleController,
            hint: 'e.g. Jollibee Funds',
            label: 'Transaction Name',
          ),
          
          const Gap(16),
          
          Row(
            children: [
              _TypeButton(
                label: '+ Income',
                isSelected: _isIncome,
                color: AppColors.success,
                onTap: () => setState(() => _isIncome = true),
              ),
              
              const Gap(12),
              
              _TypeButton(
                label: '- Expense',
                isSelected: !_isIncome,
                color: AppColors.destructive,
                onTap: () => setState(() => _isIncome = false),
              ),
            ],
          ),
          
          CustomTextField(
            label: 'Amount',
            controller: _amountController,
            hint: 'e.g. 500.00',
            isDecimal: true,
          ),
        ],
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),

        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? color : AppColors.foreground,
          ),
        ),
      ),
    );
  }
}
