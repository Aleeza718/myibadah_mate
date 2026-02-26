class ZikrItem {
  final String arabic;
  final String transliteration;
  final String translation;
  final String purpose;
  final String count;

  ZikrItem({
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.purpose,
    required this.count,
  });

  factory ZikrItem.fromJson(Map<String, dynamic> json) {
    return ZikrItem(
      arabic: json['arabic'] ?? '',
      transliteration: json['transliteration'] ?? '',
      translation: json['translation'] ?? '',
      purpose: json['purpose'] ?? '',
      count: json['count'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arabic': arabic,
      'transliteration': transliteration,
      'translation': translation,
      'purpose': purpose,
      'count': count,
    };
  }
}

class AsmaUlHusnaItem {
  final String arabic;
  final String en;
  final String ur;

  AsmaUlHusnaItem({
    required this.arabic,
    required this.en,
    required this.ur,
  });

  factory AsmaUlHusnaItem.fromJson(Map<String, dynamic> json) {
    return AsmaUlHusnaItem(
      arabic: json['arabic'] ?? '',
      en: json['en'] ?? '',
      ur: json['ur'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arabic': arabic,
      'en': en,
      'ur': ur,
    };
  }
}
