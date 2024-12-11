import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Remove shadow
        backgroundColor: Colors.white, // White background for AppBar
      ),
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center content vertically
        children: [
          // Logo
          const Image(
            image: AssetImage(
                'lib/assets/images/logo1.png'), // Replace with your logo path
            height: 350, // Adjust the height of the logo
          ),
          const SizedBox(height: 20), // Spacing between logo and text
        ],
      ),
    );
  }
}
