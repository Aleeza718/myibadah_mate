import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quran_model.dart';

class QuranService {
  static Future<List<QuranSurah>> loadSurahs() async {
    final data = await rootBundle.loadString('assets/quran/quran.json');
    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((e) => QuranSurah.fromJson(e)).toList();
  }
}
