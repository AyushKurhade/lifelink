import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dashboard_screen.dart';
import 'map_screen.dart';
import 'feed_screen.dart';

class HospitalScreen extends StatelessWidget {
  const HospitalScreen({super.key});

final List<Map<String, String>> hospitals = const [
    {
      'name': 'GMC Amravati',
      'specialty': 'Trauma & General',
      'distance': '1.1 km',
      'type': 'Government',
    },
    {
      'name': 'Daga Hospital',
      'specialty': 'Multi-specialty',
      'distance': '2.3 km',
      'type': 'Private',
    },
    {
      'name': 'Kasliwal Hospital',
      'specialty': 'Emergency Care',
      'distance': '3.1 km',
      'type': 'Private',
    },
    {
      'name': 'Vaibhav Hospital',
      'specialty': 'General & Blood Bank',
      'distance': '3.8 km',
      'type': 'Private',
    },
    {
      'name': 'Shri Hospital',
      'specialty': 'Multi-specialty',
      'distance': '5.2 km',
      'type': 'Private',
    },
  ];

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
                  Text('Nearby Hospitals',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F6E56))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CLINICAL SANCTUARY',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: Color(0xFF888888))),
                  const SizedBox(height: 6),
                  const Text('Critical Facilities\nWithin Reach',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111111),
                          height: 1.2)),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final url = Uri.parse(
                          'https://www.google.com/maps/search/hospitals+near+me');
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.location_on,
                              color: Color(0xFF0F6E56), size: 20),
                          SizedBox(width: 8),
                          Text(
                              'Scanning 10km radius from Amravati, India',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF555555))),
                          Spacer(),
                          Icon(Icons.open_in_new,
                              color: Colors.grey, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: hospitals.length + 1,
                itemBuilder: (context, i) {
                  if (i == hospitals.length) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.map_outlined,
                              size: 36, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Viewing hospitals within Nagpur city limits.\nTap the location bar above to find more on Google Maps.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                height: 1.5),
                          ),
                        ],
                      ),
                    );
                  }
                  final h = hospitals[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F6E56),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(h['name']!,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF111111))),
                              const SizedBox(height: 2),
                              Text(h['specialty']!,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 12,
                                      color: Color(0xFF0F6E56)),
                                  const SizedBox(width: 2),
                                  Text(h['distance']!,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0F6E56),
                                          fontWeight:
                                              FontWeight.w600)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2),
                                    decoration: BoxDecoration(
                                      color: h['type'] == 'Government'
                                          ? const Color(0xFFE6F1FB)
                                          : const Color(0xFFF2F2F2),
                                      borderRadius:
                                          BorderRadius.circular(4),
                                    ),
                                    child: Text(h['type']!,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight:
                                                FontWeight.w600,
                                            color: h['type'] ==
                                                    'Government'
                                                ? const Color(
                                                    0xFF185FA5)
                                                : Colors.grey)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final url = Uri.parse(
                                'https://www.google.com/maps/search/${Uri.encodeComponent(h['name']! + ' Nagpur')}');
                            await launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F6E56),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.directions,
                                color: Colors.white, size: 18),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final url = Uri.parse(
              'https://www.google.com/maps/search/hospitals+near+me');
          await launchUrl(url, mode: LaunchMode.externalApplication);
        },
        backgroundColor: const Color(0xFF0F6E56),
        child: const Icon(Icons.map, color: Colors.white),
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
            _navItem(Icons.rss_feed, 'FEED', false,
                () => Get.to(() => const FeedScreen())),
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
              ? const Color(0xFFE1F5EE)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: active
                    ? const Color(0xFF0F6E56)
                    : const Color(0xFF888888),
                size: 22),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: active
                        ? const Color(0xFF0F6E56)
                        : const Color(0xFF888888))),
          ],
        ),
      ),
    );
  }
}