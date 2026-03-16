// ignore_for_file: file_names, unused_import, use_super_parameters

import 'dart:developer';
import 'package:app/service.dart';
import 'package:flutter/material.dart';

class ServiceDetailsPage extends StatelessWidget {
  final Map<String, dynamic> serviceData;

  const ServiceDetailsPage({Key? key, required this.serviceData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract details from the passed serviceData map
    String reservationNo = serviceData['reservation_number'] ?? '';
    String date = serviceData['date'] ?? '';
    String timeSlot = serviceData['time_slot'] ?? '';
    String vehicleBrand = serviceData['vehicle_brand'] ?? '';
    String vehicleModel = serviceData['vehicle_model'] ?? '';
    String vehicleNumber = serviceData['vehicle_number'] ?? '';
    String vehicleType = serviceData['vehicle_type'] ?? '';
    String servicesString = serviceData['services'] ?? '';

    // Split the services string into a list, assuming a simple comma-separated format
    List<String> services =
        servicesString.split(',').map((s) => s.trim()).toList();

    return Scaffold(
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
              MaterialPageRoute(builder: (context) => const ServicePage()),
            ); // Action for back button
          },
        ),
        title: const Text(
          'Service History Details',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey[200]!],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact Information
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/IMG_2458.png', // Make sure this path is correct
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Ananda Auto Motor Techniques',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('E-mail: anandaautomoters@gmail.com'),
                              SizedBox(height: 4),
                              Text('Telephone Number: 0774627789'),
                              SizedBox(height: 4),
                              Text(
                                  'Address: Ihala Malkaduwawa Road, Kurunegala, Sri Lanka'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reservation Number
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 1, 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Reservation No: $reservationNo',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date and Time Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date',
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
                            'Time',
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

                  // Vehicle Details
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Vehicle Details',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Vehicle No:',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  vehicleNumber,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Vehicle Type:',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  vehicleType,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Model:',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '$vehicleBrand $vehicleModel',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Service Details
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Services',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(),
                        ...services.map((service) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(service),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Add any additional details or buttons as needed
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
