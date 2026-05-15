import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class DashboardKpiRowWidget extends StatelessWidget {
  final int fullCount;
  final int todayEmpties;
  final int avgResponseMin;

  const DashboardKpiRowWidget({
    super.key,
    required this.fullCount,
    required this.todayEmpties,
    required this.avgResponseMin,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _KpiCard(
            label: 'Needs\nAttention',
            value: '$fullCount',
            unit: 'baskets',
            color: fullCount > 0 ? AppTheme.statusFull : AppTheme.statusEmpty,
            surface: fullCount > 0
                ? AppTheme.statusFullSurface
                : AppTheme.statusEmptySurface,
            icon: Icons.warning_amber_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _KpiCard(
            label: "Today's\nEmpties",
            value: '$todayEmpties',
            unit: 'done',
            color: AppTheme.primaryDark,
            surface: AppTheme.primaryContainer,
            icon: Icons.delete_sweep_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _KpiCard(
            label: 'Avg\nResponse',
            value: '$avgResponseMin',
            unit: 'min',
            color: AppTheme.statusFilling,
            surface: AppTheme.statusFillingSurface,
            icon: Icons.access_time_rounded,
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final Color surface;
  final IconData icon;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.surface,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(51), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
              height: 1.0,
            ),
          ),
          Text(
            unit,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color.withAlpha(179),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF757575),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
