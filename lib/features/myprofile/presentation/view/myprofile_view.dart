import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trueline_news_media/app/shared_prefs/token_shared_prefs.dart';

import 'editprofile_view.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  _MyProfileViewState createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  late TokenSharedPrefs tokenSharedPrefs;
  String fullName = '';
  String email = '';
  String profileImage = '';

  // Sensor variables for parallax movement and shake detection
  Offset offset = Offset.zero;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShakeTime; // Cooldown for shake events

  @override
  void initState() {
    super.initState();
    _loadUserInfo();

    // Listen to accelerometer events.
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      // Debug log sensor values.
      print("Accelerometer: x=${event.x}, y=${event.y}, z=${event.z}");

      // Parallax effect: Adjust the multiplier as needed.
      double dx = event.x * 10.0;
      double dy = event.y * 10.0;
      setState(() {
        offset = Offset(dx, dy);
      });

      // Shake detection logic:
      double gForce =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      // Lowered threshold for testing (try adjusting if necessary).
      if (gForce > 15) {
        final now = DateTime.now();
        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!) > const Duration(seconds: 2)) {
          _lastShakeTime = now;
          print("Shake detected with gForce: $gForce");
          _logout();
        }
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    tokenSharedPrefs = TokenSharedPrefs(prefs);
    final userInfo = await tokenSharedPrefs.getUserInfo();
    setState(() {
      fullName = userInfo['fullName'] ?? 'N/A';
      email = userInfo['email'] ?? 'N/A';
      profileImage = userInfo['profileImage'] ?? '';
    });
  }

  Future<void> _logout() async {
    print("Logging out...");
    final prefs = await SharedPreferences.getInstance();
    tokenSharedPrefs = TokenSharedPrefs(prefs);
    await tokenSharedPrefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  bool _isValidUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath == true;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      // Apply sensor offset for parallax effect.
      body: Transform.translate(
        offset: offset,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32.0 : 16.0,
            vertical: 20.0,
          ),
          child: Column(
            children: [
              SizedBox(height: isTablet ? 30 : 20),
              Center(
                child: CircleAvatar(
                  radius: isTablet ? 80 : 60,
                  backgroundImage:
                      (_isValidUrl(profileImage) && profileImage.isNotEmpty)
                          ? NetworkImage(profileImage)
                          : const AssetImage("assets/images/profile.png")
                              as ImageProvider,
                ),
              ),
              SizedBox(height: isTablet ? 20 : 10),
              Text(
                fullName.isNotEmpty ? fullName : "Loading...",
                style: TextStyle(
                  fontSize: isTablet ? 26 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                email.isNotEmpty ? email : "Loading...",
                style: TextStyle(
                  fontSize: isTablet ? 20 : 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: isTablet ? 40 : 20),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit, color: Color(0xFF004AAD)),
                      title: const Text("Edit Profile"),
                      onTap: () async {
                        bool? updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfileView()),
                        );
                        if (updated == true) {
                          _loadUserInfo();
                        }
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.settings, color: Color(0xFF004AAD)),
                      title: const Text("Settings"),
                      onTap: () {
                        // Handle settings tap.
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications,
                          color: Color(0xFF004AAD)),
                      title: const Text("Notifications"),
                      onTap: () {
                        // Handle notifications tap.
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.help_outline,
                          color: Color(0xFF004AAD)),
                      title: const Text("FAQ"),
                      onTap: () {
                        // Handle FAQ tap.
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.info, color: Color(0xFF004AAD)),
                      title: const Text("About App"),
                      onTap: () {
                        // Handle About App tap.
                      },
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
