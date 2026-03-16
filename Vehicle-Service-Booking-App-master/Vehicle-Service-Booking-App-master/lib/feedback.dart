// ignore_for_file: avoid_print, use_build_context_synchronously, use_super_parameters, library_private_types_in_public_api

import 'package:app/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/services.dart'; // Import for TextInputFormatter

class FeedbackPage extends StatefulWidget {
  final VoidCallback? onFeedbackSubmitted;

  const FeedbackPage({Key? key, this.onFeedbackSubmitted}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _contactNumber;
  String? _comment;
  int _rating = 0;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails(); // Fetch user details when the page is loaded
  }

  // Function to fetch user details from Firestore
  Future<void> _fetchUserDetails() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String email = user.email ?? '';
        String? firstName = await _getUserFirstName(email);

        setState(() {
          _name = firstName ??
              'Guest'; // Set default to 'Guest' if no name is found
          _email = email;
          _nameController.text = _name ?? ''; // Autofill name field
          _emailController.text = _email ?? ''; // Autofill email field
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  // Fetch user's first name from Firestore based on their email
  Future<String?> _getUserFirstName(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('userDetails')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data()['firstName'];
      } else {
        return 'Guest';
      }
    } catch (e) {
      print('Error getting user data: $e');
      return 'Guest';
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      Map<String, dynamic> feedbackData = {
        'name': _name,
        'email': _email,
        'contactNumber': _contactNumber,
        'comment': _comment,
        'rating': _rating,
        'timestamp': DateTime.now(),
      };

      try {
        await _db.collection('feedback').add(feedbackData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback submitted successfully!')),
        );

        if (widget.onFeedbackSubmitted != null) {
          widget.onFeedbackSubmitted!();
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit feedback: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 176, 5, 5),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
        title: const Text(
          'Feedback',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        'Name*',
                        Icons.person,
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        onSave: (value) {
                          _name = value;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildEmailField(),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Contact Number*',
                        Icons.phone,
                        initialValue: _contactNumber,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your contact number';
                          } else if (value.length != 10) {
                            return 'Contact number must be exactly 10 digits';
                          }
                          return null;
                        },
                        onSave: (value) {
                          _contactNumber = value;
                        },
                        isContactNumber: true,
                      ),
                      const SizedBox(height: 16),
                      _buildCommentField('Comment*', (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your comment';
                        }
                        return null;
                      }, (value) {
                        _comment = value;
                      }),
                      const SizedBox(height: 16),
                      _buildStarRatingSection(),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _submitForm,
              child: const Text(
                'SUBMIT',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon, {
    String? initialValue,
    TextEditingController? controller,
    required String? Function(String?) validator,
    required void Function(String?) onSave,
    bool isContactNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      onSaved: onSave,
      keyboardType: isContactNumber ? TextInputType.phone : TextInputType.text,
      inputFormatters: isContactNumber
          ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
          : null,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
      readOnly: true, // Makes the field read-only
    );
  }

  Widget _buildCommentField(String label, String? Function(String?) validator,
      void Function(String?) onSave) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLines: 4,
      validator: validator,
      onSaved: onSave,
    );
  }

  Widget _buildStarRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Rate Us Here',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < _rating ? Icons.star : Icons.star_border,
                size: 45,
                color: Colors.amber,
              ),
              onPressed: () {
                setState(() {
                  _rating = index + 1;
                });
              },
            );
          }),
        ),
      ],
    );
  }
}
