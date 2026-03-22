import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'request_form_screen.dart';
import 'map_screen.dart';
import 'dashboard_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  Color _urgencyColor(String urgency) {
    switch (urgency) {
      case 'Critical': return const Color(0xFFA32D2D);
      case 'Urgent': return const Color(0xFFBA7517);
      default: return const Color(0xFF3B6D11);
    }
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Row(
                    children: [
                      Text('✱',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFFA32D2D),
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: 6),
                      Text('Live Feed',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFA32D2D))),
                    ],
                  ),
                  Icon(Icons.notifications_outlined,
                      size: 24, color: Color(0xFF333333)),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Real-time Requests',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111111))),
                  SizedBox(height: 4),
                  Text('Updates on critical blood needs in your vicinity.',
                      style:
                          TextStyle(fontSize: 14, color: Color(0xFF888888))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('requests')
                    .where('status', isEqualTo: 'pending')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFFA32D2D)));
                  }
                  final docs = snapshot.data?.docs ?? [];
                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      ...docs.map((doc) {
                        final data =
                            doc.data() as Map<String, dynamic>;
                        final urgency = data['urgency'] ?? 'Normal';
                        final bloodGroup = data['bloodGroup'] ?? '?';
                        final urgencyColor = _urgencyColor(urgency);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFCEBEB),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(bloodGroup,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFFA32D2D))),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('$bloodGroup blood needed',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF111111))),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: urgencyColor,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                          urgency.toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 0.5)),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0F6E56),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      if (docs.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEAF3DE),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check,
                                    color: Color(0xFF0F6E56), size: 32),
                              ),
                              const SizedBox(height: 12),
                              const Text('No active requests nearby',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF888888))),
                              const SizedBox(height: 4),
                              const Text(
                                  'All current requirements are fulfilled.',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFFAAAAAA))),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const RequestFormScreen()),
        backgroundColor: const Color(0xFFA32D2D),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home, 'HOME', false,
                () => Get.offAll(() => const DashboardScreen())),
            _navItem(Icons.explore, 'MAP', false,
                () => Get.to(() => const MapScreen())),
            _navItem(Icons.rss_feed, 'FEED', true, () {}),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
      IconData icon, String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFFCEBEB)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: active
                    ? const Color(0xFFA32D2D)
                    : const Color(0xFF888888),
                size: 22),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: active
                        ? const Color(0xFFA32D2D)
                        : const Color(0xFF888888))),
          ],
        ),
      ),
    );
  }
}