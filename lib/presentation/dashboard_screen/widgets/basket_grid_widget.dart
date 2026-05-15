import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/status_badge_widget.dart';
import '../dashboard_screen.dart';

class BasketGridWidget extends StatelessWidget {
  final List<BasketModel> baskets;
  final bool isTablet;
  final AnimationController entranceController;
  final void Function(String basketId) onMarkEmptied;

  const BasketGridWidget({
    super.key,
    required this.baskets,
    required this.isTablet,
    required this.entranceController,
    required this.onMarkEmptied,
  });

  @override
  Widget build(BuildContext context) {
    if (baskets.isEmpty) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 300,
          child: EmptyStateWidget(
            icon: Icons.recycling_rounded,
            title: 'No baskets found',
            message:
                'No baskets match the selected filter. Try selecting a different status.',
            actionLabel: 'Show All',
            onAction: () {},
          ),
        ),
      );
    }

    final crossAxisCount = isTablet ? 3 : 2;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isTablet ? 0.95 : 0.85,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final delay = (index * 60).clamp(0, 400);
          final animation = CurvedAnimation(
            parent: entranceController,
            curve: Interval(
              delay / 1000,
              (delay + 300) / 1000,
              curve: Curves.easeOutCubic,
            ),
          );
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, 20 * (1 - animation.value)),
              child: Opacity(opacity: animation.value, child: child),
            ),
            child: _BasketCard(
              basket: baskets[index],
              onMarkEmptied: onMarkEmptied,
            ),
          );
        }, childCount: baskets.length),
      ),
    );
  }
}

class _BasketCard extends StatelessWidget {
  final BasketModel basket;
  final void Function(String) onMarkEmptied;

  const _BasketCard({required this.basket, required this.onMarkEmptied});

  Color _fillColor(double pct) {
    if (pct >= 90) return AppTheme.statusFull;
    if (pct >= 60) return AppTheme.statusFilling;
    return AppTheme.statusEmpty;
  }

  Color _cardBorder(BasketStatus status) {
    switch (status) {
      case BasketStatus.full:
        return AppTheme.statusFull.withAlpha(64);
      case BasketStatus.filling:
        return AppTheme.statusFilling.withAlpha(64);
      case BasketStatus.empty:
        return AppTheme.statusEmpty.withAlpha(51);
      case BasketStatus.offline:
        return const Color(0xFFBDBDBD);
    }
  }

  StatusBadgeWidget _buildBadge() {
    switch (basket.status) {
      case BasketStatus.full:
        return StatusBadgeWidget(status: BasketStatus.full, compact: true);
      case BasketStatus.filling:
        return StatusBadgeWidget(status: BasketStatus.filling, compact: true);
      case BasketStatus.empty:
        return StatusBadgeWidget(status: BasketStatus.empty, compact: true);
      case BasketStatus.offline:
        return StatusBadgeWidget(status: BasketStatus.offline, compact: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fillColor = _fillColor(basket.fillPercent);
    final isActionable =
        basket.status == BasketStatus.full ||
        basket.status == BasketStatus.filling;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showBasketDetail(context),
        borderRadius: BorderRadius.circular(16),
        splashColor: AppTheme.primaryMuted.withAlpha(77),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _cardBorder(basket.status), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: fillColor.withAlpha(31),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: fillColor,
                      size: 20,
                    ),
                  ),
                  _buildStatusBadge(basket.status),
                ],
              ),
              const SizedBox(height: 10),
              // Basket name
              Text(
                basket.name,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              // Zone
              Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      basket.zone,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9E9E9E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Fill bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fill level',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF757575),
                        ),
                      ),
                      Text(
                        '${basket.fillPercent.toInt()}%',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: fillColor,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: basket.fillPercent / 100,
                      backgroundColor: fillColor.withAlpha(31),
                      valueColor: AlwaysStoppedAnimation<Color>(fillColor),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Last emptied
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 11,
                    color: Color(0xFF9E9E9E),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      basket.lastEmptied,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9E9E9E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (isActionable) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () => onMarkEmptied(basket.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryDark,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                      textStyle: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Mark Emptied'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BasketStatus status) {
    Color color = const Color(0xFF757575);
    Color surface = const Color(0xFFF5F5F5);
    String label = '';
    switch (status) {
      case BasketStatus.full:
        color = AppTheme.statusFull;
        surface = AppTheme.statusFullSurface;
        label = 'Full';
        break;
      case BasketStatus.filling:
        color = AppTheme.statusFilling;
        surface = AppTheme.statusFillingSurface;
        label = 'Filling';
        break;
      case BasketStatus.empty:
        color = AppTheme.statusEmpty;
        surface = AppTheme.statusEmptySurface;
        label = 'Empty';
        break;
      case BasketStatus.offline:
        color = const Color(0xFF757575);
        surface = const Color(0xFFF5F5F5);
        label = 'Offline';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withAlpha(77), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  void _showBasketDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _BasketDetailSheet(basket: basket, onMarkEmptied: onMarkEmptied),
    );
  }
}

// ignore: must_be_immutable — used only internally
class _BasketDetailSheet extends StatelessWidget {
  final BasketModel basket;
  final void Function(String) onMarkEmptied;

  const _BasketDetailSheet({required this.basket, required this.onMarkEmptied});

  @override
  Widget build(BuildContext context) {
    final fillColor = basket.fillPercent >= 90
        ? AppTheme.statusFull
        : basket.fillPercent >= 60
        ? AppTheme.statusFilling
        : AppTheme.statusEmpty;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: fillColor.withAlpha(31),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: fillColor,
                  size: 24,
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
              ),
            ],
          ),
          const SizedBox(height: 20),
          _DetailRow(
            label: 'Fill Level',
            value: '${basket.fillPercent.toInt()}%',
            valueColor: fillColor,
          ),
          _DetailRow(label: 'Last Emptied', value: basket.lastEmptied),
          _DetailRow(label: 'Assigned To', value: basket.assignedTo),
          _DetailRow(label: 'Basket ID', value: basket.id),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: basket.fillPercent / 100,
              backgroundColor: fillColor.withAlpha(31),
              valueColor: AlwaysStoppedAnimation<Color>(fillColor),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 24),
          if (basket.status == BasketStatus.full ||
              basket.status == BasketStatus.filling)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onMarkEmptied(basket.id);
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
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF757575),
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

// Alias to avoid import conflicts
// ignore: library_prefixes
