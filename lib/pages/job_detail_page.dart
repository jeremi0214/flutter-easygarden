import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailsPage extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final String budget;
  final String contact;

  const JobDetailsPage({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.budget,
    required this.contact,
  });

  void _launchContact() async {
    final Uri url = Uri.parse('tel:$contact'); // or use mailto:
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              icon: Icons.description,
              label: 'Description',
              value: description,
            ),
            _buildSection(
              icon: Icons.location_on,
              label: 'Location',
              value: location,
            ),
            _buildSection(
              icon: Icons.attach_money,
              label: 'Budget',
              value: budget,
            ),
            const SizedBox(height: 20),
            const Text(
              "Contact number:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _launchContact,
              child: Row(
                children: [
                  const Icon(Icons.phone, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    contact,
                    style: const TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required IconData icon, required String label, required String value}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}