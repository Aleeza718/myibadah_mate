import 'namaz_model.dart';

class PrayerTimes {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  PrayerTimes({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      fajr: json['Fajr'],
      dhuhr: json['Dhuhr'],
      asr: json['Asr'],
      maghrib: json['Maghrib'],
      isha: json['Isha'],
    );
  }

  factory PrayerTimes.fromPrayerTimeList(List<PrayerTime> times) {
    return PrayerTimes(
      fajr: times.firstWhere((t) => t.name == 'Fajr', orElse: () => PrayerTime(name: 'Fajr', time: '00:00')).time,
      dhuhr: times.firstWhere((t) => t.name == 'Dhuhr', orElse: () => PrayerTime(name: 'Dhuhr', time: '00:00')).time,
      asr: times.firstWhere((t) => t.name == 'Asr', orElse: () => PrayerTime(name: 'Asr', time: '00:00')).time,
      maghrib: times.firstWhere((t) => t.name == 'Maghrib', orElse: () => PrayerTime(name: 'Maghrib', time: '00:00')).time,
      isha: times.firstWhere((t) => t.name == 'Isha', orElse: () => PrayerTime(name: 'Isha', time: '00:00')).time,
    );
  }

  List<PrayerTime> toPrayerTimeList() {
    return [
      PrayerTime(name: 'Fajr', time: fajr),
      PrayerTime(name: 'Dhuhr', time: dhuhr),
      PrayerTime(name: 'Asr', time: asr),
      PrayerTime(name: 'Maghrib', time: maghrib),
      PrayerTime(name: 'Isha', time: isha),
    ];
  }

  Map<String, dynamic> toJson() {
    return {
      'Fajr': fajr,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Maghrib': maghrib,
      'Isha': isha,
    };
  }
}
