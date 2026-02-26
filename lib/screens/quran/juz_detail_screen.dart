// lib/screens/quran/juz_detail_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_navbar.dart';
import '../../models/quran_model.dart';
import '../../services/juz_mapping.dart';

class JuzDetailScreen extends StatefulWidget {
  final List<QuranSurah> surahs;
  final int juzNumber;

  const JuzDetailScreen({
    super.key,
    required this.surahs,
    required this.juzNumber,
  });

  @override
  State<JuzDetailScreen> createState() => _JuzDetailScreenState();
}

class _JuzDetailScreenState extends State<JuzDetailScreen> {
  late List<QuranVerse> verses;
  late int currentJuzNumber;

  @override
  void initState() {
    super.initState();
    currentJuzNumber = widget.juzNumber;
    verses = _loadJuzVerses(currentJuzNumber);
  }

  List<QuranVerse> _loadJuzVerses(int juzNumber) {
    final map = juzMap.firstWhere((j) => j['juz'] == juzNumber);
    int startSurahId = map['surah'];
    int startAyahId = map['ayah'];

    List<QuranVerse> collected = [];

    for (var surah in widget.surahs) {
      if (surah.id < startSurahId) continue;

      for (var verse in surah.verses) {
        if (surah.id == startSurahId && verse.id < startAyahId) continue;
        collected.add(verse);
      }

      // Stop when reaching next Juz
      final nextJuz = juzMap.firstWhere(
        (j) => j['juz'] == juzNumber + 1,
        orElse: () => {},
      );
      if (nextJuz.isNotEmpty && surah.id == nextJuz['surah']) break;
    }

    return collected;
  }

  void loadNextJuz() {
    if (currentJuzNumber < 30) {
      setState(() {
        currentJuzNumber++;
        verses.addAll(_loadJuzVerses(currentJuzNumber));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4FA),
      appBar: AppBarWidget(title: 'Juz $currentJuzNumber'),
      drawer: const AppDrawer(),
      bottomNavigationBar: const AppNavBar(currentIndex: 1),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scroll) {
          if (scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 50) {
            loadNextJuz();
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: verses.length,
          itemBuilder: (context, index) {
            final verse = verses[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                verse.text,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'AmiriQuran',
                  fontSize: 28,
                  height: 1.6,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
