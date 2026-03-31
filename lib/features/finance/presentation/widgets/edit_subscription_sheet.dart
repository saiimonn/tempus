import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tempus/core/theme/app_colors.dart';
import 'package:tempus/core/widgets/underline_text_field.dart';
import 'package:tempus/features/finance/domain/entities/subscription_entity.dart';
import 'package:tempus/features/finance/presentation/blocs/subscription/subscription_bloc.dart';

class EditSubscriptionSheet extends StatefulWidget {
  final SubscriptionEntity subscription;

  const EditSubscriptionSheet({super.key, required this.subscription});

  @override
  State<EditSubscriptionSheet> createState() => _EditSubscriptionSheetState();
}

class _EditSubscriptionSheetState extends State<EditSubscriptionSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.subscription.title);
    _priceController = TextEditingController(
      text: widget.subscription.monthlyPrice % 1 == 0
          ? widget.subscription.monthlyPrice.toStringAsFixed(0)
          : widget.subscription.monthlyPrice.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _confirm() {
    final title = _titleController.text.trim();
    final price = double.tryParse(_priceController.text.trim());

    if (title.isEmpty || price == null || price <= 0) return;

    context.read<SubscriptionBloc>().add(
      SubscriptionUpdateRequested(
        id: widget.subscription.id,
        title: title,
        monthlyPrice: price,
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
                child: const Icon(
                  Icons.close,
                  size: 22,
                  color: AppColors.text,
                ),
              ),
              
              const Expanded(
                child: Center(
                  child: Text(
                    'Edit Subscription',
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
          
          UnderlineTextField(
            label: 'Name',
            controller: _titleController,
            hint: 'e.g. Netflix',
            autofocus: true,
            textInputAction: TextInputAction.next,
          ),
          
          const Gap(20),
          
          UnderlineTextField(
            label: 'Monthly Price',
            controller: _priceController,
            hint: '100.00',
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
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
