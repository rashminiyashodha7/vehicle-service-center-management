import 'dart:async';
import 'package:flutter/material.dart';
import 'booking.dart';
import 'navbar.dart';
import 'service.dart';
import 'history_details_page.dart';
import 'offers.dart';
import 'feedback.dart';
import 'about_us.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<String> images = [
    'assets/LL.jpg',
    'assets/KK.jpg',
    'assets/img3.jpeg.jpg',
  ];
  int currentIndex = 0;
  Timer? timer;

  late AnimationController _animationController;
  late Animation<double> _animation;

  // List of notifications
  final List<String> notifications = [
    "Wellcome To The Ananda Auto motor Techniques",
    "New offer available: Check Our Offers!",
    "Keep Your Ride running smooth-Book your Service now!",
    "We Value Your Feedback – Tell Us About Your Experience!",
    //"Reminder: Your appointment is tomorrow at 10 AM.",
    //"Give Feedback for our Services!",
  ];

  // Counter for unread notifications
  int unreadCount = 0;

  @override
  void initState() {
    super.initState();
    startImageTimer();

    // Initialize the animation controller for the "Book Now" button
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Repeat the animation back and forth

    // Define the scaling animation for the "Book Now" button
    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    /*// Simulate receiving notifications after some time
    Future.delayed(const Duration(seconds: 10), () {
      _addNotification("Keep Your Ride running smooth-Book your Service now!");
      _addNotification(
          "We Value Your Feedback – Tell Us About Your Experience!");
    });*/
  }

  void startImageTimer() {
    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      setState(() {
        currentIndex = (currentIndex + 1) % images.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose(); // Dispose of animation controller
    super.dispose();
  }

  // Method to show the notifications dialog
  void _showNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notifications"),
          content: SingleChildScrollView(
            child: ListBody(
              children: notifications.map((notification) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(notification),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    // Mark all notifications as read
    setState(() {
      unreadCount = 0; // Reset unread count
    });
  }

  // Method to add a new notification
  void _addNotification(String notification) {
    setState(() {
      notifications.add(notification);
      unreadCount++; // Increment unread count
    });
  }

  // Callback function to add booking confirmation notification
  void _onBookingConfirmed() {
    _addNotification("Your booking has been confirmed!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuView(),
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 87, 81, 81),
                Color.fromARGB(255, 189, 176, 176),
              ],
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const SizedBox(width: 0),
            Image.asset(
              'assets/IMG_2458.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 10),
            const Text(
              '     Ananda Auto\n   Motor Techniques',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 252, 252, 252),
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.notifications,
                      size: 30), // Increased icon size
                  if (unreadCount > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(
                            4), // Increased padding for height
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 24, // Adjusted minimum width
                          minHeight: 24, // Adjusted minimum height
                        ),
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              color: Colors.white,
              onPressed: _showNotifications,
            ),
          ],
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 69, 51, 39),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    images[currentIndex],
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ScaleTransition(
                scale: _animation,
                child: _buildBookNowButton(context),
              ),
              const SizedBox(height: 23),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  children: [
                    _buildStyledGridItem(context, 'Services', 'assets/se.png'),
                    _buildStyledGridItem(context, 'Offers', 'assets/of.png'),
                    _buildStyledGridItem(
                        context, 'Service History', 'assets/sh.png'),
                    _buildStyledGridItem(context, 'Feedback', 'assets/fb.png'),
                    _buildStyledGridItem(context, 'About Us', 'assets/ab.png'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledGridItem(
      BuildContext context, String title, String? imagePath) {
    return GestureDetector(
      onTap: () {
        if (title == 'Services') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HistoryDetailsPage(),
            ),
          );
        } else if (title == 'Offers') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OffersPage(),
            ),
          );
        } else if (title == 'Service History') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ServicePage(),
            ),
          );
        } else if (title == 'Feedback') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FeedbackPage(),
            ),
          );
        } else if (title == 'About Us') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AboutUsPage(),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 207, 0, 0),
                      Color.fromARGB(255, 105, 0, 0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookNowButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BookingPage(onBookingConfirmed: _onBookingConfirmed),
          ),
        );
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 121, 23, 7),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Book Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
