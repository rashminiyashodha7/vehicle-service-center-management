// ignore_for_file: use_super_parameters

import 'package:app/home.dart';
import 'package:flutter/material.dart';
import 'basic_care_package_page.dart';
import 'advanced_care_package_page.dart';
import 'premium_care_package_page.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({Key? key}) : super(key: key);

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
          'Offers',
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildOfferCard(
                title: "BASIC CARE PACKAGE",
                description: "Essential maintenance and safety checks.",
                imageUrl: "assets/7.png", // replace with your image path
                context: context,
                navigateTo:
                    const BasicCarePackagePage(), // Navigate to the page
              ),
              buildOfferCard(
                title: "ADVANCED CARE PACKAGE",
                description: "Comprehensive vehicle maintenance.",
                imageUrl: "assets/8.png", // replace with your image path
                context: context,
                navigateTo:
                    const AdvancedCarePackagePage(), // Navigate to the page
              ),
              buildOfferCard(
                title: "PREMIUM CARE PACKAGE",
                description: "Extensive service for luxury vehicles.",
                imageUrl: "assets/9.png", // replace with your image path
                context: context,
                navigateTo:
                    const PremiumCarePackagePage(), // Navigate to the page
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOfferCard({
    required String title,
    required String description,
    required String imageUrl,
    required BuildContext context,
    required Widget navigateTo,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to the respective package page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => navigateTo),
                      );
                    },
                    child: const Text(
                      'Read More >>>',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
