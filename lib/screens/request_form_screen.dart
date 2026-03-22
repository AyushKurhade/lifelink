import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class RequestFormScreen extends StatefulWidget {
  const RequestFormScreen({super.key});
  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  String selectedBloodGroup = 'O+';
  String selectedUrgency = 'Critical';
  bool isLoading = false;
  Position? currentPosition;

  final bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  final urgencyData = [
    {'label': 'Critical', 'sub': 'Immediate', 'color': Color(0xFFA32D2D), 'bg': Color(0xFFFCEBEB)},
    {'label': 'Urgent', 'sub': 'Within 2hrs', 'color': Color(0xFFBA7517), 'bg': Color(0xFFFAEEDA)},
    {'label': 'Normal', 'sub': 'Planned', 'color': Color(0xFF3B6D11), 'bg': Color(0xFFEAF3DE)},
  ];

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void getLocation() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
      final pos = await Geolocator.getCurrentPosition();
      setState(() => currentPosition = pos);
    } catch (e) {
      setState(() => currentPosition = null);
    }
  }

  void submitRequest() async {
    if (currentPosition == null) {
      Get.snackbar('Error', 'Could not get location. Please try again.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    setState(() => isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('requests').add({
        'bloodGroup': selectedBloodGroup,
        'urgency': selectedUrgency,
        'status': 'pending',
        'location': GeoPoint(
            currentPosition!.latitude, currentPosition!.longitude),
        'createdAt': FieldValue.serverTimestamp(),
        'acceptedBy': null,
      });
      setState(() => isLoading = false);
      Get.back();
      Get.snackbar(
        'Request Sent!',
        'Finding donors near you...',
        backgroundColor: const Color(0xFF0F6E56),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar('Error', 'Failed to send request',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA32D2D),
        foregroundColor: Colors.white,
        title: const Text('Request Blood',
            style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('BLOOD GROUP NEEDED',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: Color(0xFF555555))),
                  const SizedBox(height: 14),
                  GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.4,
                    children: bloodGroups.map((g) {
                      final selected = g == selectedBloodGroup;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => selectedBloodGroup = g),
                        child: Container(
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFA32D2D)
                                : const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(g,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFF555555))),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('URGENCY LEVEL',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: Color(0xFF555555))),
                  const SizedBox(height: 14),
                  ...urgencyData.map((u) {
                    final selected =
                        selectedUrgency == u['label'] as String;
                    final color = u['color'] as Color;
                    final bg = u['bg'] as Color;
                    return GestureDetector(
                      onTap: () => setState(
                          () => selectedUrgency = u['label'] as String),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: selected ? bg : const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(10),
                          border: selected
                              ? Border.all(color: color, width: 1.5)
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: selected ? color : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(u['label'] as String,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: selected
                                            ? color
                                            : const Color(0xFF555555))),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(u['sub'] as String,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: selected
                                          ? color
                                          : Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('YOUR LOCATION',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: Color(0xFF555555))),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Color(0xFFA32D2D), size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Nagpur, Maharashtra',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF222222))),
                              Text(
                                currentPosition != null
                                    ? '${currentPosition!.latitude.toStringAsFixed(4)}° N, ${currentPosition!.longitude.toStringAsFixed(4)}° E'
                                    : 'Getting location...',
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF3DE),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.circle,
                                  size: 8, color: Color(0xFF0F6E56)),
                              SizedBox(width: 4),
                              Text('LIVE',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F6E56))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA32D2D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.emergency,
                              color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Send Emergency Request',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}