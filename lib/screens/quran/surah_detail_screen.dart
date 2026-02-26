import 'package:flutter/material.dart';
import '../../models/quran_model.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_navbar.dart';

class SurahDetailScreen extends StatefulWidget {
  final List<QuranSurah> surahs;
  final int startSurahIndex;
  final int? currentJuz;

  const SurahDetailScreen({
    super.key,
    required this.surahs,
    required this.startSurahIndex,
    this.currentJuz,
  });

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  late int currentSurahIndex;
  late ScrollController _scrollController;
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    currentSurahIndex = widget.startSurahIndex;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  QuranSurah get surah => widget.surahs[currentSurahIndex];

  void _onScroll() {
    if (!_scrollController.hasClients || _dialogOpen) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 40) {
      _askNextSurah();
    }

    if (position.pixels <= position.minScrollExtent) {
      _askPreviousSurah();
    }
  }

  Future<void> _askNextSurah() async {
    if (currentSurahIndex >= widget.surahs.length - 1) return;

    _dialogOpen = true;

    final go = await _confirmDialog(
      title: 'Next Surah',
      message: 'Do you want to continue to the next Surah?',
    );

    _dialogOpen = false;

    if (go) _animateSurahChange(currentSurahIndex + 1, fromTop: true);
  }

  Future<void> _askPreviousSurah() async {
    if (currentSurahIndex <= 0) return;

    _dialogOpen = true;

    final go = await _confirmDialog(
      title: 'Previous Surah',
      message: 'Do you want to return to the previous Surah?',
    );

    _dialogOpen = false;

    if (go) _animateSurahChange(currentSurahIndex - 1, fromTop: false);
  }

  Future<bool> _confirmDialog({
    required String title,
    required String message,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Continue'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _animateSurahChange(int newIndex, {required bool fromTop}) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: SurahDetailScreen(
              surahs: widget.surahs,
              startSurahIndex: newIndex,
              currentJuz: widget.currentJuz,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBismillah() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.all(16),
      child: const Text(
        'بِسْمِ ٱللَّٰهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'AmiriQuran',
          fontSize: 32,
          height: 2,
          color: Color(0xFF2E1A47),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildVerse(QuranVerse verse) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            verse.text,
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'AmiriQuran',
              fontSize: 28,
              height: 1.8,
              color: Color(0xFF2E1A47),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFD4AF37),
              ),
              child: Text(
                '${verse.id}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4FA),
      appBar: AppBar(
        title: Text(
          widget.currentJuz != null
              ? 'Juz ${widget.currentJuz} — ${surah.name} — ${surah.transliteration} (${surah.type})'
              : '${surah.name} — ${surah.transliteration} (${surah.type})',
        ),
      ),
      drawer: const AppDrawer(),
      bottomNavigationBar: const AppNavBar(currentIndex: 1),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: surah.verses.length + 1,
        itemBuilder: (context, index) {
          if (index == 0 && surah.id != 9) {
            return _buildBismillah();
          }

          final verseIndex = surah.id == 9 ? index : index - 1;
          if (verseIndex < 0 || verseIndex >= surah.verses.length) {
            return const SizedBox.shrink();
          }

          return _buildVerse(surah.verses[verseIndex]);
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}