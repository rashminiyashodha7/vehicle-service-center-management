// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, curly_braces_in_flow_control_structures, unused_local_variable

import 'package:app/adddetails.dart';
import 'package:app/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart'; // Import the home page

class SignScreen extends StatefulWidget {
  final String email;

  const SignScreen({super.key, required this.email});

  @override
  _SignScreenState createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Password strength criteria
  bool _isLengthValid = false;
  bool _hasLowercase = false;
  bool _hasUppercase = false;
  bool _hasDigit = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_validatePassword);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Function to validate password as the user types
  void _validatePassword() {
    String password = _passwordController.text;

    setState(() {
      _isLengthValid = password.length >= 8;
      _hasLowercase = RegExp(r'[a-z]').hasMatch(password);
      _hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
      _hasDigit = RegExp(r'\d').hasMatch(password);
      _hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 176, 5, 5),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddDetails()),
            );
          },
        ),
        title: const Text(
          'Registration',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 90),
                _passwordField("Password", _passwordController,
                    obscureText: _obscurePassword, onToggleVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                }),
                const SizedBox(height: 10),
                _passwordStrengthChecklist(),
                const SizedBox(height: 80),
                _passwordField("Confirm Password", _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    onToggleVisibility: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                }),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _cancelButton(),
                    _nextButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField(String hintText, TextEditingController controller,
      {required bool obscureText, required VoidCallback onToggleVisibility}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(137, 46, 49, 146)),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: const Color.fromARGB(137, 46, 49, 146),
          ),
          onPressed: onToggleVisibility,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        } else if (!_isLengthValid) {
          return 'Password must be at least 8 characters';
        } else if (!_hasLowercase) {
          return 'Password must contain at least one lowercase letter';
        } else if (!_hasUppercase) {
          return 'Password must contain at least one uppercase letter';
        } else if (!_hasDigit) {
          return 'Password must contain at least one digit';
        } else if (!_hasSpecialChar) {
          return 'Password must contain at least one special character';
        }
        return null;
      },
    );
  }

  Widget _passwordStrengthChecklist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password must contain:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 5),
        _validationItem('At least 8 characters', _isLengthValid, Colors.green),
        _validationItem(
            'At least one lowercase letter', _hasLowercase, Colors.green),
        _validationItem(
            'At least one uppercase letter', _hasUppercase, Colors.green),
        _validationItem('At least one digit', _hasDigit, Colors.green),
        _validationItem(
            'At least one special character', _hasSpecialChar, Colors.green),
      ],
    );
  }

  Widget _validationItem(String text, bool isValid, Color color) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? color : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: isValid ? color : Colors.red,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _cancelButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 108, 117, 125),
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        'Cancel',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _nextButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _registerUser,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(137, 0, 0, 119),
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        'Next',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Future<void> _registerUser() async {
    // Check if the passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Validate the form fields
    if (!_isLengthValid ||
        !_hasLowercase ||
        !_hasUppercase ||
        !_hasDigit ||
        !_hasSpecialChar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please ensure your password is strong')),
      );
      return;
    }

    try {
      // Create a user in Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: widget.email, // Use the email passed from AddDetails
        password: _passwordController.text,
      );

      // Registration successful, navigate to the home page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );

      // Navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const Home()), // Navigate to Home page
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Registration failed';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'The email address is already in use.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is invalid.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Handle other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }
}
