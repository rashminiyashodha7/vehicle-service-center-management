// ignore_for_file: use_super_parameters

import 'package:app/home.dart';
import 'package:flutter/material.dart';

class RRPage extends StatelessWidget {
  const RRPage({Key? key}) : super(key: key);

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
          'Road Assistance',
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
              Center(
                child: Column(
                  children: [
                    // Add an image at the top (replace with your own image asset if needed)
                    Image.asset(
                      'assets/main image.png', // Replace with your main image path
                      height: 150,
                    ),
                    const SizedBox(height: 20),
                    // Hotline section
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: const Text(
                        'HOTLINE 077 462 7789',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // List of services with images
                    _buildServiceItem(
                        imagePath:
                            'assets/breakdown.png', // Replace with your image path
                        text: 'Vehicle Breakdown Service'),
                    _buildServiceItem(
                        imagePath:
                            'assets/tire punchers.png', // Replace with your image path
                        text: 'Tire Punchers'),
                    _buildServiceItem(
                        imagePath:
                            'assets/towing servie.png', // Replace with your image path
                        text: 'Towing Service'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceItem({required String imagePath, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          // Display the image for the service
          Image.asset(
            imagePath,
            width: 40, // Adjust size as needed
            height: 40,
          ),
          const SizedBox(width: 20),
          Text(
            text,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
