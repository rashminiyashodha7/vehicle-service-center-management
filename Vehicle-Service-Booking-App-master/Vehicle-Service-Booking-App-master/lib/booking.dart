// ignore_for_file: use_super_parameters, library_private_types_in_public_api, avoid_print, use_build_context_synchronously, prefer_interpolation_to_compose_strings, unnecessary_to_list_in_spreads, unused_import, unused_element, unused_field, use_key_in_widget_constructors, non_constant_identifier_names

import 'dart:convert';
import 'package:app/home.dart';
import 'package:app/navbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class BookingPage extends StatefulWidget {
  final VoidCallback onBookingConfirmed;

  const BookingPage({Key? key, required this.onBookingConfirmed})
      : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _contactNumberController = TextEditingController();
  final _OtherController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleBrandController = TextEditingController();

  String? _selectedVehicleType;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String? _vehicleNumber;
  List<String> _vehicleNumbers = [];
  bool _isLoadingVehicleNumbers = true;
  String? _userEmail;
  String? _userNic;

  final List<String> _timeSlots = [
    '08:00 AM - 10:00 AM',
    '10:00 AM - 12:00 PM',
    '12:00 PM - 02:00 PM',
    '02:00 PM - 04:00 PM',
    '04:00 PM - 05:00 PM',
  ];

  final Map<String, bool> _selectedServices = {
    'Body wash': false,
    'Body polishing': false,
    'Lube services': false,
    'Engine tune-ups': false,
    'Undercarriage degreasing': false,
    'Interior vacuum & cleaning': false,
    'Paint correction': false,
    'Collision correction': false,
    'Spare part replacement': false,
    'Battery services': false,
    'Tyre replacements': false,
  };

  bool _selectAllServices = false;

  @override
  void initState() {
    super.initState();
    _fetchVehicleNumbers();
  }

  Future<void> _fetchVehicleNumbers() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String userEmail = currentUser.email!;
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('userDetails')
            .where('email', isEqualTo: userEmail)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDetails = querySnapshot.docs.first;
          List<dynamic> vehicles = userDetails['vehicles'];

          setState(() {
            _vehicleNumbers = vehicles
                .map<String>((vehicle) => vehicle['vehicleNumber'])
                .toList();
            _userEmail = userEmail;
            _vehicleNumber =
                _vehicleNumbers.isNotEmpty ? _vehicleNumbers.first : null;
            _isLoadingVehicleNumbers = false;
          });

          if (_vehicleNumber != null) {
            await _fetchVehicleDetails(_vehicleNumber);
          }

          if (mounted) {
            setState(() {
              _userNic = userDetails['nic'];
            });
          }
        } else {
          _handleError('User details not found. Please try again.');
        }
      }
    } catch (e) {
      _handleError('Error fetching user details: $e');
    }
  }

  Future<void> _fetchVehicleDetails(String? selectedVehicleNumber) async {
    if (selectedVehicleNumber == null) return;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('userDetails')
          .where('email', isEqualTo: _userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDetails = querySnapshot.docs.first;
        List<dynamic> vehicles = userDetails['vehicles'];

        for (var vehicle in vehicles) {
          if (vehicle['vehicleNumber'] == selectedVehicleNumber) {
            setState(() {
              _vehicleModelController.text = vehicle['model'];
              _vehicleBrandController.text = vehicle['brand'];
              _selectedVehicleType = vehicle['type'];
            });
            break;
          }
        }
      }
    } catch (e) {
      _handleError('Error fetching vehicle details: $e');
    }
  }

  void _handleError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    setState(() {
      _isLoadingVehicleNumbers = false;
    });
  }

  String _getSelectedServices() {
    return _selectedServices.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .join(', ');
  }

  void _toggleSelectAllServices(bool? value) {
    setState(() {
      _selectAllServices = value ?? false;
      _selectedServices.updateAll((key, _) => _selectAllServices);
    });
  }

  Future<void> _saveBookingData() async {
    if (_selectedTimeSlot == null || _selectedDate == null) {
      _handleError('Please select a time slot and date.');
      return;
    }
    if (_vehicleNumber == null) {
      _handleError('Please select a vehicle number.');
      return;
    }
    if (_contactNumberController.text.isEmpty) {
      _handleError('Please enter a contact number.');
      return;
    }
    if (_selectedServices.values.every((service) => !service)) {
      _handleError('Please select at least one service.');
      return;
    }

    try {
      QuerySnapshot timeSlotSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('date',
              isEqualTo: _selectedDate!.toLocal().toString().split(' ')[0])
          .where('time_slot', isEqualTo: _selectedTimeSlot)
          .get();

      if (timeSlotSnapshot.docs.length >= 10) {
        _handleError(
            'The selected time slot is fully booked. Please choose another time slot.');
        return;
      }

      QuerySnapshot vehicleSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('date',
              isEqualTo: _selectedDate!.toLocal().toString().split(' ')[0])
          .where('vehicle_number', isEqualTo: _vehicleNumber)
          .get();

      if (vehicleSnapshot.docs.isNotEmpty) {
        _handleError('This vehicle is already booked on the selected date.');
        return;
      }
      String reservationString = await _fetchLastReservationNumber();
      DateTime nextServiceDate = _selectedDate!.add(const Duration(days: 1));

      final bookingData = {
        'reservation_number': reservationString,
        'contact_number': _contactNumberController.text,
        'vehicle_number': _vehicleNumber,
        'vehicle_type': _selectedVehicleType,
        'vehicle_model': _vehicleModelController.text,
        'vehicle_brand': _vehicleBrandController.text,
        'services': _getSelectedServices(),
        'Other': _OtherController.text,
        'time_slot': _selectedTimeSlot,
        'date': _selectedDate!.toLocal().toString().split(' ')[0],
        'email': _userEmail,
        'nic': _userNic,
        'reminder_date': _selectedDate!
            .subtract(const Duration(days: 1))
            .toLocal()
            .toString()
            .split(' ')[0],
        'Reminder_email_sent': false,
        'Confirmation_email_sent': false,
        'Completion_email_sent': false,
        'Nextservice_email_sent': false,
        'next_service_date': nextServiceDate.toLocal().toString().split(' ')[0],
        'timestamp': FieldValue.serverTimestamp(),
      };
      await FirebaseFirestore.instance.collection('bookings').add(bookingData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Booking Successful! Confirmation email sent.'),
            backgroundColor: Colors.green),
      );

      await _sendConfirmationEmail(bookingData);

      widget.onBookingConfirmed();

      await _scheduleEmailReminder(bookingData);
      await _scheduleNextServiceEmailReminder(bookingData);
    } catch (e) {
      _handleError('Error: $e');
    }
  }

  Future<String> _fetchLastReservationNumber() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .orderBy('reservation_number', descending: true)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        String lastReservationNumber =
            snapshot.docs.first['reservation_number'];
        int newReservationNumber =
            int.parse(lastReservationNumber.split('-')[1]) + 1;
        return 'RES-$newReservationNumber';
      }
      return 'RES-0001';
    } catch (e) {
      return 'RES-1000';
    }
  }

  Future<void> _sendConfirmationEmail(Map<String, dynamic> bookingData) async {
    try {
      String username = 'anandaautomoters@gmail.com';
      String password = 'dmgp ocsg qqdu yohi';
      final smtpServer = gmail(username, password);
      final message = Message()
        ..from = Address(username)
        ..recipients.add(bookingData['email'])
        ..subject = 'Booking Confirmation'
        ..text = '''
      Dear Customer,
      
      Your booking for vehicle ${bookingData['vehicle_number']} has been successfully confirmed.
      Services booked: ${bookingData['services']}
      Thank you for choosing our services.
      
      Best regards,
      Your Service Team
      ''';

      await send(message, smtpServer);
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingData['reservation_number'])
          .update({'Confirmation_email_sent': true});

      await _scheduleEmailReminder(bookingData);
    } catch (e) {
      print('Error sending confirmation email: $e');
    }
  }

  Future<void> _scheduleEmailReminder(Map<String, dynamic> bookingData) async {
    DateTime reminderDate = DateTime.parse(bookingData['reminder_date']);
    Duration reminderTime = reminderDate.isBefore(DateTime.now())
        ? const Duration(minutes: 2)
        : Duration.zero;
    await Future.delayed(reminderTime);
    await _sendReminderEmail(bookingData);
  }

  Future<void> _sendReminderEmail(Map<String, dynamic> bookingData) async {
    String username = 'anandaautomoters@gmail.com';
    String password = 'dmgp ocsg qqdu yohi';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(bookingData['email'])
      ..subject = 'Booking Reminder'
      ..text = '''
      Dear Customer,
      
      Just a friendly reminder about your upcoming booking for vehicle ${bookingData['vehicle_number']}.
      Services booked: ${bookingData['services']}
      Looking forward to seeing you soon.
      
      Best regards,
      Your Service Team
      ''';

    try {
      await send(message, smtpServer);
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingData['reservation_number'])
          .update({'Reminder_email_sent': true});
    } catch (e) {
      print('Error sending reminder email: $e');
    }
  }

  Future<void> _scheduleNextServiceEmailReminder(
      Map<String, dynamic> bookingData) async {
    // Ensure the reminder is only scheduled once Completion_email_sent is true
    if (bookingData['Completion_email_sent'] == true) {
      DateTime nextServiceDate =
          DateTime.parse(bookingData['next_service_date']);
      Duration nextServiceTime = nextServiceDate.isBefore(DateTime.now())
          ? const Duration(minutes: 2)
          : Duration.zero;

      await Future.delayed(nextServiceTime);
      await _sendNextServiceReminderEmail(bookingData);
    }
  }

  Future<void> _sendNextServiceReminderEmail(
      Map<String, dynamic> bookingData) async {
    String username = 'anandaautometers@gmail.com';
    String password = 'dmgp ocsg qqdu yohi';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(bookingData['email'])
      ..subject = 'Next Service Reminder'
      ..text = '''
    Dear Customer,
    
    Your next service is scheduled for vehicle ${bookingData['vehicle_number']} on ${bookingData['next_service_date']}.
    Services booked: ${bookingData['services']}
    We look forward to serving you again.
    
    Best regards,
    Your Service Team
    ''';

    try {
      await send(message, smtpServer);
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingData['reservation_number'])
          .update({'Nextservice_email_sent': true});
    } catch (e) {
      print('Error sending next service reminder email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 176, 5, 5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoadingVehicleNumbers
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _vehicleNumber,
                      onChanged: (value) {
                        setState(() {
                          _vehicleNumber = value;
                          _fetchVehicleDetails(value);
                        });
                      },
                      items: _vehicleNumbers.map((vehicle) {
                        return DropdownMenuItem(
                          value: vehicle,
                          child: Text(vehicle),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contactNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Only digits allowed
                        LengthLimitingTextInputFormatter(
                            10), // Limit input to 10 characters
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your contact number';
                        }
                        if (value.length != 10) {
                          return 'Contact number must be exactly 10 digits';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Please enter a valid 10-digit contact number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _vehicleModelController,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Model',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _vehicleBrandController,
                      decoration: const InputDecoration(
                        labelText: 'Vehicle Brand',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    const Text('Select Services',
                        style: TextStyle(fontSize: 18)),
                    CheckboxListTile(
                      title: const Text('Select All'),
                      value: _selectAllServices,
                      onChanged: _toggleSelectAllServices,
                    ),
                    ..._selectedServices.keys.map((service) {
                      return CheckboxListTile(
                        title: Text(service),
                        value: _selectedServices[service],
                        onChanged: (value) {
                          setState(() {
                            _selectedServices[service] = value!;
                          });
                        },
                      );
                    }).toList(),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _OtherController,
                      decoration: const InputDecoration(
                        labelText: 'Other',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Select Date',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          selectableDayPredicate: (DateTime day) {
                            return day.weekday != DateTime.sunday;
                          },
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      controller: TextEditingController(
                        text: _selectedDate != null
                            ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                            : '',
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedTimeSlot,
                      onChanged: (value) {
                        setState(() {
                          _selectedTimeSlot = value;
                        });
                      },
                      items: _timeSlots.map((timeSlot) {
                        return DropdownMenuItem(
                          value: timeSlot,
                          child: Text(timeSlot),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Time Slot',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 176, 5, 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveBookingData();
                        }
                      },
                      child: const Text(
                        'Book Now',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
