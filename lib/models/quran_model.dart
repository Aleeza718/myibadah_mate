class QuranVerse {
  final int id;
  final String text;

  QuranVerse({required this.id, required this.text});

  factory QuranVerse.fromJson(Map<String, dynamic> json) {
    return QuranVerse(
      id: json['id'],
      text: json['text'],
    );
  }
}

class QuranSurah {
  final int id;
  final String name;
  final String transliteration;
  final String type;
  final int totalVerses;
  final List<QuranVerse> verses;

  QuranSurah({
    required this.id,
    required this.name,
    required this.transliteration,
    required this.type,
    required this.totalVerses,
    required this.verses,
  });

  factory QuranSurah.fromJson(Map<String, dynamic> json) {
    return QuranSurah(
      id: json['id'],
      name: json['name'],
      transliteration: json['transliteration'],
      type: json['type'],
      totalVerses: json['total_verses'],
      verses: (json['verses'] as List)
          .map((v) => QuranVerse.fromJson(v))
          .toList(),
    );
  }
}
