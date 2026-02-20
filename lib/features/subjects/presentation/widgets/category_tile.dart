import 'package:flutter/material.dart';
import 'package:tempus/core/theme/app_colors.dart';

class CategoryTile extends StatelessWidget {
  final Map<String, dynamic> category;
  final VoidCallback onDelete;

  const CategoryTile({ super.key, required this.category, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.inputFill.withValues(alpha: 0.5)),
      ),
      
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.brandBlue,
            ),
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            child: Text(
              "${category['name']}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
          ),
          
          Text(
            "${(category['weight'] as double).toStringAsFixed(0)}%",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.delete_outline, size: 20, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
