import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final nameController = TextEditingController();
  String selectedBloodGroup = 'O+';
  String verificationId = '';
  bool otpSent = false;
  bool isLoading = false;

  final bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  void sendOTP() async {
    setState(() => isLoading = true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${phoneController.text.trim()}',
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        setState(() => isLoading = false);
        Get.snackbar('Error', e.message ?? 'Verification failed',
            backgroundColor: Colors.red, colorText: Colors.white);
      },
      codeSent: (vId, _) {
        setState(() {
          verificationId = vId;
          otpSent = true;
          isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  void verifyOTP() async {
    setState(() => isLoading = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text.trim(),
      );
      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final uid = result.user!.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (!doc.exists) {
        showProfileDialog(uid);
      } else {
        Get.offAll(() => const DashboardScreen());
      }
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar('Error', 'Invalid OTP',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void showProfileDialog(String uid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Complete Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Your Name'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedBloodGroup,
              items: bloodGroups
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => selectedBloodGroup = v!,
              decoration: const InputDecoration(labelText: 'Blood Group'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final token =
                  await FirebaseMessaging.instance.getToken();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .set({
                'uid': uid,
                'name': nameController.text.trim(),
                'bloodGroup': selectedBloodGroup,
                'phone': phoneController.text.trim(),
                'available': true,
                'lastDonated': '2025-01-01',
                'fcmToken': token ?? '',
                'location': const GeoPoint(21.1458, 79.0882),
              });
              Get.offAll(() => const DashboardScreen());
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text('LifeLink',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE24B4A))),
              const Text('Emergency Blood Response',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 60),
              if (!otpSent) ...[
                const Text('Enter your phone number',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    prefixText: '+91 ',
                    hintText: '9876543210',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : sendOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE24B4A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Send OTP',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ] else ...[
                const Text('Enter OTP',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    hintText: '6-digit OTP',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE24B4A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Verify OTP',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}