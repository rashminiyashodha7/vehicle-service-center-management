// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:app/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ServiceDetailsPage.dart'; // Import the details page

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  User? user; // Firebase user
  String? selectedVehicle; // Dropdown selected vehicle
  List<String> vehicleNumbers = []; // List of vehicle numbers
  bool isLoading = true; // To track loading state while fetching data

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    fetchUserDataAndVehicles();
  }

  /// Fetch user details and associated vehicle numbers
  Future<void> fetchUserDataAndVehicles() async {
    if (user == null) return;

    try {
      // Fetch user details by email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('userDetails')
          .where('email', isEqualTo: user!.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDetails = querySnapshot.docs.first;
        List<dynamic> vehicles = userDetails['vehicles'];

        List<String> vehicleList = [];

        for (var vehicle in vehicles) {
          // Assuming each vehicle has a 'vehicleNumber' field
          vehicleList.add(vehicle['vehicleNumber']);
        }

        setState(() {
          vehicleNumbers = vehicleList; // Update the list of vehicle numbers
          if (vehicleNumbers.isNotEmpty) {
            selectedVehicle = vehicleNumbers[0]; // Set default selection
          }
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching user or vehicle data: $e');
      setState(() {
        isLoading = false;
      });
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
          'Service History',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Dropdown for selecting vehicle
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButton<String>(
                      value: selectedVehicle,
                      hint: const Text('Select Vehicle'),
                      icon: const Icon(Icons.arrow_drop_down),
                      isExpanded: true,
                      items: vehicleNumbers.map((String vehicle) {
                        return DropdownMenuItem<String>(
                          value: vehicle,
                          child: Text(vehicle),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedVehicle =
                              newValue; // Update the selected vehicle
                        });
                      },
                    ),
            ),
            Expanded(
              child: user == null
                  ? const Center(
                      child: Text('No user is logged in.'),
                    )
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('service_history')
                          .where('email', isEqualTo: user!.email)
                          .where('vehicle_number', isEqualTo: selectedVehicle)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text('No service history found.'));
                        }

                        return ListView(
                          padding: const EdgeInsets.all(8.0),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;

                            String reservationNo =
                                data['reservation_number'] ?? 'Unknown';
                            String date = data['date'] ?? 'Unknown date';
                            String timeSlot =
                                data['time_slot'] ?? 'Unknown time';

                            return _buildReservationTile(
                                context, reservationNo, date, timeSlot, data);
                          }).toList(),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationTile(
    BuildContext context,
    String reservationNo,
    String date,
    String timeSlot,
    Map<String, dynamic> data,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 42, 39, 39),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Text(
                'RESERVATION NO : $reservationNo',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date :',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      date,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Time :',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      timeSlot,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ServiceDetailsPage(serviceData: data),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 253, 254, 255),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
