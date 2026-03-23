import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodBankScreen extends StatelessWidget {
  const BloodBankScreen({super.key});

  final List<Map<String, dynamic>> bloodBanks = const [
    {
      'name': 'GMCH Blood Bank',
      'address': 'Medical Square, Nagpur',
      'phone': '07122742776',
      'distance': '1.2 km',
      'inventory': {
        'O+': 4, 'O-': 1, 'A+': 2, 'A-': 0,
        'B+': 3, 'B-': 0, 'AB+': 1, 'AB-': 0
      },
    },
    {
      'name': 'Red Cross Blood Bank',
      'address': 'Civil Lines, Nagpur',
      'phone': '07122533399',
      'distance': '2.8 km',
      'inventory': {
        'O+': 6, 'O-': 2, 'A+': 0, 'A-': 1,
        'B+': 4, 'B-': 2, 'AB+': 0, 'AB-': 1
      },
    },
    {
      'name': 'Orange City Blood Bank',
      'address': 'Khamla, Nagpur',
      'phone': '07122244444',
      'distance': '4.1 km',
      'inventory': {
        'O+': 2, 'O-': 0, 'A+': 5, 'A-': 1,
        'B+': 0, 'B-': 0, 'AB+': 3, 'AB-': 1
      },
    },
    {
      'name': 'Alexis Blood Bank',
      'address': 'Sitaburdi, Nagpur',
      'phone': '07122228888',
      'distance': '3.4 km',
      'inventory': {
        'O+': 0, 'O-': 0, 'A+': 3, 'A-': 2,
        'B+': 1, 'B-': 0, 'AB+': 2, 'AB-': 0
      },
    },
  ];

  Color _unitColor(int units) {
    if (units == 0) return const Color(0xFFA32D2D);
    if (units <= 2) return const Color(0xFFBA7517);
    return const Color(0xFF0F6E56);
  }

  Color _unitBgColor(int units) {
    if (units == 0) return const Color(0xFFFCEBEB);
    if (units <= 2) return const Color(0xFFFAEEDA);
    return const Color(0xFFEAF3DE);
  }

  bool _hasLowStock(Map<String, dynamic> inventory) {
    return inventory.values.any((v) => v <= 2);
  }

  void _requestDonation(BuildContext context, String bankName,
      Map<String, dynamic> inventory) {
    final lowGroups = inventory.entries
        .where((e) => e.value <= 2)
        .map((e) => e.key)
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.volunteer_activism,
                color: Color(0xFFA32D2D), size: 48),
            const SizedBox(height: 12),
            Text('Request Donation for\n$bankName',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111111))),
            const SizedBox(height: 8),
            Text(
              'Low stock for: ${lowGroups.join(', ')}',
              style: const TextStyle(
                  fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFCEBEB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Nearby donors with matching blood groups will be notified to donate at this blood bank.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFA32D2D),
                    height: 1.5),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  for (final group in lowGroups) {
                    await FirebaseFirestore.instance
                        .collection('requests')
                        .add({
                      'bloodGroup': group,
                      'urgency': 'Urgent',
                      'status': 'pending',
                      'type': 'bank_donation',
                      'bankName': bankName,
                      'location':
                          const GeoPoint(21.1458, 79.0882),
                      'createdAt': FieldValue.serverTimestamp(),
                      'acceptedBy': null,
                    });
                  }
                  Navigator.pop(context);
                  Get.snackbar(
                    'Request Sent!',
                    'Nearby donors have been notified to donate at $bankName',
                    backgroundColor: const Color(0xFF0F6E56),
                    colorText: Colors.white,
                    icon: const Icon(Icons.check_circle,
                        color: Colors.white),
                    duration: const Duration(seconds: 3),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA32D2D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Notify Nearby Donors',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Color(0xFF333333)),
                  ),
                  const SizedBox(width: 12),
                  const Text('Blood Banks',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111111))),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BLOOD AVAILABILITY',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: Color(0xFF888888))),
                  SizedBox(height: 6),
                  Text('Nearby Blood Banks',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111111))),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _legend(const Color(0xFF0F6E56), '4+ units'),
                  const SizedBox(width: 16),
                  _legend(const Color(0xFFBA7517), '1-3 units'),
                  const SizedBox(width: 16),
                  _legend(const Color(0xFFA32D2D), '0 units'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: bloodBanks.length,
                itemBuilder: (context, i) {
                  final bank = bloodBanks[i];
                  final inventory =
                      bank['inventory'] as Map<String, dynamic>;
                  final hasLow = _hasLowStock(inventory);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFCEBEB),
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                    Icons.local_hospital,
                                    color: Color(0xFFA32D2D),
                                    size: 26),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(bank['name'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight:
                                                FontWeight.w700,
                                            color:
                                                Color(0xFF111111))),
                                    const SizedBox(height: 2),
                                    Text(bank['address'],
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey)),
                                    Row(
                                      children: [
                                        const Icon(
                                            Icons.location_on,
                                            size: 12,
                                            color: Colors.grey),
                                        Text(bank['distance'],
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => launchUrl(Uri.parse(
                                    'tel:${bank['phone']}')),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F6E56),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: const Text('Call',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text('INVENTORY',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                      color: Colors.grey)),
                              const SizedBox(height: 10),
                              GridView.count(
                                crossAxisCount: 4,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                childAspectRatio: 1.4,
                                children: inventory.entries
                                    .map((e) {
                                  final units = e.value as int;
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: _unitBgColor(units),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(e.key,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.w700,
                                                color:
                                                    _unitColor(units))),
                                        Text('$units u',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    _unitColor(units))),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              if (hasLow) ...[
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: GestureDetector(
                                    onTap: () => _requestDonation(
                                        context,
                                        bank['name'],
                                        inventory),
                                    child: Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12),
                                      decoration: BoxDecoration(
                                        color:
                                            const Color(0xFFFCEBEB),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        border: Border.all(
                                            color: const Color(
                                                0xFFA32D2D),
                                            width: 1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                              Icons
                                                  .volunteer_activism,
                                              color:
                                                  Color(0xFFA32D2D),
                                              size: 18),
                                          SizedBox(width: 6),
                                          Text(
                                              'Request Donation',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight:
                                                      FontWeight.w700,
                                                  color: Color(
                                                      0xFFA32D2D))),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
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
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: Color(0xFF555555))),
      ],
    );
  }
}