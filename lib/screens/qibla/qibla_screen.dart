import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

import '../../widgets/app_navbar.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_bar.dart';
import '../../theme/app_colors.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with TickerProviderStateMixin {
  bool _loading = true;
  bool _hasPermission = false;
  Position? _currentPosition;
  late AnimationController _compassController;
  late Animation<double> _compassAnimation;

  // Mecca coordinates
  static const double meccaLat = 21.4225;
  static const double meccaLng = 39.8262;

  @override
  void initState() {
    super.initState();
    _compassController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _compassAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _compassController, curve: Curves.easeInOut),
    );
    _checkPermission();
  }

  @override
  void dispose() {
    _compassController.dispose();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _loading = false;
        _hasPermission = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        _loading = false;
        _hasPermission = false;
      });
      return;
    }

    // Get current position
    try {
      _currentPosition = await Geolocator.getCurrentPosition();
    } catch (e) {
      // Handle error
    }

    setState(() {
      _loading = false;
      _hasPermission = true;
    });
  }

  double _calculateDistance() {
    if (_currentPosition == null) return 0.0;

    const double earthRadius = 6371; // km
    final double dLat = (meccaLat - _currentPosition!.latitude) * pi / 180;
    final double dLng = (meccaLng - _currentPosition!.longitude) * pi / 180;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_currentPosition!.latitude * pi / 180) *
        cos(meccaLat * pi / 180) *
        sin(dLng / 2) * sin(dLng / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      extendBodyBehindAppBar: true,
      appBar: const AppBarWidget(title: 'Qibla Direction'),
      drawer: const AppDrawer(),
      bottomNavigationBar: const AppNavBar(currentIndex: 2), // Qibla index
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
              AppColors.primary.withOpacity(0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : !_hasPermission
                  ? _permissionError()
                  : _qiblaBody(),
        ),
      ),
    );
  }

  Widget _permissionError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 80,
              color: AppColors.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'Location Access Required',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Location permission is required to determine Qibla direction.\n\n'
              'Please enable location services and grant permission.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _checkPermission,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qiblaBody() {
    return FutureBuilder<bool>(
      future: FlutterQiblah.androidDeviceSensorSupport().then((v) => v ?? false),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        if (snapshot.data == false) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sensors_off,
                  size: 80,
                  color: Colors.white.withOpacity(0.8),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Compass Not Available',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Compass sensor is not available on this device.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          );
        }

        return StreamBuilder<QiblahDirection>(
          stream: FlutterQiblah.qiblahStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            final direction = snapshot.data!;
            final distance = _calculateDistance();

            return LayoutBuilder(
              builder: (context, constraints) {
                final compassSize = constraints.maxWidth * 0.8; // 80% of screen width
                final centerOffset = compassSize / 2;

                return Column(
                  children: [
                    // Top section with Kaaba icon and title
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '🕋',
                            style: TextStyle(fontSize: 60, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'QIBLA',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Direction to Makkah',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Main compass section
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: Container(
                          width: compassSize,
                          height: compassSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.9),
                                Colors.white.withOpacity(0.7),
                                Colors.white.withOpacity(0.5),
                              ],
                              stops: const [0.0, 0.7, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer ring
                              Container(
                                width: compassSize - 20,
                                height: compassSize - 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(0.8),
                                    width: 4,
                                  ),
                                ),
                              ),



                              // Qibla needle pointing to Kaaba
                              Transform.rotate(
                                angle: direction.qiblah * pi / 180,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Kaaba icon at the top (needle tip)
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withOpacity(0.4),
                                            blurRadius: 12,
                                            spreadRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Text(
                                          '🕋',
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      ),
                                    ),
                                    // Needle shaft
                                    Container(
                                      width: 6,
                                      height: compassSize * 0.35,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(3),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withOpacity(0.3),
                                            blurRadius: 6,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Center dot
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),

                              // Current direction indicator (small triangle at bottom)
                              Positioned(
                                bottom: compassSize * 0.08,
                                child: Transform.rotate(
                                  angle: direction.direction * pi / 180,
                                  child: Icon(
                                    Icons.navigation,
                                    color: AppColors.primary,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Bottom section with info
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Qibla angle
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${direction.qiblah.toStringAsFixed(1)}°',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Distance to Makkah
                          Text(
                            '${distance.toStringAsFixed(0)} km to Makkah',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Instructions
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 32),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Rotate until 🕋 aligns with center dot',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  List<Widget> _buildCardinalMarkers() {
    const markers = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final widgets = <Widget>[];

    for (int i = 0; i < markers.length; i++) {
      final angle = (i * 45) * pi / 180;
      widgets.add(
        Positioned(
          left: 125 + 90 * cos(angle - pi / 2),
          top: 125 + 90 * sin(angle - pi / 2),
          child: Transform.rotate(
            angle: angle,
            child: Text(
              markers[i],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary.withOpacity(0.7),
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  List<Widget> _buildCardinalMarkersFullScreen(double compassSize) {
    const markers = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final widgets = <Widget>[];
    final centerOffset = compassSize / 2;
    final radius = (compassSize - 40) / 2; // Distance from center to markers

    for (int i = 0; i < markers.length; i++) {
      final angle = (i * 45) * pi / 180;
      widgets.add(
        Positioned(
          left: centerOffset + radius * cos(angle - pi / 2) - 10, // Center the text
          top: centerOffset + radius * sin(angle - pi / 2) - 8,  // Center the text
          child: Transform.rotate(
            angle: angle,
            child: Text(
              markers[i],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary.withOpacity(0.8),
                shadows: [
                  Shadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}


