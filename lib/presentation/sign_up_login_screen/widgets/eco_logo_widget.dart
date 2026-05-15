import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class EcoLogoWidget extends StatelessWidget {
  const EcoLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Recycling icon base
            Icon(
              Icons.recycling_rounded,
              size: 44,
              color: AppTheme.primaryDark,
            ),
            // Small eco leaf overlay
            Positioned(
              bottom: 18,
              right: 16,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  size: 12,
                  color: AppTheme.primaryLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
