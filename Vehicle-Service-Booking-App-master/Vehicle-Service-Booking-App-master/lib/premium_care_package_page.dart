// ignore_for_file: use_super_parameters

import 'package:app/offers.dart';
import 'package:flutter/material.dart';

class PremiumCarePackagePage extends StatelessWidget {
  const PremiumCarePackagePage({Key? key}) : super(key: key);

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
              MaterialPageRoute(builder: (context) => const OffersPage()),
            ); // Action for back button
          },
        ),
        title: const Text(
          'Premium Care Packages',
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
              // Package image
              Image.asset(
                'assets/9.png', // Replace with actual image asset path
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),

              // Includes section
              const Text(
                'INCLUDES :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),

              // List of included services
              const Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.check_circle_outline),
                        title: Text('Windscreen washer fluid'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check_circle_outline),
                        title: Text('Windscreen polish'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check_circle_outline),
                        title: Text('Belts'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check_circle_outline),
                        title: Text('Deep interior cleaning'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check_circle_outline),
                        title: Text('Headlight and Taillight cleaning'),
                      ),
                      ListTile(
                        leading: Icon(Icons.add_circle_outline),
                        title: Text(
                          '+ Advanced care package',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Total price section
              /*  const Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$\$\$\$\$',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
              const SizedBox(height: 10),

              // Discount amount section
              /* const Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Discount amount',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$\$\$\$\$',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
