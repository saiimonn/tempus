import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/core/widgets/underline_text_field.dart';
import 'package:tempus/features/finance/domain/entities/transaction_entity.dart';
import 'package:tempus/features/finance/presentation/blocs/transaction/transaction_bloc.dart';

class EditTransactionSheet extends StatefulWidget {
  final TransactionEntity transaction;

  const EditTransactionSheet({super.key, required this.transaction});

  @override
  State<EditTransactionSheet> createState() => _EditTransactionSheetState();
}

class _EditTransactionSheetState extends State<EditTransactionSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.transaction.title);
    _amountController = TextEditingController(
      text: widget.transaction.amount % 1 == 0
          ? widget.transaction.amount.toStringAsFixed(0)
          : widget.transaction.amount.toStringAsFixed(2),
    );
    // Initialize the bloc's selected type to the transaction's current type.
    // Use a post frame callback so the context is safe in initState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        context.read<TransactionBloc>().add(
          TransactionTypeChanged(widget.transaction.isIncome),
        );
      } catch (_) {}
    });
  }

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

    final isIncome = context.read<TransactionBloc>().state.selectedIsIncome;
    context.read<TransactionBloc>().add(
      TransactionUpdateRequested(
        id: widget.transaction.id,
        title: title,
        amount: amount,
        isIncome: isIncome,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        final isIncome = state.selectedIsIncome;
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
                    child: const Icon(
                      Icons.close,
                      size: 22,
                      color: AppColors.text,
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'Edit Transaction',
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
                      size: 22,
                      color: AppColors.brandBlue,
                    ),
                  ),
                ],
              ),

              const Gap(24),

              Row(
                children: [
                  _TypeButton(
                    label: '+ Income',
                    isSelected: isIncome,
                    color: AppColors.success,
                    onTap: () => context.read<TransactionBloc>().add(
                      TransactionTypeChanged(true),
                    ),
                  ),

                  const Gap(10),

                  _TypeButton(
                    label: '- Expense',
                    isSelected: !isIncome,
                    color: AppColors.destructive,
                    onTap: () => context.read<TransactionBloc>().add(
                      TransactionTypeChanged(false),
                    ),
                  ),
                ],
              ),

              const Gap(20),

              UnderlineTextField(
                label: 'Title',
                controller: _titleController,
                hint: 'e.g. Jollibee',
                autofocus: true,
                textInputAction: TextInputAction.next,
              ),

              const Gap(20),

              UnderlineTextField(
                label: 'AMOUNT',
                controller: _amountController,
                hint: '0.00',
                isDecimal: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _confirm(),
              ),

              const Gap(28),

              SizedBox(
                width: double.infinity,
                height: 48,
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
                    'Save Changes',
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withValues(alpha: 0.2)),
        ),

        child: Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
