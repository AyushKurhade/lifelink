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
    {'id': 'AMB-03', 'distance': '7.1 km', 'eta': '11'},
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
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Ambulance'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (!requested) ...[
              const SizedBox(height: 40),
              const Icon(Icons.emergency, size: 80, color: Colors.orange),
              const SizedBox(height: 24),
              const Text('Request Emergency Ambulance',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text('Nearest available unit will be dispatched',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center),
              const SizedBox(height: 40),
              ...ambulances.map((a) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_taxi,
                            color: Colors.orange, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a['id']!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text('${a['distance']} away · ETA ${a['eta']} min',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Available',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  )),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: requestAmbulance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Request Nearest Ambulance',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ] else ...[
              const SizedBox(height: 40),
              const Icon(Icons.local_taxi, size: 80, color: Colors.orange),
              const SizedBox(height: 16),
              const Text('AMB-01 is on the way!',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('3.2 km away',
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 40),
              Text(
                '${(etaSeconds ~/ 60).toString().padLeft(2, '0')}:${(etaSeconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
              const Text('minutes remaining',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: totalSeconds > 0
                      ? 1 - (etaSeconds / totalSeconds)
                      : 1,
                  minHeight: 12,
                  backgroundColor: Colors.orange.shade100,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              ),
              const SizedBox(height: 40),
              if (etaSeconds == 0)
                const Text('Ambulance has arrived!',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.bold)),
            ],
          ],
        ),
      ),
    );
  }
}