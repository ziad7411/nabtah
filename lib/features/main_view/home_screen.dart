import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nabtah/core/theme/app_colors.dart';
import 'package:nabtah/l10n/app_localizations.dart';
import 'detect_plant_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapController _mapController = MapController();

  LatLng? _userLocation;
  List<Polygon> _polygons = [];
  bool _loading = true;
  String? _userName;

  Future<void> _loadUserName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    setState(() {
      _userName = doc.data()?['name'] ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _getLocation();
    await _loadGeoJson();
    await _loadUserName();
    setState(() => _loading = false);
  }

  Future<void> _getLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    final pos = await Geolocator.getCurrentPosition();
    _userLocation = LatLng(pos.latitude, pos.longitude);
  }

  Future<void> _loadGeoJson() async {
    final data = await rootBundle.loadString('assets/geo/regions.geojson');
    final jsonData = json.decode(data);

    List<Polygon> loaded = [];

    for (var feature in jsonData['features']) {
      final hasPlants = feature['properties']['has_plants'];
      if (!hasPlants) continue;

      final coords = feature['geometry']['coordinates'][0];

      List<LatLng> points = coords
          .map<LatLng>((c) => LatLng(c[1], c[0]))
          .toList();

      loaded.add(
        Polygon(
          points: points,
          color: AppColors.primaryGreen.withOpacity(0.25),
          borderColor: AppColors.primaryGreen,
          borderStrokeWidth: 2,
        ),
      );
    }

    _polygons = loaded;
  }

 
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (_loading || _userLocation == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
//         ElevatedButton(
//   onPressed: () {

//    Workmanager().registerOneOffTask(
//   "water_test",
//   waterReminderTask,
//   initialDelay: const Duration(seconds: 5),
// );
//   },
//   child: const Text("Test Notification"),
// ),
// ElevatedButton(
//   onPressed: () async {
//     await NotificationService.scheduleTest();
//   },
//   child: Text("test schedule"),
// ) ,

              /// ===== HEADER =====
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Logo Circle
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.07,
                      backgroundImage: const AssetImage(
                        "assets/images/logo1.png",
                      ),
                    ),

                    /// Right Side (Greeting + Profile)
                    Row(
                      children: [
                        /// Greeting
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              loc.hello,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              _userName ?? "",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 10),

                        /// Profile
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.primaryGreen,
                          child: const Icon(
                            Icons.person,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ===== DETECT CARD =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DetectPlantPage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.detectPlant,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              loc.detectSubTitle,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.white.withOpacity(0.2),
                          child: const Icon(
                            Icons.camera_alt,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// ===== MAP TITLE =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.interactiveMap,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      loc.mapSubTitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// ===== MAP CARD =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 8),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _userLocation!,
                        initialZoom: 9,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=9oQHB4cNQ1koAbjKUfes",
                          userAgentPackageName: 'com.example.nabtah',
                        ),
                        PolygonLayer(polygons: _polygons),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
