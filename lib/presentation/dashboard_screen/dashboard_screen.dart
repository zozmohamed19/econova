import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../widgets/app_navigation.dart';
import './widgets/basket_filter_chips_widget.dart';
import './widgets/basket_grid_widget.dart';
import './widgets/dashboard_kpi_row_widget.dart';
import './widgets/recent_activity_widget.dart';

// ── Mock Data ──────────────────────────────────────────────────────────────
enum BasketStatus { full, filling, empty, offline }

BasketStatus _statusFromString(String v) {
  switch (v) {
    case 'full':
      return BasketStatus.full;
    case 'filling':
      return BasketStatus.filling;
    case 'empty':
      return BasketStatus.empty;
    default:
      return BasketStatus.offline;
  }
}

class BasketModel {
  final String id;
  final String name;
  final String zone;
  final double fillPercent;
  final BasketStatus status;
  final String lastEmptied;
  final String assignedTo;
  final double lat;
  final double lng;

  BasketModel({
    required this.id,
    required this.name,
    required this.zone,
    required this.fillPercent,
    required this.status,
    required this.lastEmptied,
    required this.assignedTo,
    required this.lat,
    required this.lng,
  });

  factory BasketModel.fromMap(Map<String, dynamic> map) {
    return BasketModel(
      id: map['id'] as String,
      name: map['name'] as String,
      zone: map['zone'] as String,
      fillPercent: (map['fillPercent'] as num).toDouble(),
      status: _statusFromString(map['status'] as String),
      lastEmptied: map['lastEmptied'] as String,
      assignedTo: map['assignedTo'] as String,
      lat: (map['lat'] as num).toDouble(),
      lng: (map['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'zone': zone,
    'fillPercent': fillPercent,
    'status': status.name,
    'lastEmptied': lastEmptied,
    'assignedTo': assignedTo,
    'lat': lat,
    'lng': lng,
  };
}

class ActivityModel {
  final String basketName;
  final String zone;
  final String emptiedBy;
  final String timeAgo;
  final String avatarUrl;
  final String avatarSemanticLabel;

  ActivityModel({
    required this.basketName,
    required this.zone,
    required this.emptiedBy,
    required this.timeAgo,
    required this.avatarUrl,
    required this.avatarSemanticLabel,
  });

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      basketName: map['basketName'] as String,
      zone: map['zone'] as String,
      emptiedBy: map['emptiedBy'] as String,
      timeAgo: map['timeAgo'] as String,
      avatarUrl: map['avatarUrl'] as String,
      avatarSemanticLabel: map['avatarSemanticLabel'] as String,
    );
  }
}

final List<Map<String, dynamic>> _basketMaps = [
  {
    'id': 'BK-001',
    'name': 'Basket A1',
    'zone': 'Main Entrance',
    'fillPercent': 97.0,
    'status': 'full',
    'lastEmptied': '2h 40m ago',
    'assignedTo': 'Omar Hassan',
    'lat': 30.0444,
    'lng': 31.2357,
  },
  {
    'id': 'BK-002',
    'name': 'Basket B3',
    'zone': 'Cafeteria',
    'fillPercent': 78.0,
    'status': 'filling',
    'lastEmptied': '1h 15m ago',
    'assignedTo': 'Nour El-Din',
    'lat': 30.0450,
    'lng': 31.2360,
  },
  {
    'id': 'BK-003',
    'name': 'Basket C2',
    'zone': 'Parking Lot B',
    'fillPercent': 100.0,
    'status': 'full',
    'lastEmptied': '3h 10m ago',
    'assignedTo': 'Youssef Adel',
    'lat': 30.0438,
    'lng': 31.2350,
  },
  {
    'id': 'BK-004',
    'name': 'Basket D1',
    'zone': 'Office Block 2',
    'fillPercent': 22.0,
    'status': 'empty',
    'lastEmptied': '18m ago',
    'assignedTo': 'Salma Karim',
    'lat': 30.0455,
    'lng': 31.2365,
  },
  {
    'id': 'BK-005',
    'name': 'Basket E4',
    'zone': 'Garden Path',
    'fillPercent': 61.0,
    'status': 'filling',
    'lastEmptied': '45m ago',
    'assignedTo': 'Omar Hassan',
    'lat': 30.0442,
    'lng': 31.2370,
  },
  {
    'id': 'BK-006',
    'name': 'Basket F2',
    'zone': 'Reception',
    'fillPercent': 8.0,
    'status': 'empty',
    'lastEmptied': '25m ago',
    'assignedTo': 'Nour El-Din',
    'lat': 30.0448,
    'lng': 31.2345,
  },
  {
    'id': 'BK-007',
    'name': 'Basket G1',
    'zone': 'Loading Dock',
    'fillPercent': 0.0,
    'status': 'offline',
    'lastEmptied': 'Yesterday',
    'assignedTo': 'Unassigned',
    'lat': 30.0435,
    'lng': 31.2355,
  },
  {
    'id': 'BK-008',
    'name': 'Basket H3',
    'zone': 'Gym Area',
    'fillPercent': 89.0,
    'status': 'full',
    'lastEmptied': '2h 05m ago',
    'assignedTo': 'Youssef Adel',
    'lat': 30.0460,
    'lng': 31.2362,
  },
];

final List<Map<String, dynamic>> _activityMaps = [
  {
    'basketName': 'Basket D1',
    'zone': 'Office Block 2',
    'emptiedBy': 'Salma Karim',
    'timeAgo': '18 min ago',
    'avatarUrl':
        'https://img.rocket.new/generatedImages/rocket_gen_img_1da96789d-1763301906318.png',
    'avatarSemanticLabel':
        'Professional headshot of young Egyptian woman with dark hair in green uniform',
  },
  {
    'basketName': 'Basket F2',
    'zone': 'Reception',
    'emptiedBy': 'Nour El-Din',
    'timeAgo': '25 min ago',
    'avatarUrl':
        'https://img.rocket.new/generatedImages/rocket_gen_img_1c2f96239-1763296912126.png',
    'avatarSemanticLabel':
        'Headshot of young Arab man with short beard in work shirt',
  },
  {
    'basketName': 'Basket E4',
    'zone': 'Garden Path',
    'emptiedBy': 'Omar Hassan',
    'timeAgo': '45 min ago',
    'avatarUrl':
        'https://img.rocket.new/generatedImages/rocket_gen_img_195b11aea-1763295573063.png',
    'avatarSemanticLabel':
        'Headshot of Egyptian man in his 30s with short hair smiling',
  },
  {
    'basketName': 'Basket B3',
    'zone': 'Cafeteria',
    'emptiedBy': 'Nour El-Din',
    'timeAgo': '1h 15m ago',
    'avatarUrl':
        'https://img.rocket.new/generatedImages/rocket_gen_img_1c2f96239-1763296912126.png',
    'avatarSemanticLabel':
        'Headshot of young Arab man with short beard in work shirt',
  },
  {
    'basketName': 'Basket A1',
    'zone': 'Main Entrance',
    'emptiedBy': 'Omar Hassan',
    'timeAgo': '2h 40m ago',
    'avatarUrl':
        'https://img.rocket.new/generatedImages/rocket_gen_img_195b11aea-1763295573063.png',
    'avatarSemanticLabel':
        'Headshot of Egyptian man in his 30s with short hair smiling',
  },
];

// ─────────────────────────────────────────────────────────────────────────────

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static List<Map<String, dynamic>> get basketMaps => _basketMaps;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  int _navIndex = 0;
  String _selectedFilter = 'All';
  bool _isLoading = false;
  List<BasketModel> _baskets = [];
  List<ActivityModel> _activities = [];
  late AnimationController _listEntranceController;
  String _lastUpdated = '11:16 AM';

  final List<String> _filters = ['All', 'Full', 'Filling', 'Empty'];

  @override
  void initState() {
    super.initState();
    _baskets = _basketMaps.map(BasketModel.fromMap).toList();
    _activities = _activityMaps.map(ActivityModel.fromMap).toList();
    _listEntranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _listEntranceController.dispose();
    super.dispose();
  }

  List<BasketModel> get _filteredBaskets {
    if (_selectedFilter == 'All') return _baskets;
    return _baskets.where((b) {
      switch (_selectedFilter) {
        case 'Full':
          return b.status == BasketStatus.full;
        case 'Filling':
          return b.status == BasketStatus.filling;
        case 'Empty':
          return b.status == BasketStatus.empty;
        default:
          return true;
      }
    }).toList();
  }

  int get _fullCount =>
      _baskets.where((b) => b.status == BasketStatus.full).length;
  int get _todayEmpties => _activities.length;

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    // TODO: Replace with real IoT data fetch
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _isLoading = false;
      _lastUpdated = TimeOfDay.now().format(context);
    });
  }

  void _markBasketEmptied(String basketId) {
    // TODO: Replace with real API call to mark basket emptied
    setState(() {
      final index = _baskets.indexWhere((b) => b.id == basketId);
      if (index != -1) {
        final old = _baskets[index];
        _baskets[index] = BasketModel(
          id: old.id,
          name: old.name,
          zone: old.zone,
          fillPercent: 5.0,
          status: BasketStatus.empty,
          lastEmptied: 'Just now',
          assignedTo: old.assignedTo,
          lat: old.lat,
          lng: old.lng,
        );
      }
    });
  }

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
    if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.mapScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: AppTheme.primaryMuted,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppTheme.primaryDark,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.recycling_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'EcoNova',
              style: GoogleFonts.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A1A),
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_rounded,
                  color: Color(0xFF1A1A1A),
                  size: 24,
                ),
                onPressed: () {},
              ),
              if (_fullCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppTheme.statusFull,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$_fullCount',
                        style: GoogleFonts.dmSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Color(0xFF1A1A1A),
              size: 24,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.signUpLoginScreen,
                  (r) => false,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(
                      Icons.logout_rounded,
                      size: 18,
                      color: Color(0xFFC62828),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Sign Out',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: const Color(0xFFC62828),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: isTablet
            ? Row(
                children: [
                  AppNavigation(
                    currentIndex: _navIndex,
                    onDestinationSelected: _onNavTap,
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: _buildDashboardBody(theme, isTablet)),
                ],
              )
            : _buildDashboardBody(theme, isTablet),
      ),
      bottomNavigationBar: isTablet
          ? null
          : AppNavigation(
              currentIndex: _navIndex,
              onDestinationSelected: _onNavTap,
            ),
    );
  }

  Widget _buildDashboardBody(ThemeData theme, bool isTablet) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.primaryDark,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryDark),
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time-aware greeting
                        _GreetingRow(
                          fullCount: _fullCount,
                          lastUpdated: _lastUpdated,
                        ),
                        const SizedBox(height: 16),
                        // KPI row
                        DashboardKpiRowWidget(
                          fullCount: _fullCount,
                          todayEmpties: _todayEmpties,
                          avgResponseMin: 23,
                        ),
                        const SizedBox(height: 20),
                        // Filter chips
                        BasketFilterChipsWidget(
                          filters: _filters,
                          selectedFilter: _selectedFilter,
                          onFilterChanged: (f) {
                            setState(() => _selectedFilter = f);
                            _listEntranceController
                              ..reset()
                              ..forward();
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              '${_filteredBaskets.length} baskets',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                // Basket grid
                BasketGridWidget(
                  baskets: _filteredBaskets,
                  isTablet: isTablet,
                  entranceController: _listEntranceController,
                  onMarkEmptied: _markBasketEmptied,
                ),
                // Recent activity
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Activity',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'See all',
                                style: GoogleFonts.dmSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                RecentActivityWidget(activities: _activities),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
    );
  }
}

class _GreetingRow extends StatelessWidget {
  final int fullCount;
  final String lastUpdated;

  const _GreetingRow({required this.fullCount, required this.lastUpdated});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$_greeting, Omar 👋',
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              fullCount > 0
                  ? '$fullCount basket${fullCount > 1 ? 's' : ''} need emptying'
                  : 'All baskets are in good shape',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: fullCount > 0
                    ? AppTheme.statusFull
                    : AppTheme.primaryDark,
              ),
            ),
          ],
        ),
        Text(
          'Updated $lastUpdated',
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9E9E9E),
          ),
        ),
      ],
    );
  }
}
