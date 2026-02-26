class QuranCard {
  final String id;
  final String title;
  final String ayah;
  final String translation;
  final String imageUrl; // optional, for dashboard visuals
  final DateTime date; // to track the day

  QuranCard({
    required this.id,
    required this.title,
    required this.ayah,
    required this.translation,
    required this.imageUrl,
    required this.date,
  });

  // Convert Firestore map to object
  factory QuranCard.fromMap(Map<String, dynamic> map) {
    return QuranCard(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      ayah: map['ayah'] ?? '',
      translation: map['translation'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      date: DateTime.parse(map['date']),
    );
  }

  // Convert object to map for Hive/Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'ayah': ayah,
      'translation': translation,
      'imageUrl': imageUrl,
      'date': date.toIso8601String(),
    };
  }
}