// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:app/home.dart'; // Adjust the path as necessary
// for social media icons

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              MaterialPageRoute(builder: (context) => const Home()),
            ); // Action for back button
          },
        ),
        title: const Text(
          'Contact Us',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Contact US",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Contact Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    // Hotline
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.red),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Hotline : 077 - 4627789',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Email
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.red),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Email : anandautomotortechniques@gmail.com',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Address
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Address : Ihalamalkadudawa,\n Kurunegala,\n Sri Lanka.',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Opening Hours Section
              const Text(
                "Opening Hours",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Monday - Saturday : 8 AM - 5 PM',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Service Center Status
              Center(
                child: Text(
                  _getServiceCenterStatus(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isServiceCenterOpen() ? Colors.green : Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Social Media Icons
              /*Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.facebook,
                        color: Colors.red),
                    onPressed: () {
                      // Open Facebook
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon:
                        const FaIcon(FontAwesomeIcons.phone, color: Colors.red),
                    onPressed: () {
                      // Call button action
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.whatsapp,
                        color: Colors.red),
                    onPressed: () {
                      // WhatsApp action
                    },
                  ),
                  const SizedBox(width: 10),
                  // Google Map Icon (added)
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.locationDot,
                        color: Colors.red),
                    onPressed: () {
                      // Open Google Maps or relevant action
                    },
                  ),
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  // Function to check if the service center is open or closed
  bool _isServiceCenterOpen() {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    // Shop opens at 8 AM and closes at 5 PM
    return (currentHour >= 8 && currentHour < 17);
  }

  // Function to return the service center's status text
  String _getServiceCenterStatus() {
    return _isServiceCenterOpen() ? ' OPEN' : ' CLOSED';
  }
}
