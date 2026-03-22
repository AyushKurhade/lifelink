import 'package:flutter/material.dart';
import 'dart:async';

class AmbulanceScreen extends StatefulWidget {
  const AmbulanceScreen({super.key});
  @override
  State<AmbulanceScreen> createState() => _AmbulanceScreenState();
}

class _AmbulanceScreenState extends State<AmbulanceScreen> {
  bool requested = false;
  int etaSeconds = 0;
  int totalSeconds = 0;
  Timer? timer;

  final List<Map<String, String>> ambulances = [
    {'id': 'AMB-01', 'distance': '3.2 km', 'eta': '5'},
    {'id': 'AMB-02', 'distance': '5.8 km', 'eta': '9'},
    {'id': 'AMB-03', 'distance': '7.1 km', 'eta': '12'},
  ];

  void requestAmbulance() {
    final eta = int.parse(ambulances[0]['eta']!) * 60;
    setState(() {
      requested = true;
      etaSeconds = eta;
      totalSeconds = eta;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (etaSeconds <= 0) {
        t.cancel();
        setState(() => etaSeconds = 0);
      } else {
        setState(() => etaSeconds--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: requested ? _buildCountdown() : _buildRequest(),
      ),
    );
  }

  Widget _buildRequest() {
    return Column(
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
                          color: Color(0xFFE67E22),
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 6),
                  Text('Ambulance',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFE67E22))),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close,
                    color: Color(0xFF555555), size: 24),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: 90,
          height: 90,
          decoration: const BoxDecoration(
            color: Color(0xFFFEF0E6),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.emergency,
              color: Color(0xFFE67E22), size: 48),
        ),
        const SizedBox(height: 20),
        const Text('Request Emergency\nAmbulance',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111111),
                height: 1.2)),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Nearest available unit will be dispatched\nto your current location immediately.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                color: Color(0xFF888888),
                height: 1.5),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              ...ambulances.map((a) => Container(
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
                            color: const Color(0xFFFEF0E6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.emergency,
                              color: Color(0xFFE67E22), size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a['id']!,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF111111))),
                              Text(
                                  '${a['distance']} · ETA ${a['eta']} min',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF3DE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('AVAILABLE',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF3B6D11),
                                  letterSpacing: 0.5)),
                        ),
                      ],
                    ),
                  )),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                clipBehavior: Clip.hardEdge,
                child: Container(
                  height: 120,
                  color: const Color(0xFFd4e9d4),
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('ACTIVE SEARCH ZONE',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                color: Colors.grey)),
                        SizedBox(height: 2),
                        Text('Nagpur Central',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFE67E22))),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: requestAmbulance,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE67E22),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.bolt, color: Colors.white, size: 22),
                      SizedBox(width: 8),
                      Text('Request Nearest Ambulance',
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
      ],
    );
  }

  Widget _buildCountdown() {
    final minutes = etaSeconds ~/ 60;
    final seconds = etaSeconds % 60;
    final progress = totalSeconds > 0
        ? 1 - (etaSeconds / totalSeconds)
        : 1.0;

    return Column(
      children: [
        Container(
          color: const Color(0xFFE67E22),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Ambulance En Route',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Text('✱ ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                    Text('EMERGENCY',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emergency,
                      color: Color(0xFFE67E22), size: 54),
                ),
                const SizedBox(height: 20),
                const Text('AMB-01 is on the way!',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111111))),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.location_on,
                        size: 14, color: Colors.grey),
                    Text('3.2 km away',
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFE67E22),
                            height: 1),
                      ),
                      const SizedBox(height: 4),
                      const Text('MINUTES REMAINING',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              color: Colors.grey)),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFF0F0F0),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(
                                  Color(0xFFE67E22)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('DRIVER',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    color: Colors.grey)),
                            const SizedBox(height: 4),
                            const Text('Aditya Deshmukh',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111111))),
                            const SizedBox(height: 8),
                            Row(
                              children: const [
                                Icon(Icons.phone,
                                    size: 14,
                                    color: Color(0xFF0F6E56)),
                                SizedBox(width: 4),
                                Text('Contact',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF0F6E56),
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('VITALS SENT',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    color: Colors.grey)),
                            const SizedBox(height: 4),
                            const Text('Success',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111111))),
                            const SizedBox(height: 8),
                            Row(
                              children: const [
                                Icon(Icons.my_location,
                                    size: 14,
                                    color: Color(0xFF185FA5)),
                                SizedBox(width: 4),
                                Text('Live Map',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF185FA5),
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCEBEB),
                    borderRadius: BorderRadius.circular(14),
                    border: const Border(
                      left: BorderSide(
                          color: Color(0xFFA32D2D), width: 4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.info,
                              color: Color(0xFFA32D2D), size: 18),
                          SizedBox(width: 6),
                          Text('Safety Instructions',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFA32D2D))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Please ensure the building entrance is clear and keep your phone line active.',
                        style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF555555),
                            height: 1.5),
                      ),
                    ],
                  ),
                ),
                if (etaSeconds == 0) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3DE),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle,
                            color: Color(0xFF3B6D11), size: 24),
                        SizedBox(width: 8),
                        Text('Ambulance has arrived!',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3B6D11))),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}