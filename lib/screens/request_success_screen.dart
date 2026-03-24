import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dashboard_screen.dart';

class RequestSuccessScreen extends StatelessWidget {
  final String bloodGroup;
  final String urgency;

  const RequestSuccessScreen({
    super.key,
    required this.bloodGroup,
    required this.urgency,
  });

  final List<Map<String, dynamic>> bloodBanks = const [
    {
      'name': 'Balaji Blood Bank & Component Lab',
      'address': 'Rajapeth, Amravati',
      'phone': '07122742776',
      'distance': '1.2 km',
      'inventory': {
        'O+': 4, 'O-': 1, 'A+': 2, 'A-': 0,
        'B+': 3, 'B-': 0, 'AB+': 1, 'AB-': 0
      },
    },
    {
      'name': 'Shri Balaji Blood Bank',
      'address': 'Railway bridge, Ambapeth, Amravati',
      'phone': '07122533399',
      'distance': '2.8 km',
      'inventory': {
        'O+': 6, 'O-': 2, 'A+': 0, 'A-': 1,
        'B+': 4, 'B-': 2, 'AB+': 0, 'AB-': 1
      },
    },
    {
      'name': 'Sant Gadgebaba Blood Bank',
      'address': 'Opposite Srihari Hospital, Badnera Road, Amravati',
      'phone': '07122244444',
      'distance': '4.1 km',
      'inventory': {
        'O+': 2, 'O-': 0, 'A+': 5, 'A-': 1,
        'B+': 0, 'B-': 0, 'AB+': 3, 'AB-': 1
      },
    },
    {
      'name': 'Pdmc Blood Bank',
      'address': 'Panchavati, Amravati',
      'phone': '07122228888',
      'distance': '3.4 km',
      'inventory': {
        'O+': 0, 'O-': 0, 'A+': 3, 'A-': 2,
        'B+': 1, 'B-': 0, 'AB+': 2, 'AB-': 0
      },
    },
  ];

  Color _urgencyColor(String urgency) {
    switch (urgency) {
      case 'Critical':
        return const Color(0xFFA32D2D);
      case 'Urgent':
        return const Color(0xFFBA7517);
      default:
        return const Color(0xFF3B6D11);
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableBanks = bloodBanks.where((bank) {
      final inventory = bank['inventory'] as Map<String, dynamic>;
      final units = inventory[bloodGroup] ?? 0;
      return units > 0;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF3DE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle,
                    color: Color(0xFF0F6E56), size: 48),
              ),
              const SizedBox(height: 16),
              const Text('Request Sent!',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111111))),
              const SizedBox(height: 8),
              const Text(
                'Your blood request has been submitted.\nNearby donors have been alerted.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCEBEB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(bloodGroup,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFA32D2D))),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _urgencyColor(urgency).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(urgency,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _urgencyColor(urgency))),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ✅ DONOR ACCEPTED POPUP CARD
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('requests')
                    .where('status', isEqualTo: 'accepted')
                    .where('bloodGroup', isEqualTo: bloodGroup)
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFFBA7517),
                            width: 1),
                      ),
                      child: Row(
                        children: const [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFBA7517),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Waiting for a donor to accept your request...',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFBA7517),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3DE),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFF0F6E56), width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.check_circle,
                                color: Color(0xFF0F6E56), size: 24),
                            SizedBox(width: 8),
                            Text('Request Approved! 🎉',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F6E56))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'A donor has accepted your request and will contact you shortly. Please keep your phone active!',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF3B6D11),
                              height: 1.5),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.directions_walk,
                                  color: Color(0xFF0F6E56), size: 24),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('Donor is on the way!',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF111111))),
                                    Text(
                                        'Stay at your location · Keep phone active',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // NEARBY DONORS COUNT
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('available', isEqualTo: true)
                    .where('bloodGroup', isEqualTo: bloodGroup)
                    .snapshots(),
                builder: (context, snapshot) {
                  final count = snapshot.data?.docs.length ?? 0;
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F1FB),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.people,
                            color: Color(0xFF185FA5), size: 28),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text('$count Nearby Donors',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF185FA5))),
                            Text(
                              'with $bloodGroup blood group available',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // BLOOD BANKS
              if (availableBanks.isNotEmpty) ...[
                Row(
                  children: const [
                    Icon(Icons.local_hospital,
                        color: Color(0xFF0F6E56), size: 20),
                    SizedBox(width: 8),
                    Text('Blood Available At',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111111))),
                  ],
                ),
                const SizedBox(height: 12),
                ...availableBanks.map((bank) {
                  final inventory =
                      bank['inventory'] as Map<String, dynamic>;
                  final units = inventory[bloodGroup] ?? 0;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFF0F6E56), width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF3DE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.local_hospital,
                              color: Color(0xFF0F6E56), size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(bank['name'],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF111111))),
                              Text(bank['address'],
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey)),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 12, color: Colors.grey),
                                  Text(bank['distance'],
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAF3DE),
                                      borderRadius:
                                          BorderRadius.circular(4),
                                    ),
                                    child: Text('$units units',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight:
                                                FontWeight.w700,
                                            color: Color(
                                                0xFF0F6E56))),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => launchUrl(
                              Uri.parse('tel:${bank['phone']}')),
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
                  );
                }),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCEBEB),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.warning,
                          color: Color(0xFFA32D2D), size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No blood banks nearby have this blood group. Nearby donors have been alerted.',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFA32D2D),
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Get.offAll(() => const DashboardScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA32D2D),
                    padding:
                        const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Back to Home',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}