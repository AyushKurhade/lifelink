import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalScreen extends StatelessWidget {
  const HospitalScreen({super.key});

  final List<Map<String, String>> hospitals = const [
    {
      'name': 'GMCH Nagpur',
      'specialty': 'Trauma & General',
      'phone': '07122742776',
      'distance': '1.2 km',
    },
    {
      'name': 'Alexis Hospital',
      'specialty': 'Multi-specialty',
      'phone': '07122228888',
      'distance': '3.4 km',
    },
    {
      'name': 'Wockhardt Hospital',
      'specialty': 'Emergency Care',
      'phone': '07122299999',
      'distance': '4.1 km',
    },
    {
      'name': 'Orange City Hospital',
      'specialty': 'General & Blood Bank',
      'phone': '07122244444',
      'distance': '5.8 km',
    },
    {
      'name': 'KIMS Hospital',
      'specialty': 'Multi-specialty',
      'phone': '07122255555',
      'distance': '7.2 km',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Nearby Hospitals'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: hospitals.length,
        itemBuilder: (context, i) {
          final h = hospitals[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_hospital,
                      color: Colors.teal, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(h['name']!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(h['specialty']!,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 12, color: Colors.grey),
                          Text(h['distance']!,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => launchUrl(
                      Uri.parse('tel:${h['phone']}')),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Call',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}