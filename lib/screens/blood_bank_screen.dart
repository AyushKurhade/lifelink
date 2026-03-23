import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodBankScreen extends StatelessWidget {
  const BloodBankScreen({super.key});

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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text('FIND BLOOD BANKS',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: Color(0xFF888888))),
                    const SizedBox(height: 6),
                    const Text('Locate Nearby\nBlood Banks',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111111),
                            height: 1.2)),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCEBEB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.location_searching,
                              color: Color(0xFFA32D2D), size: 48),
                          const SizedBox(height: 12),
                          const Text(
                            'Find blood banks near your current location using Google Maps',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF555555),
                                height: 1.5),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final url = Uri.parse(
                                    'https://www.google.com/maps/search/blood+banks+near+me');
                                await launchUrl(url,
                                    mode: LaunchMode
                                        .externalApplication);
                              },
                              icon: const Icon(Icons.map,
                                  color: Colors.white),
                              label: const Text(
                                  'Find on Google Maps',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFFA32D2D),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('WHAT TO DO',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: Color(0xFF888888))),
                    const SizedBox(height: 12),
                    _stepCard(
                      '1',
                      'Find Nearest Blood Bank',
                      'Use Google Maps to locate the nearest blood bank in your area',
                      Icons.location_on,
                      const Color(0xFFE6F1FB),
                      const Color(0xFF185FA5),
                    ),
                    _stepCard(
                      '2',
                      'Check Availability',
                      'Call the blood bank directly to check blood group availability',
                      Icons.phone,
                      const Color(0xFFEAF3DE),
                      const Color(0xFF0F6E56),
                    ),
                    _stepCard(
                      '3',
                      'Visit or Request Delivery',
                      'Visit the blood bank or arrange for emergency delivery',
                      Icons.local_shipping,
                      const Color(0xFFFAEEDA),
                      const Color(0xFFBA7517),
                    ),
                    _stepCard(
                      '4',
                      'Alert Nearby Donors',
                      'If blood bank has no stock, use Request Blood to alert nearby donors',
                      Icons.people,
                      const Color(0xFFFCEBEB),
                      const Color(0xFFA32D2D),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFFEEEEEE)),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline,
                              color: Colors.grey, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Blood bank data is managed by respective institutions. LifeLink helps you locate and connect with them.',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepCard(String step, String title, String subtitle,
      IconData icon, Color bgColor, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111))),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}