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
          // Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SizedBox(
              width: double.infinity, // Full-width button
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004AAD), //button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15), // Button height
                ),
                child: const Text(
                  'Stay Updated >>',
                  style: TextStyle(
                    color: Colors.white, // White text
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
