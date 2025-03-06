import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trueline_news_media/features/auth/presentation/view/register_view.dart';
import 'package:trueline_news_media/features/auth/presentation/view_model/login/login_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600; // Detect tablet screens

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet
                    ? screenWidth * 0.2
                    : 20, // Adjust padding for tablets
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo1.png',
                    height: isTablet ? 250 : 200, // Adjust size for tablets
                  ),

                  // Login title
                  Text(
                    'Log In',
                    style: TextStyle(
                      fontSize:
                          isTablet ? 28 : 24, // Adjust font size for tablets
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF004AAD),
                    ),
                  ),
                  const SizedBox(height: 30),

                  Column(
                    children: [
                      // Email input
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Color(0xFF004AAD),
                          ),
                        ),
                        style: TextStyle(fontSize: isTablet ? 18 : 16),
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 15),

                      // Password input with visibility toggle
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color(0xFF004AAD),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color(0xFF004AAD),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        style: TextStyle(fontSize: isTablet ? 18 : 16),
                        validator: _validatePassword,
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(
                                    LoginUserEvent(
                                      context: context,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF004AAD),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: isTablet ? 20 : 15), // Adjust padding
                          ),
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 18, // Adjust font size
                              color: Colors.white,
                            ),
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
                          _buildSocialButton('Facebook',
                              const Color(0xFF004AAD), Icons.facebook),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Sign up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don’t have an account? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterView()),
                              );
                            },
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Social button builder
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

  // Validation Functions
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }
}
