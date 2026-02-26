import 'package:flutter/material.dart';
import '../../models/namaz_model.dart';
import '../../models/hijri_date_model.dart';

class GreetingWidget extends StatelessWidget {
  final String username;
  const GreetingWidget({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Good morning, $username! Strengthen your Ibadah today ✨',
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class HijriBadge extends StatelessWidget {
  final HijriDateModel hijriDate;
  const HijriBadge({super.key, required this.hijriDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${hijriDate.day} ${hijriDate.month} ${hijriDate.year} AH',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class PrayerCard extends StatelessWidget {
  final PrayerTime prayer;
  const PrayerCard({super.key, required this.prayer});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(prayer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(prayer.time),
          ],
        ),
      ),
    );
  }
}