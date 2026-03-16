// ignore_for_file: use_super_parameters, avoid_print, use_build_context_synchronously

import 'package:app/about_us.dart';
import 'package:app/feedback.dart';
import 'package:app/history_details_page.dart';
import 'package:app/offers.dart';
import 'package:app/rr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'account.dart';
import 'booking.dart';
import 'home.dart';
import 'login.dart';
import 'service.dart';
import 'contactus.dart';
import 'bb.dart'; // Import the bb.dart page

class MenuView extends StatelessWidget {
  const MenuView({Key? key}) : super(key: key);

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

  Future<String> _getUserName(String uid) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      String email = user?.email ?? '';

      String? firstName = await _getUserFirstName(email);
      return firstName ?? 'Guest';
    } catch (e) {
      print('Error in _getUserName: $e');
      return 'Guest';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              child: Text('Guest'),
            ),
          ],
        ),
      );
    }

    return FutureBuilder<String>(
      future: _getUserName(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Drawer(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: const <Widget>[
                DrawerHeader(
                  child: Text('Error loading user data'),
                ),
              ],
            ),
          );
        }

        String firstName = snapshot.data ?? 'Guest';
        String email = user.email ?? 'guest@example.com';

        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(
                      255, 137, 15, 6), // Set the top color to purple
                ),
                accountName: Text(firstName),
                accountEmail: Text(email),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 255, 153, 0),
                  child: Text(
                    firstName.isNotEmpty ? firstName[0] : 'G',
                    style: const TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.work),
                title: const Text('Services'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const HistoryDetailsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.book_online_outlined),
                title: const Text('Booking'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => BookingPage(
                              onBookingConfirmed: () {},
                            )),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Service History'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const ServicePage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.discount),
                title: const Text('Offers'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const OffersPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.medical_services),
                title: const Text('Road Assistance'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RRPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text('Feedback'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const FeedbackPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.label),
                title: const Text('Review and Rating'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const BBPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.call),
                title: const Text('Contact Us'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ContactUs()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const AboutUsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_box),
                title: const Text('Account'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AccountPage(
                        documentId: user.uid,
                        email: email,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Log Out'),
                onTap: () async {
                  bool? shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Log Out'),
                        content:
                            const Text('Are you sure you want to log out?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldLogout == true) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
