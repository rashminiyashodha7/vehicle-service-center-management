// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'sign_screen.dart';
import 'login.dart';

class AddDetails extends StatefulWidget {
  const AddDetails({super.key});

  @override
  _AddDetailsState createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  String? _selectedVehicleType;
  final List<String> _vehicleTypes = ['Car', 'Van', 'Bus', 'Lorry'];
  // Validates NIC format
  String? _validateNIC(String? value) {
    if (value == null || value.isEmpty) return 'Please enter NIC';
    final regex = RegExp(r'^\d{9}[Vv]$|^\d{12}$');
    return regex.hasMatch(value) ? null : 'Invalid NIC format';
  }

  // Validates email format
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter an email';
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(value) ? null : 'Invalid email format';
  }

//contact vailed
  String? _validateContactNumber(String? value) {
    if (value == null || value.isEmpty)
      return 'Please enter your contact number';
    if (value.length != 10 || !RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Contact number is invalid';
    }
    return null;
  }

  String? _validateVehicleNumber(String? value) {
    if (value == null || value.isEmpty) return 'Please enter vehicle number';

    // Regular expression to match 2-3 uppercase letters, a hyphen, and exactly 4 digits
    final regex = RegExp(r'^[A-Z]{2,3}-\d{4}$');

    if (!regex.hasMatch(value)) {
      return 'Invalid vehicle number format. Must be 2-3 uppercase letters followed by a hyphen and 4 digits (e.g., AB-1234 or ABC-5678)';
    }

    return null;
  }

  // Validates required fields
  String? _validateRequiredField(String? value) {
    if (value == null || value.isEmpty) return 'This field is required';
    return null;
  }

  Future<void> _saveDetails(List<Map<String, String>> vehicles) async {
    if (_formKey.currentState!.validate()) {
      try {
        // Check if NIC already exists in Firestore
        final existingUser = await _firestore
            .collection('userDetails')
            .doc(_nicController.text)
            .get();

        if (existingUser.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('This NIC number is already registered.')),
          );
          return;
        }

        // Check for existing vehicle numbers
        for (var vehicle in vehicles) {
          final existingVehicle = await _firestore
              .collection('userDetails')
              .where('vehicles', arrayContains: {
            'vehicleNumber': vehicle['vehicleNumber']
          }).get();

          if (existingVehicle.docs.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Vehicle number ${vehicle['vehicleNumber']} is already registered.'),
              ),
            );
            return; // Exit early if a duplicate is found
          }
        }

        final DateTime sriLankaTime =
            DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
        final String formattedTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(sriLankaTime);

        // Save the user details to Firestore
        await _firestore
            .collection('userDetails')
            .doc(_nicController.text)
            .set({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'address': _addressController.text,
          'nic': _nicController.text,
          'contact': _contactController.text,
          'sriLankaTime': sriLankaTime,
          'formattedTime': formattedTime,
          'timestamp': FieldValue.serverTimestamp(),
          'vehicles': vehicles,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => SignScreen(email: _emailController.text)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save details: $e')),
        );
      }
    }
  }

  // Show dialog to ask for vehicle count
  void _askForVehicleCount() {
    TextEditingController vehicleCountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Vehicle Registration'),
          content: _inputField(
            'How many vehicles do you want to register?',
            vehicleCountController,
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Login())),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                int vehicleCount =
                    int.tryParse(vehicleCountController.text) ?? 0;
                if (vehicleCount > 0) {
                  _showVehicleForms(vehicleCount);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Please enter a valid number of vehicles.')));
                }
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  // Show vehicle details form based on count
  void _showVehicleForms(int vehicleCount) {
    List<Map<String, TextEditingController>> vehicleControllers =
        List.generate(vehicleCount, (_) {
      return {
        'number': TextEditingController(),
        'model': TextEditingController(),
        'type': TextEditingController(),
        'brand': TextEditingController(),
      };
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Vehicle Details'),
          content: SingleChildScrollView(
            child: Column(
              children: List.generate(vehicleCount, (index) {
                return _vehicleDetailsForm(
                    index + 1, vehicleControllers[index]);
              }),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Collect vehicle details
                List<Map<String, String>> vehicles =
                    vehicleControllers.map((controllers) {
                  return {
                    'vehicleNumber': controllers['number']!.text,
                    'model': controllers['model']!.text,
                    'type': controllers['type']!.text,
                    'brand': controllers['brand']!.text,
                  };
                }).toList();

                // Check if any vehicle number already exists
                for (var vehicle in vehicles) {
                  final existingVehicle = await FirebaseFirestore.instance
                      .collection('userDetails')
                      .where('vehicles.vehicleNumber',
                          isEqualTo: vehicle['vehicleNumber'])
                      .get();

                  if (existingVehicle.docs.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Vehicle number ${vehicle['vehicleNumber']} is already registered.'),
                      ),
                    );
                    return; // Stop the registration process
                  }
                }

                // If all vehicle numbers are unique, proceed to save
                _saveDetails(vehicles);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _vehicleDetailsForm(
      int vehicleIndex, Map<String, TextEditingController> controllers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Vehicle $vehicleIndex'),
        _inputField(
          'Vehicle Number',
          controllers['number']!,
          inputFormatters: [
            // Custom formatter to enforce format dynamically
            FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9-]')),
            LengthLimitingTextInputFormatter(
                8), // Max length: 3 letters + 1 hyphen + 4 digits = 8 characters
          ],
          validator: _validateVehicleNumber, // Using the updated validator
        ),
        _inputField('Vehicle Model', controllers['model']!),
        _vehicleTypeDropdown(controllers['type']!),
        _inputField('Vehicle Brand', controllers['brand']!),
        const SizedBox(height: 20),
      ],
    );
  }

  // Dropdown for vehicle type
  Widget _vehicleTypeDropdown(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: _selectedVehicleType,
        decoration: const InputDecoration(
          labelText: 'Select Vehicle Type',
          border: OutlineInputBorder(),
        ),
        items: _vehicleTypes
            .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedVehicleType = value;
            controller.text = value ?? '';
          });
        },
        validator: (value) =>
            value == null ? 'Please select vehicle type' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 176, 5, 5),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Login())),
          ),
          title: const Text(
            'Registration',
            style: TextStyle(
                color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: 25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _inputField("First Name", _firstNameController,
                    validator: _validateRequiredField),
                _inputField("Last Name", _lastNameController,
                    validator: _validateRequiredField),
                _inputField("Email", _emailController,
                    validator: _validateEmail),
                _inputField("Address", _addressController,
                    validator: _validateRequiredField),
                _inputField("NIC", _nicController, validator: _validateNIC),
                _inputField(
                  "Contact Number",
                  _contactController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: _validateContactNumber,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _cancelButton(screenWidth),
                    _nextButton(screenWidth),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      List<TextInputFormatter>? inputFormatters,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: InputDecoration(
          labelText: hintText,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget _cancelButton(double screenWidth) {
    return ElevatedButton(
      onPressed: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login())),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.15, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text('Cancel',
          style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }

  Widget _nextButton(double screenWidth) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _askForVehicleCount();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Please fill in all required fields.')));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 176, 5, 5),
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.15, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text('Next',
          style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }
}
