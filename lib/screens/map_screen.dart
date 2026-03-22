import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dashboard_screen.dart';
import 'feed_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  List<Marker> requestMarkers = [];
  List<Marker> hospitalMarkers = [];
  List<Marker> ambulanceMarkers = [];

  final List<Map<String, dynamic>> hospitals = [
    {'name': 'GMCH Nagpur', 'lat': 21.1508, 'lng': 79.0830},
    {'name': 'Alexis Hospital', 'lat': 21.1200, 'lng': 79.0800},
    {'name': 'Wockhardt', 'lat': 21.1450, 'lng': 79.0910},
    {'name': 'Orange City', 'lat': 21.1380, 'lng': 79.0750},
    {'name': 'KIMS Hospital', 'lat': 21.1300, 'lng': 79.0850},
  ];

  final List<Map<String, dynamic>> ambulances = [
    {'name': 'AMB-01', 'lat': 21.1420, 'lng': 79.0860},
    {'name': 'AMB-02', 'lat': 21.1350, 'lng': 79.0780},
    {'name': 'AMB-03', 'lat': 21.1480, 'lng': 79.0920},
  ];

  List<Map<String, dynamic>> activeRequests = [];

  @override
  void initState() {
    super.initState();
    loadHospitalMarkers();
    loadAmbulanceMarkers();
    loadRequestMarkers();
  }

  void loadHospitalMarkers() {
    setState(() {
      hospitalMarkers = hospitals.map((h) {
        return Marker(
          point: LatLng(h['lat'], h['lng']),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => Get.snackbar(
              h['name'],
              'Hospital nearby',
              backgroundColor: const Color(0xFF185FA5),
              colorText: Colors.white,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF185FA5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_hospital,
                  color: Colors.white, size: 20),
            ),
          ),
        );
      }).toList();
    });
  }

  void loadAmbulanceMarkers() {
    setState(() {
      ambulanceMarkers = ambulances.map((a) {
        return Marker(
          point: LatLng(a['lat'], a['lng']),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () => Get.snackbar(
              a['name'],
              'Ambulance available',
              backgroundColor: const Color(0xFFBA7517),
              colorText: Colors.white,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFBA7517),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emergency,
                  color: Colors.white, size: 20),
            ),
          ),
        );
      }).toList();
    });
  }

  void loadRequestMarkers() {
    FirebaseFirestore.instance
        .collection('requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      final markers = <Marker>[];
      final requests = <Map<String, dynamic>>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final geo = data['location'];
        if (geo != null) {
          final lat = geo.latitude;
          final lng = geo.longitude;
          final bloodGroup = data['bloodGroup'] ?? '?';
          final urgency = data['urgency'] ?? 'Normal';
          markers.add(Marker(
            point: LatLng(lat, lng),
            width: 60,
            height: 60,
            child: GestureDetector(
              onTap: () => Get.snackbar(
                '$bloodGroup needed',
                urgency,
                backgroundColor: const Color(0xFFA32D2D),
                colorText: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA32D2D),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(bloodGroup,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                  const Icon(Icons.location_on,
                      color: Color(0xFFA32D2D), size: 24),
                ],
              ),
            ),
          ));
          requests.add({
            'bloodGroup': bloodGroup,
            'urgency': urgency,
            'lat': lat,
            'lng': lng,
          });
        }
      }
      setState(() {
        requestMarkers = markers;
        activeRequests = requests;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF185FA5),
        foregroundColor: Colors.white,
        title: Row(
          children: const [
            Text('✱ ',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text('Live Map',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search),
          )
        ],
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 320,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: const MapOptions(
                    initialCenter: LatLng(21.1458, 79.0882),
                    initialZoom: 13,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName:
                          'com.example.flutter_application_1',
                    ),
                    MarkerLayer(
                        markers: [
                      ...requestMarkers,
                      ...hospitalMarkers,
                      ...ambulanceMarkers,
                    ]),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _legend(
                            const Color(0xFFA32D2D), 'Blood Request'),
                        _legend(
                            const Color(0xFF185FA5), 'Hospital'),
                        _legend(
                            const Color(0xFFBA7517), 'Ambulance'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Active Requests',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111))),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFA32D2D),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text('${activeRequests.length} Live',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFA32D2D))),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: activeRequests.isEmpty
                ? const Center(
                    child: Text('No active requests',
                        style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: activeRequests.length,
                    itemBuilder: (context, i) {
                      final r = activeRequests[i];
                      return GestureDetector(
                        onTap: () => mapController.move(
                          LatLng(r['lat'], r['lng']),
                          15,
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Color(0xFFA32D2D), size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${r['bloodGroup']} Blood Needed',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF111111))),
                                    Text(
                                        '${(r['lat'] as double).toStringAsFixed(4)}° N, ${(r['lng'] as double).toStringAsFixed(4)}° E',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right,
                                  color: Colors.grey),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border:
              Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home, 'HOME', false,
                () => Get.offAll(() => const DashboardScreen())),
            _navItem(Icons.explore, 'MAP', true, () {}),
            _navItem(Icons.rss_feed, 'FEED', false,
                () => Get.to(() => const FeedScreen())),
          ],
        ),
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF555555))),
      ],
    );
  }

  Widget _navItem(
      IconData icon, String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFE3F2FD)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: active
                    ? const Color(0xFF185FA5)
                    : const Color(0xFF888888),
                size: 22),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: active
                        ? const Color(0xFF185FA5)
                        : const Color(0xFF888888))),
          ],
        ),
      ),
    );
  }
}