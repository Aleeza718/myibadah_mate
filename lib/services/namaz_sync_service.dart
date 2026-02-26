import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/hijri_service.dart';

class NamazSyncService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Box _prayerBox = Hive.box('prayerBox');
  final String baseUrl = 'https://triolence.com/ibadah'; // Replace with your actual domain

  // Sync prayer data to MySQL via API
  Future<void> syncToMySQL() async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Check connectivity
    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = !connectivityResults.contains(ConnectivityResult.none);
    if (!isOnline) return;

    try {
      final idToken = await user.getIdToken();
      final prayerData = <Map<String, dynamic>>[];

      // Get all prayer tracking data from local storage
      for (var key in _prayerBox.keys) {
        if (key is String && key.contains('-')) {
          final parts = key.split('-');
          if (parts.length == 2) {
            // Use Gregorian date directly for sync
            final gregorianDate = parts[0];

            prayerData.add({
              'prayer_date': gregorianDate,
              'prayer_name': parts[1],
              'completed': _prayerBox.get(key, defaultValue: false),
            });
          }
        }
      }

      for (var prayer in prayerData) {
        final response = await http.post(
          Uri.parse('$baseUrl/index.php'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          },
          body: jsonEncode(prayer),
        );

        if (response.statusCode != 200) {
          print('Error syncing prayer: ${response.body}');
        }
      }
    } catch (e) {
      print('Error syncing prayer data to MySQL: $e');
    }
  }

  // Sync prayer data from MySQL via API
  Future<void> syncFromMySQL() async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Check connectivity
    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = !connectivityResults.contains(ConnectivityResult.none);
    if (!isOnline) return;

    try {
      final idToken = await user.getIdToken();
      final response = await http.get(
        Uri.parse('$baseUrl/index.php?streak=1'),
        headers: {
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prayers = data['prayers'] as List<dynamic>;

        for (var prayer in prayers) {
          final key = '${prayer['prayer_date']}-${prayer['prayer_name']}';
          final localValue = _prayerBox.get(key, defaultValue: false);
          // If remote is true and local is false, update local
          if (prayer['completed'] == true && localValue == false) {
            _prayerBox.put(key, true);
          }
        }
      }
    } catch (e) {
      print('Error syncing prayer data from MySQL: $e');
    }
  }

  // Sync on login
  Future<void> syncOnLogin() async {
    await syncFromMySQL();
  }

  // Sync on logout
  Future<void> syncOnLogout() async {
    await syncToMySQL();
  }

  // Periodic sync (call this periodically when app is active)
  Future<void> periodicSync() async {
    await syncToMySQL();
    await syncFromMySQL();
  }

  // Save a single prayer record to MySQL
  Future<void> savePrayerToDB(String prayerDate, String prayerName, bool completed) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Check connectivity
    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = !connectivityResults.contains(ConnectivityResult.none);
    if (!isOnline) {
      print('Offline: Prayer save queued');
      // TODO: Implement offline queue
      return;
    }

    try {
      final idToken = await user.getIdToken();

      print('Attempting to save prayer: Gregorian $prayerDate - $prayerName - $completed');
      final response = await http.post(
        Uri.parse('$baseUrl/index.php'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'prayer_date': prayerDate, // Use Gregorian date
          'prayer_name': prayerName,
          'completed': completed,
        }),
      );
      print('API Response received: Status ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Prayer saved to DB: $prayerDate - $prayerName - $completed');
      } else {
        print('Error saving prayer: ${response.body}');
      }
    } catch (e) {
      print('Error saving prayer to DB: $e');
    }
  }

  // Get user streak from database
  Future<Map<String, int>?> getUserStreakFromDB() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    // Check connectivity
    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = !connectivityResults.contains(ConnectivityResult.none);
    if (!isOnline) {
      print('Offline: Cannot fetch streak data');
      return null;
    }

    try {
      final idToken = await user.getIdToken();
      final response = await http.get(
        Uri.parse('$baseUrl/index.php'),
        headers: {
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'current_streak': data['current_streak'] ?? 0,
          'longest_streak': data['longest_streak'] ?? 0,
        };
      } else {
        print('Error fetching streak: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching streak from DB: $e');
      return null;
    }
  }
}
