import 'package:hive/hive.dart';
import '../models/namaz_model.dart';

class LocalStorageService {
  static const String prayerBoxName = 'prayerBox';

  // Save prayer times
  Future<void> savePrayerTimes(List<PrayerTime> times) async {
    final box = await Hive.openBox(prayerBoxName);
    final data = times.map((e) => e.toMap()).toList();
    await box.put('today', data);
  }

  // Load prayer times
  Future<List<PrayerTime>> loadPrayerTimes() async {
    final box = await Hive.openBox(prayerBoxName);
    final data = box.get('today', defaultValue: []);
    return (data as List)
        .map((e) => PrayerTime.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }
}