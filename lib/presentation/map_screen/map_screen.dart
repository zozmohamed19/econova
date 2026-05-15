import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/app_export.dart';
import '../../widgets/app_navigation.dart';
import '../dashboard_screen/dashboard_screen.dart';
import './widgets/basket_bottom_sheet_widget.dart';
import './widgets/map_legend_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  int _navIndex = 1;
  GoogleMapController? _mapController;
  BasketModel? _selectedBasket;
  bool _showBottomSheet = false;
  Set<Marker> _markers = {};
  String _filterStatus = 'All';

  late AnimationController _sheetController;
  late Animation<double> _sheetAnimation;

  // Baskets data reused from dashboard mock
  final List<BasketModel> _baskets = DashboardScreen.basketMaps
      .map(BasketModel.fromMap)
      .toList();

  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(30.0448, 31.2357),
    zoom: 16.5,
  );

  @override
  void initState() {
    super.initState();
    _sheetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _sheetAnimation = CurvedAnimation(
      parent: _sheetController,
      curve: Curves.easeOutCubic,
    );
    _buildMarkers();
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Color _markerColor(BasketStatus status) {
    switch (status) {
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

  BitmapDescriptor _markerHue(BasketStatus status) {
    switch (status) {
      case BasketStatus.full:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case BasketStatus.filling:
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueOrange,
        );
      case BasketStatus.empty:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case BasketStatus.offline:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }

  void _buildMarkers() {
    final filtered = _filterStatus == 'All'
        ? _baskets
        : _baskets.where((b) {
            switch (_filterStatus) {
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

    setState(() {
      _markers = filtered
          .map(
            (b) => Marker(
              markerId: MarkerId(b.id),
              position: LatLng(b.lat, b.lng),
              icon: _markerHue(b.status),
              infoWindow: InfoWindow(title: b.name, snippet: b.zone),
              onTap: () => _onMarkerTapped(b),
            ),
          )
          .toSet();
    });
  }

  void _onMarkerTapped(BasketModel basket) {
    setState(() {
      _selectedBasket = basket;
      _showBottomSheet = true;
    });
    _sheetController.forward();
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(basket.lat, basket.lng), 17.5),
    );
  }

  void _closeSheet() {
    _sheetController.reverse().then((_) {
      setState(() {
        _showBottomSheet = false;
        _selectedBasket = null;
      });
    });
  }

  void _markEmptied(String basketId) {
    // TODO: Replace with real API call
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
      _selectedBasket = _baskets.firstWhere((b) => b.id == basketId);
    });
    _buildMarkers();
  }

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboardScreen,
        (r) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final isLargeTablet = MediaQuery.of(context).size.width >= 840;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: AppTheme.primaryMuted,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF1A1A1A),
            size: 24,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.dashboardScreen,
                (r) => false,
              );
            }
          },
        ),
        title: Text(
          'Basket Locations',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          // Filter button
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PopupMenuButton<String>(
              icon: const Icon(
                Icons.filter_list_rounded,
                color: Color(0xFF1A1A1A),
                size: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              initialValue: _filterStatus,
              onSelected: (value) {
                setState(() => _filterStatus = value);
                _buildMarkers();
              },
              itemBuilder: (context) => ['All', 'Full', 'Filling', 'Empty']
                  .map(
                    (s) => PopupMenuItem(
                      value: s,
                      child: Row(
                        children: [
                          if (_filterStatus == s)
                            const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: AppTheme.primaryDark,
                            )
                          else
                            const SizedBox(width: 16),
                          const SizedBox(width: 8),
                          Text(
                            s,
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: _filterStatus == s
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: isLargeTablet
            ? _buildTabletLayout()
            : _buildPhoneLayout(isTablet),
      ),
      bottomNavigationBar: isTablet
          ? null
          : AppNavigation(
              currentIndex: _navIndex,
              onDestinationSelected: _onNavTap,
            ),
    );
  }

  Widget _buildPhoneLayout(bool isTablet) {
    return isTablet
        ? Row(
            children: [
              AppNavigation(
                currentIndex: _navIndex,
                onDestinationSelected: _onNavTap,
              ),
              const VerticalDivider(width: 1),
              Expanded(child: _buildMapStack()),
            ],
          )
        : _buildMapStack();
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        AppNavigation(
          currentIndex: _navIndex,
          onDestinationSelected: _onNavTap,
        ),
        const VerticalDivider(width: 1),
        Expanded(child: _buildMapStack()),
        if (_selectedBasket != null)
          SizedBox(width: 320, child: _buildSidePanel()),
      ],
    );
  }

  Widget _buildMapStack() {
    return Stack(
      children: [
        // Map
        kIsWeb
            ? Container(
                color: AppTheme.surfaceVariantLight,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.map_rounded,
                        size: 64,
                        color: AppTheme.primaryDark,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Map Preview',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add your Google Maps API key to see the live map.',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: const Color(0xFF757575),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ..._baskets
                          .take(4)
                          .map(
                            (b) => _MapBasketListItem(
                              basket: b,
                              onTap: () => _onMarkerTapped(b),
                            ),
                          ),
                    ],
                  ),
                ),
              )
            : GoogleMap(
                initialCameraPosition: _initialCamera,
                markers: _markers,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                onTap: (_) {
                  if (_showBottomSheet) _closeSheet();
                },
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),

        // Legend
        Positioned(top: 12, right: 12, child: const MapLegendWidget()),

        // Basket count chip
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.delete_outline_rounded,
                  size: 14,
                  color: AppTheme.primaryDark,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_markers.length} baskets',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ),

        // My location FAB
        Positioned(
          bottom: _showBottomSheet ? 240 : 24,
          right: 16,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            child: FloatingActionButton.small(
              heroTag: 'location-fab',
              onPressed: () {
                _mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(_initialCamera),
                );
              },
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryDark,
              elevation: 4,
              child: const Icon(Icons.my_location_rounded, size: 20),
            ),
          ),
        ),

        // Bottom sheet
        if (_showBottomSheet && _selectedBasket != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _sheetAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, 20 * (1 - _sheetAnimation.value)),
                child: Opacity(opacity: _sheetAnimation.value, child: child),
              ),
              child: BasketBottomSheetWidget(
                basket: _selectedBasket!,
                onClose: _closeSheet,
                onMarkEmptied: _markEmptied,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSidePanel() {
    if (_selectedBasket == null) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(color: AppTheme.outlineVariantLight)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.touch_app_rounded,
                size: 48,
                color: AppTheme.primaryMuted,
              ),
              const SizedBox(height: 12),
              Text(
                'Tap a basket\non the map',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: const Color(0xFF9E9E9E),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: AppTheme.outlineVariantLight)),
      ),
      child: BasketBottomSheetWidget(
        basket: _selectedBasket!,
        onClose: _closeSheet,
        onMarkEmptied: _markEmptied,
        isPanel: true,
      ),
    );
  }
}

class _MapBasketListItem extends StatelessWidget {
  final BasketModel basket;
  final VoidCallback onTap;

  const _MapBasketListItem({required this.basket, required this.onTap});

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

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(basket.status);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Text(
              basket.name,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              basket.zone,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: const Color(0xFF9E9E9E),
              ),
            ),
            const Spacer(),
            Text(
              '${basket.fillPercent.toInt()}%',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
