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
  final urgencyLevels = ['Critical', 'Urgent', 'Normal'];

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
        'location': GeoPoint(currentPosition!.latitude, currentPosition!.longitude),
        'createdAt': FieldValue.serverTimestamp(),
        'acceptedBy': null,
      });
      setState(() => isLoading = false);
      Get.back();
      Get.snackbar(
        'Request Sent!',
        'Finding donors near you...',
        backgroundColor: Colors.green,
        colorText: Colors.white,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Request Blood'),
        backgroundColor: const Color(0xFFE24B4A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Blood Group Needed',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: bloodGroups.map((g) {
                final selected = g == selectedBloodGroup;
                return GestureDetector(
                  onTap: () => setState(() => selectedBloodGroup = g),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFE24B4A)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFFE24B4A)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(g,
                        style: TextStyle(
                            color: selected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            const Text('Urgency Level',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Column(
              children: urgencyLevels.map((u) {
                return RadioListTile<String>(
                  title: Text(u),
                  value: u,
                  groupValue: selectedUrgency,
                  activeColor: const Color(0xFFE24B4A),
                  onChanged: (v) => setState(() => selectedUrgency = v!),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFFE24B4A)),
                  const SizedBox(width: 8),
                  Text(
                    currentPosition != null
                        ? 'Location: ${currentPosition!.latitude.toStringAsFixed(4)}, ${currentPosition!.longitude.toStringAsFixed(4)}'
                        : 'Getting location...',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE24B4A),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Send Emergency Request',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}