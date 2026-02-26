class NamazModel {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  NamazModel({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory NamazModel.fromJson(Map<String, dynamic> json) {
    return NamazModel(
      fajr: json['Fajr'],
      dhuhr: json['Dhuhr'],
      asr: json['Asr'],
      maghrib: json['Maghrib'],
      isha: json['Isha'],
    );
  }
}

class PrayerTime {
  final String name;
  final String time;

  PrayerTime({
    required this.name,
    required this.time,
  });

  factory PrayerTime.fromMap(Map<String, dynamic> map) {
    return PrayerTime(
      name: map['name'],
      time: map['time'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time,
    };
  }
}
