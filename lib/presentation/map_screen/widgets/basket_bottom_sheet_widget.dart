import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../dashboard_screen/dashboard_screen.dart';

class BasketBottomSheetWidget extends StatelessWidget {
  final BasketModel basket;
  final VoidCallback onClose;
  final void Function(String) onMarkEmptied;
  final bool isPanel;

  const BasketBottomSheetWidget({
    super.key,
    required this.basket,
    required this.onClose,
    required this.onMarkEmptied,
    this.isPanel = false,
  });

  Color _fillColor(double pct) {
    if (pct >= 90) return AppTheme.statusFull;
    if (pct >= 60) return AppTheme.statusFilling;
    return AppTheme.statusEmpty;
  }

  Color _statusColor(BasketStatus s) {
    switch (s) {
      case BasketStatus.full:
        return AppTheme.statusFull;
      case BasketStatus.filling:
        return AppTheme.statusFilling;
      case BasketStatus.empty:
        return AppTheme.statusEmpty;
      case BasketStatus.offline:
        return const Color(0xFF757575);
    }
  }

  Color _statusSurface(BasketStatus s) {
    switch (s) {
      case BasketStatus.full:
        return AppTheme.statusFullSurface;
      case BasketStatus.filling:
        return AppTheme.statusFillingSurface;
      case BasketStatus.empty:
        return AppTheme.statusEmptySurface;
      case BasketStatus.offline:
        return const Color(0xFFF5F5F5);
    }
  }

  String _statusLabel(BasketStatus s) {
    switch (s) {
      case BasketStatus.full:
        return 'Full';
      case BasketStatus.filling:
        return 'Filling';
      case BasketStatus.empty:
        return 'Empty';
      case BasketStatus.offline:
        return 'Offline';
    }
  }

  @override
  Widget build(BuildContext context) {
    final fillColor = _fillColor(basket.fillPercent);
    final statusColor = _statusColor(basket.status);
    final statusSurface = _statusSurface(basket.status);
    final isActionable =
        basket.status == BasketStatus.full ||
        basket.status == BasketStatus.filling;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: isPanel ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (!isPanel) ...[
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
        // Header
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: fillColor.withAlpha(31),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: fillColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    basket.name,
                    style: GoogleFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 13,
                        color: Color(0xFF9E9E9E),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        basket.zone,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withAlpha(77), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _statusLabel(basket.status),
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Close button
            InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Color(0xFF757575),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Fill level bar
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fill Level',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF757575),
                  ),
                ),
                Text(
                  '${basket.fillPercent.toInt()}%',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: fillColor,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: basket.fillPercent / 100,
                backgroundColor: fillColor.withAlpha(31),
                valueColor: AlwaysStoppedAnimation<Color>(fillColor),
                minHeight: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Detail rows
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceVariantLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _SheetDetailRow(
                icon: Icons.access_time_rounded,
                label: 'Last Emptied',
                value: basket.lastEmptied,
              ),
              const Divider(height: 16, color: Color(0xFFE0E0E0)),
              _SheetDetailRow(
                icon: Icons.person_rounded,
                label: 'Assigned To',
                value: basket.assignedTo,
              ),
              const Divider(height: 16, color: Color(0xFFE0E0E0)),
              _SheetDetailRow(
                icon: Icons.qr_code_rounded,
                label: 'Basket ID',
                value: basket.id,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Action button
        if (isActionable)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                onMarkEmptied(basket.id);
                if (!isPanel) onClose();
              },
              icon: const Icon(Icons.done_rounded, size: 20),
              label: const Text('Mark as Emptied'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryDark,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded, size: 18),
              label: const Text('Close'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF757575),
                side: const BorderSide(
                  color: AppTheme.outlineVariantLight,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        if (isPanel) const SizedBox(height: 16),
      ],
    );

    if (isPanel) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: content,
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: content,
    );
  }
}

class _SheetDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SheetDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryDark),
        const SizedBox(width: 10),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF757575),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
