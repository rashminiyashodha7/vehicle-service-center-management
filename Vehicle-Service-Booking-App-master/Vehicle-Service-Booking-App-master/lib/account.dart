import 'package:app/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class UserDetails {
  String firstName;
  String contact;
  String address;
  String email;
  String? profileImageUrl;

  UserDetails({
    required this.firstName,
    required this.contact,
    required this.address,
    required this.email,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'contact': contact,
      'address': address,
      'email': email,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory UserDetails.fromFirestore(Map<String, dynamic> data) {
    return UserDetails(
      firstName: data['firstName'] ?? '',
      contact: data['contact'] ?? '',
      address: data['address'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'],
    );
  }
}

class AccountPage extends StatefulWidget {
  final String email;
  final String documentId;

  const AccountPage({
    required this.email,
    required this.documentId,
    super.key,
  });

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late UserDetails _userDetails;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userDetails = UserDetails(
        firstName: '', contact: '', address: '', email: widget.email);
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('accounts') // Change the collection name here
          .doc(widget.documentId)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        setState(() {
          _userDetails = UserDetails.fromFirestore(data);
          _nameController.text = _userDetails.firstName;
          _phoneController.text = _userDetails.contact;
          _addressController.text = _userDetails.address;
        });
      }
    } catch (e) {
      _showError('Failed to fetch user data. Please try again later.');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      _saveProfileImage();
    }
  }

  Future<void> _saveProfileImage() async {
    if (_profileImage == null) return;

    try {
      String fileName = const Uuid().v4();
      Reference storageRef = _storage.ref().child('profile_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(_profileImage!);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _userDetails.profileImageUrl = downloadUrl;
      });
      await _saveUserData();
      _showSuccess('Profile image uploaded successfully!');
    } catch (e) {
      _showError('Error uploading profile image.');
    }
  }

  Future<void> _saveUserData() async {
    try {
      await FirebaseFirestore.instance
          .collection('accounts') // Use the new 'accounts' collection
          .doc(widget.documentId)
          .set(_userDetails.toMap());
      _showSuccess('Details updated successfully!');
    } catch (e) {
      _showError('Failed to save user data.');
    }
  }

  void _editDetails(String field) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: field == 'Name'
                ? _nameController
                : field == 'Phone'
                    ? _phoneController
                    : _addressController,
            decoration: InputDecoration(hintText: 'Enter new $field'),
            keyboardType:
                field == 'Phone' ? TextInputType.phone : TextInputType.text,
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (field == 'Name') {
                    _userDetails.firstName = _nameController.text;
                  } else if (field == 'Phone') {
                    if (_validatePhone(_phoneController.text)) {
                      _userDetails.contact = _phoneController.text;
                    } else {
                      _showError('Invalid phone number.');
                      return;
                    }
                  } else if (field == 'Address') {
                    _userDetails.address = _addressController.text;
                  }
                });
                _saveUserData();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  bool _validatePhone(String phone) {
    return phone.isNotEmpty && phone.length == 10;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
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
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const Home()));
          },
        ),
        title: const Text(
          'Account',
          style: TextStyle(
              color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text('Manage Account',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : (_userDetails.profileImageUrl != null &&
                            _userDetails.profileImageUrl!.isNotEmpty
                        ? NetworkImage(_userDetails.profileImageUrl!)
                        : null) as ImageProvider<Object>?,
                child: _profileImage == null &&
                        (_userDetails.profileImageUrl?.isEmpty ?? true)
                    ? const Icon(Icons.camera_alt, size: 40)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _editDetails('Name'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Name: ${_userDetails.firstName}',
                      style: const TextStyle(fontSize: 18)),
                  const Icon(Icons.edit),
                ],
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _editDetails('Phone'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Phone: ${_userDetails.contact}',
                      style: const TextStyle(fontSize: 18)),
                  const Icon(Icons.edit),
                ],
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _editDetails('Address'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Address: ${_userDetails.address}',
                      style: const TextStyle(fontSize: 18)),
                  const Icon(Icons.edit),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
