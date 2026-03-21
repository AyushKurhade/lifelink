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
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes =
      List.generate(6, (_) => FocusNode());
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
        Get.snackbar(
          'OTP Sent!',
          'Verification code sent to +91${phoneController.text.trim()}',
          backgroundColor: const Color(0xFF0F6E56),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  void verifyOTP() async {
    final otp = otpControllers.map((c) => c.text).join();
    if (otp.length < 6) {
      Get.snackbar('Error', 'Enter complete 6-digit OTP',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    setState(() => isLoading = true);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
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
              final token = await FirebaseMessaging.instance.getToken();
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA32D2D),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('✱',
                      style: TextStyle(
                          fontSize: 32,
                          color: Color(0xFFA32D2D),
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  const Text('LifeLink',
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFA32D2D),
                          letterSpacing: -1)),
                ],
              ),
              const SizedBox(height: 4),
              const Text('Emergency Blood Response',
                  style: TextStyle(fontSize: 17, color: Color(0xFF444444))),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('MOBILE NUMBER',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: Color(0xFF555555))),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                    color: Color(0xFFDDDDDD), width: 1.5),
                              ),
                            ),
                            child: const Text('+91',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Color(0xFF222222))),
                          ),
                          Expanded(
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: const InputDecoration(
                                hintText: '9876543210',
                                hintStyle:
                                    TextStyle(color: Color(0xFFAAAAAA)),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
                                counterText: '',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : sendOTP,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA32D2D),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Send OTP →',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ENTER VERIFICATION CODE',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: Color(0xFF555555))),
                        GestureDetector(
                          onTap: otpSent ? sendOTP : null,
                          child: Text('RESEND',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  color: otpSent
                                      ? const Color(0xFFA32D2D)
                                      : Colors.grey)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: List.generate(6, (i) {
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: i < 5 ? 8 : 0),
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: otpControllers[i],
                              focusNode: otpFocusNodes[i],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              onChanged: (v) {
                                if (v.isNotEmpty && i < 5) {
                                  otpFocusNodes[i + 1].requestFocus();
                                }
                                if (v.isEmpty && i > 0) {
                                  otpFocusNodes[i - 1].requestFocus();
                                }
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : verifyOTP,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A1A),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Verify OTP ✓',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF888888)),
                        children: [
                          TextSpan(
                              text: "By continuing, you agree to LifeLink's "),
                          TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color(0xFF555555))),
                          TextSpan(text: ' and '),
                          TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color(0xFF555555))),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.security,
                            color: Color(0xFF0F6E56), size: 16),
                        SizedBox(width: 4),
                        Text('SECURE DATA',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                color: Color(0xFF555555))),
                        SizedBox(width: 24),
                        Icon(Icons.verified_user,
                            color: Color(0xFF0F6E56), size: 16),
                        SizedBox(width: 4),
                        Text('VERIFIED DONORS',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                color: Color(0xFF555555))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}