import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../sources/calm_ayah_data.dart';

class CalmAyahCard extends StatefulWidget {
  const CalmAyahCard({super.key});

  @override
  State<CalmAyahCard> createState() => _CalmAyahCardState();
}

class _CalmAyahCardState extends State<CalmAyahCard> {
  int currentIndex = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Get today's date and use it as seed for daily ayah
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    currentIndex = dayOfYear % calmAyahs.length;

    // Optional: Keep the cycling timer for variety within the day
    timer = Timer.periodic(const Duration(seconds: 30), (_) {
      setState(() {
        currentIndex = (currentIndex + 1) % calmAyahs.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ayah = calmAyahs[currentIndex];

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.withOpacity(0.1),
              Colors.teal.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 HEADING
              Text(
                'Today\'s Ayah',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 ARABIC
              Text(
                ayah.arabic,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 14),

              // 🔹 TRANSLATION
              Text(
                ayah.translation,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 8),

              // 🔹 REFERENCE
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  ayah.reference,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
