// ignore_for_file: use_super_parameters, library_private_types_in_public_api, avoid_print

import 'package:app/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BBPage extends StatefulWidget {
  const BBPage({Key? key}) : super(key: key);

  @override
  _BBPageState createState() => _BBPageState();
}

class _BBPageState extends State<BBPage> {
  double averageRating = 0.0;
  int totalRatings = 0;
  Map<int, int> ratingDistribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
  List<Map<String, dynamic>> customerFeedback = [];

  @override
  void initState() {
    super.initState();
    _fetchRatingsAndFeedback();
  }

  Future<void> _fetchRatingsAndFeedback() async {
    try {
      final feedbackCollection =
          FirebaseFirestore.instance.collection('feedback');
      final snapshot = await feedbackCollection.get();

      if (snapshot.docs.isNotEmpty) {
        double totalScore = 0.0;
        int totalCount = 0;
        Map<int, int> distribution = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
        List<Map<String, dynamic>> feedbackList = [];

        for (var doc in snapshot.docs) {
          int rating = doc['rating'];
          String email = doc['email'];
          String comment = doc['comment'];

          // Add feedback details to the list
          feedbackList.add({
            'email': email,
            'comment': comment,
            'rating': rating,
          });

          if (distribution.containsKey(rating)) {
            distribution[rating] = distribution[rating]! + 1;
            totalScore += rating;
            totalCount += 1;
          }
        }

        setState(() {
          averageRating = totalScore / totalCount;
          totalRatings = totalCount;
          ratingDistribution = distribution;
          customerFeedback = feedbackList;
        });
      }
    } catch (e) {
      print('Error fetching ratings and feedback: $e');
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
          'Review And Rating',
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating Summary Section
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${averageRating.toStringAsFixed(1)}/5',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalRatings Ratings',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(5, ratingDistribution[5]!),
                      _buildRatingBar(4, ratingDistribution[4]!),
                      _buildRatingBar(3, ratingDistribution[3]!),
                      _buildRatingBar(2, ratingDistribution[2]!),
                      _buildRatingBar(1, ratingDistribution[1]!),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 40),
            // Customer Feedback Section
            const Text(
              'Customer Feedback',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildCustomerFeedbackList(),
          ],
        ),
      ),
    );
  }

  // Helper function to build a rating bar row
  Widget _buildRatingBar(int stars, int count) {
    return Row(
      children: [
        Row(
          children: List.generate(
            stars,
            (index) => const Icon(
              Icons.star,
              color: Colors.amber,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: LinearProgressIndicator(
            value: count / (totalRatings == 0 ? 1 : totalRatings),
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
        ),
        const SizedBox(width: 10),
        Text('$count'),
      ],
    );
  }

  // Function to build the customer feedback list
  Widget _buildCustomerFeedbackList() {
    if (customerFeedback.isEmpty) {
      return const Center(
        child: Text('No feedback available'),
      );
    }

    return Column(
      children: customerFeedback.map((feedback) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feedback['email'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    feedback['rating'],
                    (index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  feedback['comment'],
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
