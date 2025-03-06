import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trueline_news_media/app/shared_prefs/token_shared_prefs.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TokenSharedPrefs tokenSharedPrefs;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _profileImageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    tokenSharedPrefs = TokenSharedPrefs(prefs);

    final userInfo = await tokenSharedPrefs.getUserInfo();

    setState(() {
      _nameController.text = userInfo['fullName'] ?? '';
      _emailController.text = userInfo['email'] ?? '';
      _profileImageController.text = userInfo['profileImage'] ?? '';
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      tokenSharedPrefs = TokenSharedPrefs(prefs);

      // ✅ Save updated details in SharedPreferences
      await tokenSharedPrefs.saveUserInfo(
        _nameController.text,
        _emailController.text,
        'User', // Assuming role remains unchanged
        _profileImageController.text,
      );

      // ✅ Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );

      // ✅ Return to MyProfileView with updated data
      Navigator.pop(context, true);
    }
  }

  bool _isValidUrl(String url) {
    return Uri.tryParse(url)?.hasAbsolutePath == true;
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen width and check if device is tablet
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    // Adjust padding based on device size
    final horizontalPadding = isTablet ? 40.0 : 20.0;
    final avatarRadius = isTablet ? 80.0 : 60.0;

    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Image Preview
                Center(
                  child: CircleAvatar(
                    radius: avatarRadius,
                    backgroundImage:
                        (_isValidUrl(_profileImageController.text) &&
                                _profileImageController.text.isNotEmpty)
                            ? NetworkImage(_profileImageController.text)
                            : const AssetImage("assets/images/profile.png")
                                as ImageProvider,
                  ),
                ),
                const SizedBox(height: 20),
                // Full Name Input
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    prefixIcon:
                        const Icon(Icons.person, color: Color(0xFF004AAD)),
                  ),
                  style: TextStyle(fontSize: isTablet ? 18 : 16),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 15),
                // Email Input (Readonly)
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    prefixIcon:
                        const Icon(Icons.email, color: Color(0xFF004AAD)),
                  ),
                  style: TextStyle(fontSize: isTablet ? 18 : 16),
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004AAD),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding:
                          EdgeInsets.symmetric(vertical: isTablet ? 20 : 15),
                    ),
                    child: Text(
                      "Save Changes",
                      style: TextStyle(
                          fontSize: isTablet ? 18 : 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
