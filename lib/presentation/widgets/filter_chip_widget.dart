import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  final String value;
  final String selectedValue;
  final Function(String) onSelected;
  final String? displayName;
  final Color? prefixColor;

  const FilterChipWidget({
    super.key,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
    this.displayName,
    this.prefixColor,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;
    return GestureDetector(
      onTap: () => onSelected(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2575FC) : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected ? const Color(0xFF2575FC) : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2575FC).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixColor != null && !isSelected) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: prefixColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6.0),
            ],
            Text(
              displayName ?? value,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
