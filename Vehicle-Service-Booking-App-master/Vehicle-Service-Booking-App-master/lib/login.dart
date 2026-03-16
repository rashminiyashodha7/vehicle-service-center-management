// ignore_for_file: use_super_parameters, use_build_context_synchronously, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'adddetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}

// Login Screen
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  // Load saved user email from SharedPreferences
  void _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('remember_me') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('user_email') ?? '';
      }
    });
  }

  // Save user email to SharedPreferences
  void _saveUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('user_email', _emailController.text);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('user_email');
      await prefs.setBool('remember_me', false);
    }
  }

  // Show error message in a SnackBar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Validate email format
  bool _isEmailValid(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  // Perform user login
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError("Please enter your username and password");
      return;
    }

    if (!_isEmailValid(email)) {
      _showError("Please enter a valid email address");
      return;
    }

    print("Attempting login with email: $email"); // Debugging line

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _saveUserEmail(); // Save user email if login is successful
      if (!mounted) return;
      // Navigate to Home page after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      print("Login error: ${e.message}"); // Debugging line
      _showError(e.message ?? "Error occurred during login");
    }
  }

  // Send password reset email
  Future<void> _sendPasswordResetEmail() async {
    if (_emailController.text.isEmpty) {
      _showError('Please enter your email address');
      return;
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      _showError('Password reset email sent!');
    } on FirebaseAuthException catch (e) {
      _showError('Error: ${e.message}');
    }
  }

  // Create login button
  Widget _loginButton(Size screenSize) {
    return SizedBox(
      width: screenSize.width * 0.4,
      height: screenSize.height * 0.06,
      child: ElevatedButton(
        onPressed: _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 248, 0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  // Create account text widget
  Widget _createAccountText() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddDetails()),
        );
      },
      child: const Text(
        "Don't have an account? Create account!",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 17, 140, 240),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true, // Adjusts for the keyboard
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color.fromARGB(245, 235, 213, 74),
                  Color.fromARGB(245, 133, 120, 42),
                ],
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Allows scrolling
          child: SizedBox(
            height: screenSize.height, // Ensure the full height is used
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(245, 235, 213, 74),
                    Color.fromARGB(245, 133, 120, 42),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(top: screenSize.height * 0.05),
                          child: Image.asset(
                            'assets/IMG_2458.png',
                            height: screenSize.height * 0.08,
                            width: screenSize.width * 0.15,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenSize.height * 0.03),
                          child: Text(
                            'Ananda Auto Motor\nTechnique',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenSize.width * 0.05,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/Login.png',
                          height: screenSize.height * 0.2,
                          width: screenSize.width * 0.6,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    height: screenSize.height * 0.48,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(height: screenSize.height * 0.05),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10.0),
                                hintText: 'Username (email)',
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color.fromARGB(
                                        255, 180, 179, 179),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 15.0,
                                ),
                                hintText: 'Password',
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                  ),
                                  const Text("Remember Me"),
                                ],
                              ),
                              TextButton(
                                onPressed: _sendPasswordResetEmail,
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 17, 140, 240),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenSize.height * 0.01),
                          _loginButton(screenSize),
                          SizedBox(height: screenSize.height * 0.02),
                          _createAccountText(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
