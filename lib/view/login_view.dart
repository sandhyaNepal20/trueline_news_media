// import 'package:flutter/material.dart';
// import 'package:trueline_news_media/view/Homepage_view.dart';
// import 'package:trueline_news_media/view/signup_view.dart';

// class LoginView extends StatefulWidget {
//   const LoginView({super.key});

//   @override
//   State<LoginView> createState() => _LoginViewState();
// }

// class _LoginViewState extends State<LoginView> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isPasswordVisible = false;

//   void _handleLogin() {
//     if (_formKey.currentState!.validate()) {
//       // Show success snack bar
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Login Successful!'),
//           backgroundColor: Colors.green,
//           duration: Duration(seconds: 2),
//         ),
//       );

//       // Navigate to LoginView after delay
//       Future.delayed(const Duration(seconds: 1), () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//         );
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Login'),
//           centerTitle: true,
//           automaticallyImplyLeading: false, // Disable back button if needed
//         ),
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Logo
//                   Image.asset(
//                     'assets/images/logo1.png', // Replace with your image path
//                     height: 200,
//                   ),

//                   // Login title
//                   const Text(
//                     'Log In',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF004AAD),
//                     ),
//                   ),
//                   const SizedBox(height: 30),

//                   // Login Form
//                   Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         // Email input
//                         TextFormField(
//                           controller: _emailController,
//                           decoration: InputDecoration(
//                             labelText: 'Email', // Label text
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             prefixIcon: const Icon(
//                               Icons.email,
//                               color: Color(0xFF004AAD),
//                             ),
//                           ),
//                           validator: _validateEmail,
//                         ),
//                         const SizedBox(height: 15),

//                         // Password input with visibility toggle
//                         TextFormField(
//                           controller: _passwordController,
//                           obscureText: !_isPasswordVisible,
//                           decoration: InputDecoration(
//                             labelText: 'Password', // Label text
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             prefixIcon: const Icon(
//                               Icons.lock,
//                               color: Color(0xFF004AAD),
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _isPasswordVisible
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                                 color: const Color(0xFF004AAD),
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _isPasswordVisible = !_isPasswordVisible;
//                                 });
//                               },
//                             ),
//                           ),
//                           validator: _validatePassword,
//                         ),
//                         const SizedBox(height: 10),

//                         // Forget Password
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: () {
//                               // Handle forget password
//                             },
//                             child: const Text(
//                               'Forget Password?',
//                               style: TextStyle(color: Color(0xFF004AAD)),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),

//                         // Sign in button
//                         SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: _handleLogin,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF004AAD),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               padding: const EdgeInsets.symmetric(vertical: 15),
//                             ),
//                             child: const Text(
//                               'Sign in',
//                               style:
//                                   TextStyle(fontSize: 18, color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),

//                         // Or sign in with
//                         const Text(
//                           'Or sign in with',
//                           style: TextStyle(color: Color(0xFF004AAD)),
//                         ),
//                         const SizedBox(height: 10),

//                         // Social media icons
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             _buildSocialButton(
//                                 'Google', Colors.red, Icons.email),
//                             const SizedBox(width: 10),
//                             _buildSocialButton('Facebook',
//                                 const Color(0xFF004AAD), Icons.facebook),
//                             const SizedBox(width: 10),
//                           ],
//                         ),
//                         const SizedBox(height: 20),

//                         // Sign up
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text('Don’t have account? '),
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => const SignUpView()),
//                                 );
//                               },
//                               child: const Text(
//                                 'Sign Up',
//                                 style: TextStyle(
//                                   color: Color(0xFF004AAD),
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }

//   // Social button builder
//   Widget _buildSocialButton(String name, Color color, IconData icon) {
//     return GestureDetector(
//       onTap: () {
//         // Handle social sign-in
//       },
//       child: CircleAvatar(
//         backgroundColor: color,
//         radius: 20,
//         child: Icon(icon, color: Colors.white),
//       ),
//     );
//   }

//   // Validation Functions
//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email';
//     }
//     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//       return 'Please enter a valid email address';
//     }
//     return null;
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your password';
//     }
//     return null;
//   }
// }
