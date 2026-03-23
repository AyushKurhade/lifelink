import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes =
      List.generate(6, (_) => FocusNode());

  String selectedBloodGroup = 'O+';
  String selectedRole = 'Donor';
  String verificationId = '';
  bool otpSent = false;
  bool isLoading = false;

  final bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  final roles = [
    {
      'label': 'Donor',
      'sub': 'I want to donate blood',
    },
    {
      'label': 'Receiver',
      'sub': 'I need blood',
    },
    {
      'label': 'Both',
      'sub': 'I can donate and receive',
    },
  ];

  void sendOTP() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your name',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (phoneController.text.trim().length < 10) {
      Get.snackbar('Error', 'Please enter valid phone number',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
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

  void verifyAndRegister() async {
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
      final token = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'name': nameController.text.trim(),
        'bloodGroup': selectedBloodGroup,
        'phone': phoneController.text.trim(),
        'role': selectedRole,
        'available': selectedRole == 'Donor' || selectedRole == 'Both',
        'lastDonated': '2025-01-01',
        'fcmToken': token ?? '',
        'location': const GeoPoint(21.1458, 79.0882),
      });
      Get.offAll(() => const DashboardScreen());
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar('Error', 'Invalid OTP',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
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
                children: const [
                  Text('✱',
                      style: TextStyle(
                          fontSize: 32,
                          color: Color(0xFFA32D2D),
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Text('LifeLink',
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFA32D2D),
                          letterSpacing: -1)),
                ],
              ),
              const SizedBox(height: 4),
              const Text('Create your account',
                  style:
                      TextStyle(fontSize: 15, color: Color(0xFF444444))),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PERSONAL INFORMATION',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: Color(0xFF555555))),
                    const SizedBox(height: 14),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Full Name',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey)),
                          const SizedBox(height: 4),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your full name',
                              hintStyle:
                                  TextStyle(color: Color(0xFFAAAAAA)),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                                    color: Color(0xFFDDDDDD),
                                    width: 1.5),
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
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Blood Group',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey)),
                          const SizedBox(height: 10),
                          GridView.count(
                            crossAxisCount: 4,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.5,
                            children: bloodGroups.map((g) {
                              final selected = g == selectedBloodGroup;
                              return GestureDetector(
                                onTap: () => setState(
                                    () => selectedBloodGroup = g),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xFFA32D2D)
                                        : const Color(0xFFF2F2F2),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(g,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: selected
                                                ? Colors.white
                                                : const Color(
                                                    0xFF555555))),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (!otpSent)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : sendOTP,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA32D2D),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12)),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Send OTP →',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                        ),
                      ),
                    if (otpSent) ...[
                      const Text('ENTER VERIFICATION CODE',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              color: Color(0xFF555555))),
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(6, (i) {
                          return Expanded(
                            child: Container(
                              margin:
                                  EdgeInsets.only(right: i < 5 ? 8 : 0),
                              height: 48,
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
                                    fontSize: 18,
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
                    ],
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
                    const Text('I AM A',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: Color(0xFF555555))),
                    const SizedBox(height: 14),
                    ...roles.map((r) {
                      final selected = selectedRole == r['label'];
                      return GestureDetector(
                        onTap: () =>
                            setState(() => selectedRole = r['label']!),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFA32D2D)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selected
                                      ? Colors.white
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFFDDDDDD),
                                    width: 2,
                                  ),
                                ),
                                child: selected
                                    ? Center(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFA32D2D),
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(r['label']!,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: selected
                                              ? Colors.white
                                              : const Color(0xFF333333))),
                                  Text(r['sub']!,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: selected
                                              ? Colors.white70
                                              : Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : (otpSent ? verifyAndRegister : sendOTP),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA32D2D),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white)
                      : Text(
                          otpSent ? 'Create Account →' : 'Send OTP →',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => Get.to(() => const LoginScreen()),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 13),
                      children: [
                        TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: Color(0xFF888888))),
                        TextSpan(
                            text: 'Login',
                            style: TextStyle(
                                color: Color(0xFFA32D2D),
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline)),
                      ],
                    ),
                  ),
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