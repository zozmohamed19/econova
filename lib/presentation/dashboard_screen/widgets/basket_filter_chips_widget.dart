import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class BasketFilterChipsWidget extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const BasketFilterChipsWidget({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  Color _chipColor(String filter) {
    switch (filter) {
      case 'Full':
        return AppTheme.statusFull;
      case 'Filling':
        return AppTheme.statusFilling;
      case 'Empty':
        return AppTheme.statusEmpty;
      default:
        return AppTheme.primaryDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter == selectedFilter;
          final color = _chipColor(filter);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (_) => onFilterChanged(filter),
                backgroundColor: Colors.white,
                selectedColor: color.withAlpha(31),
                checkmarkColor: color,
                side: BorderSide(
                  color: isSelected ? color : AppTheme.outlineVariantLight,
                  width: isSelected ? 1.5 : 1,
                ),
                labelStyle: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? color : const Color(0xFF4A4A4A),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
