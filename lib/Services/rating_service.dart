import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RatingService {
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.tesbee.release';

  static Future<void> openPlayStore() async {
    final Uri url = Uri.parse(playStoreUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> showRatingDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Uygulamayı Değerlendir'),
        content: const Text('Eğer uygulamamızı beğendiyseniz, Play Store\'da değerlendirmeyi unutmayın!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Daha Sonra'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openPlayStore();
            },
            child: const Text('Değerlendir'),
          ),
        ],
      ),
    );
  }
}