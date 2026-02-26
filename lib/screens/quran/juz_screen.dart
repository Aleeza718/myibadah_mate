import 'package:flutter/material.dart';
import '../../models/quran_model.dart';
import '../../services/juz_mapping.dart';
import 'surah_detail_screen.dart';

class JuzScreen extends StatefulWidget {
  final List<QuranSurah> surahs;

  const JuzScreen({super.key, required this.surahs});

  @override
  State<JuzScreen> createState() => _JuzScreenState();
}

class _JuzScreenState extends State<JuzScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filter juz based on search query
    final filteredJuz = juzMap.where((juz) {
      final query = _searchQuery.toLowerCase();
      return juz['juz'].toString().contains(query);
    }).toList();

    return Column(
      children: [
        // ---------------- SEARCH BAR ----------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search Juz by number',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // ---------------- JUZ LIST ----------------
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredJuz.length,
            itemBuilder: (context, index) {
              final juz = filteredJuz[index];
              final juzNumber = juz['juz'];
              final startSurah = widget.surahs.firstWhere(
                (s) => s.id == juz['surah'],
                orElse: () => widget.surahs.first,
              );

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SurahDetailScreen(
                        surahs: widget.surahs,
                        startSurahIndex: widget.surahs.indexOf(startSurah),
                        currentJuz: juzNumber,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.deepPurple.withOpacity(0.2),
                        child: Text(
                          '$juzNumber',
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Juz $juzNumber',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Starts from ${startSurah.name} (${startSurah.transliteration})',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
