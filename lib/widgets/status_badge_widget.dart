import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../presentation/dashboard_screen/dashboard_screen.dart'
    show BasketStatus;

class StatusBadgeWidget extends StatelessWidget {
  final BasketStatus status;
  final bool compact;

  const StatusBadgeWidget({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _config(status);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: config.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: config.color.withAlpha(77), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: config.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            config.label,
            style: GoogleFonts.dmSans(
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: config.color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _config(BasketStatus s) {
    switch (s) {
      case BasketStatus.full:
        return _StatusConfig(
          color: AppTheme.statusFull,
          surface: AppTheme.statusFullSurface,
          label: 'Full',
        );
      case BasketStatus.filling:
        return _StatusConfig(
          color: AppTheme.statusFilling,
          surface: AppTheme.statusFillingSurface,
          label: 'Filling',
        );
      case BasketStatus.empty:
        return _StatusConfig(
          color: AppTheme.statusEmpty,
          surface: AppTheme.statusEmptySurface,
          label: 'Empty',
        );
      case BasketStatus.offline:
        return _StatusConfig(
          color: const Color(0xFF757575),
          surface: const Color(0xFFF5F5F5),
          label: 'Offline',
        );
    }
  }
}

class _StatusConfig {
  final Color color;
  final Color surface;
  final String label;
  const _StatusConfig({
    required this.color,
    required this.surface,
    required this.label,
  });
}
