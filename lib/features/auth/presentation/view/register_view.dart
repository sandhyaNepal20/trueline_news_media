import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trueline_news_media/features/auth/presentation/view_model/signup/signup_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF004AAD)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                _pickImage(ImageSource.camera);
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.camera),
                              label: const Text('Camera'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _pickImage(ImageSource.gallery);
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.image),
                              label: const Text('Gallery'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : const AssetImage('assets/images/profile.jpg')
                            as ImageProvider,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004AAD)),
                ),
                const SizedBox(height: 20),
                _buildTextField(_fullNameController, 'Full Name', Icons.person,
                    _validateFullName),
                const SizedBox(height: 15),
                _buildTextField(
                    _emailController, 'Email', Icons.email, _validateEmail),
                const SizedBox(height: 15),
                _buildPasswordField(
                    _passwordController, 'Password', _isPasswordVisible, () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                }),
                const SizedBox(height: 15),
                _buildPasswordField(_confirmPasswordController,
                    'Confirm Password', _isConfirmPasswordVisible, () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                }),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final registerState = context.read<SignupBloc>().state;
                        final imageName = registerState.imageName;
                        context.read<SignupBloc>().add(
                              RegisterUser(
                                context: context,
                                fullName: _fullNameController.text,
                                email: _emailController.text,
                                password: _confirmPasswordController.text,
                                image: imageName,
                              ),
                            );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004AAD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                            color: Color(0xFF004AAD),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// --------------------------------------------------------------------

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, String? Function(String?)? validator) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        prefixIcon: Icon(icon, color: const Color(0xFF004AAD)),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label,
      bool isVisible, VoidCallback toggleVisibility) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF004AAD)),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey),
          onPressed: toggleVisibility,
        ),
      ),
      validator:
          label == 'Password' ? _validatePassword : _validateConfirmPassword,
    );
  }

  String? _validateFullName(String? value) =>
      value == null || value.isEmpty ? 'Please enter your full name' : null;
  String? _validateEmail(String? value) => value == null ||
          value.isEmpty ||
          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)
      ? 'Please enter a valid email'
      : null;
  String? _validatePassword(String? value) => value == null || value.length < 6
      ? 'Password must be at least 6 characters'
      : null;
  String? _validateConfirmPassword(String? value) =>
      value != _passwordController.text ? 'Passwords do not match' : null;
}
