import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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

  File? _img;

  Future<void> checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  Future _browseImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          _img = File(image.path);
          context.read<SignupBloc>().add(
                UploadImage(file: _img!),
              );
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

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
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? screenWidth * 0.2 : 20, // Adjust for tablets
          ),
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
                                _browseImage(ImageSource.camera);
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.camera),
                              label: const Text('Camera'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _browseImage(ImageSource.gallery);
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
                    radius: isTablet ? 70 : 50,
                    backgroundImage: _img != null
                        ? FileImage(_img!)
                        : const AssetImage('assets/images/profile.jpg')
                            as ImageProvider,
                  ),
                ),
                SizedBox(height: isTablet ? 30 : 20),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: isTablet ? 28 : 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF004AAD),
                  ),
                ),
                SizedBox(height: isTablet ? 30 : 20),
                _buildTextField(_fullNameController, 'Full Name', Icons.person,
                    _validateFullName, isTablet),
                SizedBox(height: isTablet ? 20 : 15),
                _buildTextField(_emailController, 'Email', Icons.email,
                    _validateEmail, isTablet),
                SizedBox(height: isTablet ? 20 : 15),
                _buildPasswordField(
                    _passwordController, 'Password', _isPasswordVisible, () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                }, isTablet),
                SizedBox(height: isTablet ? 20 : 15),
                _buildPasswordField(_confirmPasswordController,
                    'Confirm Password', _isConfirmPasswordVisible, () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                }, isTablet),
                SizedBox(height: isTablet ? 30 : 20),
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
                      padding:
                          EdgeInsets.symmetric(vertical: isTablet ? 20 : 15),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 30 : 20),
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    String? Function(String?)? validator,
    bool isTablet,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        prefixIcon: Icon(icon, color: const Color(0xFF004AAD)),
      ),
      style: TextStyle(fontSize: isTablet ? 18 : 16),
      validator: validator,
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String label,
    bool isVisible,
    VoidCallback toggleVisibility,
    bool isTablet,
  ) {
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
      style: TextStyle(fontSize: isTablet ? 18 : 16),
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
