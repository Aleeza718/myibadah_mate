class HijriDateModel {
  final String day;
  final String month;
  final String year;
  final String weekday;

  HijriDateModel({
    required this.day,
    required this.month,
    required this.year,
    required this.weekday,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'month': month,
      'year': year,
      'weekday': weekday,
    };
  }

  factory HijriDateModel.fromMap(Map data) {
    return HijriDateModel(
      day: data['day'],
      month: data['month'],
      year: data['year'],
      weekday: data['weekday'],
    );
  }

  String formatted() {
    return '$weekday, $day $month $year AH';
  }
}