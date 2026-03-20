import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'request_form_screen.dart';
import 'map_screen.dart';
import 'hospital_screen.dart';
import 'ambulance_screen.dart';
import 'feed_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isAvailable = true;
  String userName = '';
  String bloodGroup = '';
  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    if (doc.exists) {
      setState(() {
        userName = doc['name'] ?? '';
        bloodGroup = doc['bloodGroup'] ?? '';
        isAvailable = doc['available'] ?? true;
      });
    }
  }

  void toggleAvailability() async {
    if (uid == null) return;
    setState(() => isAvailable = !isAvailable);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'available': isAvailable});
    Get.snackbar(
      'Status Updated',
      isAvailable ? 'You are now available for donation' : 'You are now unavailable',
      backgroundColor: isAvailable ? Colors.green : Colors.grey,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, $userName',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      Text('Blood Group: $bloodGroup',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? Colors.green.shade100
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isAvailable ? 'Available' : 'Unavailable',
                      style: TextStyle(
                        color: isAvailable ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('requests')
                    .where('status', isEqualTo: 'pending')
                    .snapshots(),
                builder: (context, snapshot) {
                  final count = snapshot.data?.docs.length ?? 0;
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE24B4A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Active Emergencies',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13)),
                        Text('$count',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold)),
                        const Text('requests need help right now',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _tile(
                      icon: Icons.bloodtype,
                      label: 'Request Blood',
                      color: const Color(0xFFE24B4A),
                      onTap: () => Get.to(() => const RequestFormScreen()),
                    ),
                    _tile(
                      icon: isAvailable
                          ? Icons.toggle_on
                          : Icons.toggle_off,
                      label: isAvailable ? 'Available' : 'Unavailable',
                      color: isAvailable ? Colors.green : Colors.grey,
                      onTap: toggleAvailability,
                    ),
                    _tile(
                      icon: Icons.map,
                      label: 'Live Map',
                      color: Colors.blue,
                      onTap: () => Get.to(() => const MapScreen()),
                    ),
                    _tile(
                      icon: Icons.local_hospital,
                      label: 'Hospitals',
                      color: Colors.teal,
                      onTap: () => Get.to(() => const HospitalScreen()),
                    ),
                    _tile(
                      icon: Icons.emergency,
                      label: 'Ambulance',
                      color: Colors.orange,
                      onTap: () => Get.to(() => const AmbulanceScreen()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFFE24B4A),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
        ],
        onTap: (i) {
          if (i == 1) Get.to(() => const MapScreen());
          if (i == 2) Get.to(() => const FeedScreen());
        },
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color)),
          ],
        ),
      ),
    );
  }
}