import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderDetailsPage extends StatelessWidget {
  final String name;
  final String contact;
  final String email;
  final String location;
  final String services;

  const ProviderDetailsPage({
    super.key,
    required this.name,
    required this.contact,
    required this.email,
    required this.location,
    required this.services,
  });

  void _launchPhone() async {
    final Uri url = Uri.parse('tel:$contact');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _launchEmail() async {
    final Uri url = Uri.parse('mailto:$email');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Services",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(services, style: const TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 20),

            _buildSection(
              icon: Icons.location_on,
              label: 'Location',
              value: location,
            ),
            GestureDetector(
              onTap: _launchPhone,
              child: _buildSection(
                icon: Icons.phone,
                label: 'Contact',
                value: contact,
                isLink: true,
              ),
            ),
            GestureDetector(
              onTap: _launchEmail,
              child: _buildSection(
                icon: Icons.email,
                label: 'Email',
                value: email,
                isLink: true,
              ),
            ),            
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String label,
    required String value,
    bool isLink = false,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: isLink ? Colors.blue : Colors.black,
            decoration: isLink ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}