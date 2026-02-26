import '../models/prayer_times.dart';
import '../models/namaz_model.dart';

// Utility functions for prayer times
class PrayerUtils {
  static List<PrayerTime> convertNamazModelToPrayerTimes(NamazModel namazModel) {
    return [
      PrayerTime(name: 'Fajr', time: namazModel.fajr),
      PrayerTime(name: 'Dhuhr', time: namazModel.dhuhr),
      PrayerTime(name: 'Asr', time: namazModel.asr),
      PrayerTime(name: 'Maghrib', time: namazModel.maghrib),
      PrayerTime(name: 'Isha', time: namazModel.isha),
    ];
  }
}
