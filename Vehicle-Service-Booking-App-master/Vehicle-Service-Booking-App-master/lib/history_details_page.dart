import 'package:flutter/material.dart';

class HistoryDetailsPage extends StatefulWidget {
  const HistoryDetailsPage({super.key});

  @override
  _HistoryDetailsPageState createState() => _HistoryDetailsPageState();
}

class _HistoryDetailsPageState extends State<HistoryDetailsPage> {
  String selectedCategory = 'Periodic Maintenance';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Handle back navigation
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            // Service Category Tabs (like Periodic Maintenance, etc.)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryTab('Periodic Maintenance',
                      selectedCategory == 'Periodic Maintenance'),
                  _buildCategoryTab('Interior Condition',
                      selectedCategory == 'Interior Condition'),
                  _buildCategoryTab('Exterior Condition',
                      selectedCategory == 'Exterior Condition'),
                  _buildCategoryTab('Mechanical Repair',
                      selectedCategory == 'Mechanical Repair'),
                  _buildCategoryTab(
                      'Tyre Services', selectedCategory == 'Tyre Services'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Display content based on the selected category
            _buildCategoryContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = label; // Update selected category
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.grey : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildCategoryContent() {
    // Content based on the selected category
    switch (selectedCategory) {
      case 'Periodic Maintenance':
        return _buildPeriodicMaintenanceContent();
      case 'Interior Condition':
        return _buildInteriorConditionContent();
      case 'Exterior Condition':
        return _buildExteriorConditionContent();
      case 'Mechanical Repair':
        return _buildMechanicalRepairContent();
      case 'Tyre Services':
        return _buildTyreServicesContent();
      default:
        return Container();
    }
  }

  Widget _buildPeriodicMaintenanceContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Washing',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildServiceTile('Body wash', 'assets/wash.png'),
            _buildServiceTile('Body polishing\nand waxing', 'assets/body.webp'),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Lube Services',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildServiceTile('Engine Oil', 'assets/hand.jpg'),
              _buildServiceTile('Oil Change', 'assets/images.jpg'),
              _buildServiceTile('New Oil Filter', 'assets/orange.jpg'),
              _buildServiceTile('Transmission Fluid', 'assets/blue.jpg'),
              _buildServiceTile('Coolant Flush', 'assets/images.jpg'),
              _buildServiceTile('Brake Fluid', 'assets/ppp.webp'),
              _buildServiceTile(
                  'Tire pressure and condition check', 'assets/tire.png'),
              _buildServiceTile(
                  'Check cooling system, brakes, lights', 'assets/kotu.webp'),
              _buildServiceTile(
                  'Check cv joints, brake hoses, exhaust', 'assets/ball.jpg'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Engine Tune-Ups',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildServiceTile(
                  'Intake manifold\nde-carbonizing', 'assets/wht.jpg'),
              _buildServiceTile(
                  'Spark plug check\nand inspection', 'assets/park.png'),
              _buildServiceTile(
                  'Ignition coil check and inspection', 'assets/hand.jpg'),
              _buildServiceTile(
                  'Exhaust catalytic\nsystem inspection', 'assets/eng.png'),
              _buildServiceTile('Injector ultrasonic pressure and flow test',
                  'assets/flow.jpg'),
              _buildServiceTile('Air flow sensor inspection', 'assets/th.jpg'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Undercarriage degreasing',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildServiceTile('Undercarriage wash', 'assets/washh.jpg'),
              _buildServiceTile('Spray application', 'assets/spray.webp'),
              _buildServiceTile('Specialized Undercoatings', 'assets/und.png'),
              _buildServiceTile('Specialized under wax', 'assets/sp.jpg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInteriorConditionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildServiceTile(
                'Interior vacuum\nand cleaning', 'assets/seat.png'),
          ],
        ),
      ],
    );
  }

  Widget _buildExteriorConditionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Exterior Condition',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildServiceTile('Paint correction', 'assets/cars.png'),
            _buildServiceTile('Collision correction', 'assets/car2.jpg'),
          ],
        ),
      ],
    );
  }

  Widget _buildMechanicalRepairContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mechanical Repair',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildServiceTile(
                'Spare parts replacements', 'assets/OIP (3).jpeg'),
          ],
        ),
      ],
    );
  }

  Widget _buildTyreServicesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tyre Services',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildServiceTile('Battery services', 'assets/OIP (4).jpeg'),
            _buildServiceTile('Tyre replacement', 'assets/OIP (5).jpeg'),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceTile(String title, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Container(
        width: 150, // Width of each service tile
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
