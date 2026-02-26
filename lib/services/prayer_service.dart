import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/prayer_times.dart';
import 'location_service.dart';
import 'local_storage_service.dart';

class PrayerService {
  static final LocationService _locationService = LocationService();
  static final LocalStorageService _localStorage = LocalStorageService();

  static Future<PrayerTimes?> getTodayPrayerTimes() async {
    try {
      // Check connectivity
      final connectivityResults = await Connectivity().checkConnectivity();
      final isOnline = !connectivityResults.contains(ConnectivityResult.none);

      // Try to get from cache first if offline
      if (!isOnline) {
        final cachedTimes = await _localStorage.loadPrayerTimes();
        if (cachedTimes.isNotEmpty) {
          return PrayerTimes.fromPrayerTimeList(cachedTimes);
        }
        return null;
      }

      // Get user location
      final position = await LocationService.getCurrentPosition();
      if (position == null) {
        // Fallback to cached data
        final cachedTimes = await _localStorage.loadPrayerTimes();
        if (cachedTimes.isNotEmpty) {
          return PrayerTimes.fromPrayerTimeList(cachedTimes);
        }
        return null;
      }

      // Fetch from API using coordinates
      final url =
          'https://api.aladhan.com/v1/timings?latitude=${position.latitude}&longitude=${position.longitude}&method=2';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        // Fallback to cached data
        final cachedTimes = await _localStorage.loadPrayerTimes();
        if (cachedTimes.isNotEmpty) {
          return PrayerTimes.fromPrayerTimeList(cachedTimes);
        }
        return null;
      }

      final data = jsonDecode(response.body);
      final timings = data['data']['timings'];

      final prayerTimes = PrayerTimes.fromJson(timings);

      // Cache the data locally
      if (prayerTimes != null) {
        await _localStorage.savePrayerTimes(prayerTimes.toPrayerTimeList());
      }

      return prayerTimes;
    } catch (e) {
      // Fallback to cached data on any error
      try {
        final cachedTimes = await _localStorage.loadPrayerTimes();
        if (cachedTimes.isNotEmpty) {
          return PrayerTimes.fromPrayerTimeList(cachedTimes);
        }
      } catch (cacheError) {
        // Ignore cache errors
      }
      return null;
    }
  }
}
