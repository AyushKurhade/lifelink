import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'request_form_screen.dart';
import 'map_screen.dart';
import 'hospital_screen.dart';
import 'ambulance_screen.dart';
import 'feed_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isAvailable = true;
  String userName = '';
  String bloodGroup = '';
  String phone = '';
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
        phone = doc['phone'] ?? '';
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
      isAvailable ? 'You are now available' : 'You are now unavailable',
      backgroundColor: isAvailable ? Colors.green : Colors.grey,
      colorText: Colors.white,
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => const LoginScreen());
  }

  void showProfile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(24)),
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
              CircleAvatar(
                radius: 36,
                backgroundColor: const Color(0xFFD4A574),
                child: Text(
                  userName.isNotEmpty
                      ? userName[0].toUpperCase()
                      : 'A',
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              Text(userName,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111111))),
              const SizedBox(height: 4),
              Text('+91 $phone',
                  style: const TextStyle(
                      fontSize: 14, color: Colors.grey)),
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
                      color: isAvailable
                          ? const Color(0xFFEAF3DE)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isAvailable ? 'Available' : 'Unavailable',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isAvailable
                              ? const Color(0xFF3B6D11)
                              : Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEAF3DE),
                  child: Icon(Icons.bloodtype,
                      color: Color(0xFF3B6D11), size: 20),
                ),
                title: const Text('Blood Group',
                    style:
                        TextStyle(fontWeight: FontWeight.w600)),
                trailing: Text(bloodGroup,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFA32D2D),
                        fontSize: 16)),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE6F1FB),
                  child: Icon(Icons.phone,
                      color: Color(0xFF185FA5), size: 20),
                ),
                title: const Text('Phone',
                    style:
                        TextStyle(fontWeight: FontWeight.w600)),
                trailing: Text('+91 $phone',
                    style:
                        const TextStyle(color: Colors.grey)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    logout();
                  },
                  icon: const Icon(Icons.logout,
                      color: Colors.white),
                  label: const Text('Logout',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA32D2D),
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Text('✱',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF0F6E56),
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 6),
                        Text('LifeLink',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F6E56))),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.notifications_outlined,
                            size: 24,
                            color: Color(0xFF333333)),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: showProfile,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                const Color(0xFFD4A574),
                            child: Text(
                              userName.isNotEmpty
                                  ? userName[0].toUpperCase()
                                  : 'A',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: logout,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCEBEB),
                              borderRadius:
                                  BorderRadius.circular(8),
                              border: Border.all(
                                  color: const Color(0xFFF7C1C1),
                                  width: 1.5),
                            ),
                            child: const Icon(Icons.logout,
                                color: Color(0xFFA32D2D),
                                size: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Hello, ${userName.split(' ').first}',
                            style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111111))),
                        Text('Blood Group $bloodGroup',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF666666))),
                      ],
                    ),
                    GestureDetector(
                      onTap: toggleAvailability,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: isAvailable
                                  ? const Color(0xFF0F6E56)
                                  : Colors.grey,
                              width: 1.5),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isAvailable
                                    ? const Color(0xFF0F6E56)
                                    : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isAvailable
                                  ? 'Available ✓'
                                  : 'Unavailable',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isAvailable
                                      ? const Color(0xFF0F6E56)
                                      : Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('requests')
                      .where('status', isEqualTo: 'pending')
                      .snapshots(),
                  builder: (context, snapshot) {
                    final count =
                        snapshot.data?.docs.length ?? 0;
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC0392B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text('ACTIVE EMERGENCIES',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                  color: Colors.white70)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text('$count',
                                  style: const TextStyle(
                                      fontSize: 52,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      height: 1)),
                              const SizedBox(width: 12),
                              const Text(
                                  'requests need help\nright now',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      height: 1.4)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => Get.to(
                                () => const FeedScreen()),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                              child: const Text(
                                  'View Requests →',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                          FontWeight.w600,
                                      color:
                                          Color(0xFFA32D2D))),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  children: [
                    _tile(
                      icon: Icons.bloodtype,
                      label: 'Request Blood',
                      iconBg: const Color(0xFFFCEBEB),
                      iconColor: const Color(0xFFA32D2D),
                      onTap: () => Get.to(
                          () => const RequestFormScreen()),
                    ),
                    _tile(
                      icon: isAvailable
                          ? Icons.toggle_on
                          : Icons.toggle_off,
                      label: isAvailable
                          ? 'Available'
                          : 'Unavailable',
                      iconBg: const Color(0xFFEAF3DE),
                      iconColor: const Color(0xFF3B6D11),
                      onTap: toggleAvailability,
                    ),
                    _tile(
                      icon: Icons.explore,
                      label: 'Live Map',
                      iconBg: const Color(0xFFE6F1FB),
                      iconColor: const Color(0xFF185FA5),
                      onTap: () =>
                          Get.to(() => const MapScreen()),
                    ),
                    _tile(
                      icon: Icons.local_hospital,
                      label: 'Hospitals',
                      iconBg: const Color(0xFFE1F5EE),
                      iconColor: const Color(0xFF0F6E56),
                      onTap: () =>
                          Get.to(() => const HospitalScreen()),
                    ),
                    _tile(
                      icon: Icons.emergency,
                      label: 'Ambulance',
                      iconBg: const Color(0xFFFAEEDA),
                      iconColor: const Color(0xFFBA7517),
                      onTap: () => Get.to(
                          () => const AmbulanceScreen()),
                    ),
                    _tile(
                      icon: Icons.history,
                      label: 'History',
                      iconBg: const Color(0xFFEEEDFE),
                      iconColor: const Color(0xFF534AB7),
                      onTap: () => Get.snackbar(
                        'Coming Soon',
                        'History feature coming soon!',
                        backgroundColor: Colors.purple,
                        colorText: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text('Nearby Donors',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111))),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('available', isEqualTo: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20),
                      child: Text('No donors nearby',
                          style:
                              TextStyle(color: Colors.grey)),
                    );
                  }
                  final donors = snapshot.data!.docs
                      .where((d) => d.id != uid)
                      .toList();
                  return ListView.separated(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20),
                    itemCount: donors.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final data = donors[i].data()
                          as Map<String, dynamic>;
                      final name = data['name'] ?? 'Unknown';
                      final bg = data['bloodGroup'] ?? '?';
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  const Color(0xFF0F6E56),
                              child: Text(
                                name.isNotEmpty
                                    ? name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(name,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight:
                                              FontWeight.w600,
                                          color: Color(
                                              0xFF111111))),
                                  const Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          size: 12,
                                          color: Colors.grey),
                                      Text('Nearby',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(bg,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        Color(0xFFA32D2D))),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home, 'HOME', true, () {}),
            _navItem(Icons.map, 'MAP', false,
                () => Get.to(() => const MapScreen())),
            _navItem(Icons.rss_feed, 'FEED', false,
                () => Get.to(() => const FeedScreen())),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String label,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF222222))),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 20),
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