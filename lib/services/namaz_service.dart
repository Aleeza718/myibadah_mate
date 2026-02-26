import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/namaz_model.dart';

class NamazService {
  static Future<NamazModel?> getTodayNamazTimings({
    required String city,
    required String country,
  }) async {
    try {
      final url =
          'https://api.aladhan.com/v1/timingsByCity?city=$city&country=$country&method=2';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final timings = data['data']['timings'];

      return NamazModel.fromJson(timings);
    } catch (e) {
      return null;
    }
  }
}