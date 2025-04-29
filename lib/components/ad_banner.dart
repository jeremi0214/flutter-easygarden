import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageAdBanner extends StatelessWidget {
  final String imagePath;
  final String targetUrl;

  const ImageAdBanner({
    super.key,
    required this.imagePath,
    required this.targetUrl,
  });

  void _launchURL() async {
    final uri = Uri.parse(targetUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $targetUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchURL,
      child: Container(
        height: 80,
        color: Colors.transparent,
        child: Center(
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
