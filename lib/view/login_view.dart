import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Track password visibility
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'lib/assets/images/logo1.png', // Replace with your image path
                height: 200,
              ),

              // Login title
              const Text(
                'Log In',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004AAD),
                ),
              ),
              const SizedBox(height: 30),
              // Email input
              TextField(
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.person, color: Color(0xFF004AAD)),
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Password input with visibility toggle
              TextField(
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF004AAD)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Color(0xFF004AAD),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Forget Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle forget password
                  },
                  child: const Text(
                    'Forget Password?',
                    style: TextStyle(color: Color(0xFF004AAD)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Sign in button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 18),
                    selectionColor: Color(0xFF004AAD),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Or sign in with
              const Text(
                'Or sign in with',
                style: TextStyle(color: Color(0xFF004AAD)),
              ),
              const SizedBox(height: 10),
              // Social media icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialButton('Google', Colors.red, Icons.email),
                  const SizedBox(width: 10),
                  _buildSocialButton(
                      'Facebook', Color(0xFF004AAD), Icons.facebook),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 20),
              // Sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don’t have account? '),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFF004AAD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String name, Color color, IconData icon) {
    return GestureDetector(
      onTap: () {
        // Handle social sign-in
      },
      child: CircleAvatar(
        backgroundColor: color,
        radius: 20,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
