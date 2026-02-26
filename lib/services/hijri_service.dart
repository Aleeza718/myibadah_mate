import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../models/hijri_date_model.dart';

class HijriService {
  static const String _boxName = 'hijriBox';
  static const String _key = 'todayHijri';
  static const String _dateKey = 'cachedDate';

  /// Fetch live Hijri date from API, cache for the day
  static Future<HijriDateModel?> getHijriDate() async {
    final box = await Hive.openBox(_boxName);

    // Check if cached for today
    final cached = box.get(_key);
    final cachedDate = box.get(_dateKey);
    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (cached != null && cachedDate == today) {
      print('Using cached Hijri date for today');
      return HijriDateModel.fromMap(
        Map<String, dynamic>.from(cached),
      );
    }

    print('Fetching Hijri date from API');
    try {
      // Use current Gregorian date for Hijri conversion
      final now = DateTime.now();
      final dateStr = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

      final response = await http.get(
        Uri.parse(
          'https://api.aladhan.com/v1/gToH?date=$dateStr',
        ),
      );

      print('Hijri API response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API data: $data');
        final hijri = data['data']['hijri'];
        final day = hijri['day'].toString();
        final month = hijri['month']['en'];
        final year = hijri['year'].toString();

        final model = HijriDateModel(
          day: day,
          month: month,
          year: year,
          weekday: hijri['weekday']['en'],
        );

        // Cache the result
        await box.put(_key, model.toMap());
        await box.put(_dateKey, today);

        print('Hijri date fetched and cached: ${model.day} ${model.month} ${model.year}');
        return model;
      } else {
        print('Hijri API response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching Hijri date: $e');
    }

    // Fallback if API fails
    print('Using fallback Hijri date');
    final model = HijriDateModel(
      day: '15',
      month: 'Rabi\' al-awwal',
      year: '1446',
      weekday: 'Al Juma\'a',
    );
    await box.put(_key, model.toMap());
    await box.put(_dateKey, today);
    return model;

    return null;
  }
}
