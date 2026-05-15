import '../../../core/app_export.dart';
import '../dashboard_screen.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<ActivityModel> activities;

  const RecentActivityWidget({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Center(
            child: Text(
              'No activity recorded today',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: const Color(0xFF9E9E9E),
              ),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final activity = activities[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: _ActivityItem(activity: activity),
        );
      }, childCount: activities.length),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final ActivityModel activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CustomImageWidget(
              imageUrl: activity.avatarUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              semanticLabel: activity.avatarSemanticLabel,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: const Color(0xFF1A1A1A),
                    ),
                    children: [
                      TextSpan(
                        text: activity.emptiedBy,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(
                        text: ' emptied ',
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: activity.basketName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 11,
                      color: Color(0xFF9E9E9E),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      activity.zone,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppTheme.statusEmptySurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.done_rounded,
                  size: 14,
                  color: AppTheme.statusEmpty,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                activity.timeAgo,
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
