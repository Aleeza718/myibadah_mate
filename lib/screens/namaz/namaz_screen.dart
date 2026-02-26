import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../models/prayer_times.dart';
import '../../services/prayer_service.dart';
import '../../services/namaz_sync_service.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_navbar.dart';
import '../../theme/app_colors.dart';

class NamazScreen extends StatefulWidget {
  const NamazScreen({super.key});

  @override
  State<NamazScreen> createState() => _NamazScreenState();
}

class _NamazScreenState extends State<NamazScreen> {
  PrayerTimes? timings;
  bool loading = true;
  int currentStreak = 0;
  bool streakLoading = false;

  final List<String> prayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
  late Box prayerBox;
  late NamazSyncService _syncService;

  @override
  void initState() {
    super.initState();
    prayerBox = Hive.box('prayerBox');
    _syncService = NamazSyncService();
    _loadData();
  }

  Future<void> _loadData() async {
    timings = await PrayerService.getTodayPrayerTimes();
    // Sync from DB on load
    await _syncService.syncFromMySQL();
    setState(() => loading = false);
  }

  bool _isPrayed(String prayer) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return prayerBox.get('$today-$prayer', defaultValue: false);
  }

  void _togglePrayer(String prayer) async {
    final now = DateTime.now();
    final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final newValue = !_isPrayed(prayer);
    prayerBox.put('$today-$prayer', newValue);
    setState(() {});
    // Sync to DB
    try {
      await _syncService.savePrayerToDB(today, prayer, newValue);
    } catch (e) {
      // Handle error silently or show snackbar if needed
      print('Error syncing prayer: $e');
    }
  }

  int _todayCount() {
    return prayers.where(_isPrayed).length;
  }

  int _currentStreak() {
    int streak = 0;
    DateTime day = DateTime.now();

    while (true) {
      final keyDate = day.toIso8601String().substring(0, 10);
      final allDone = prayers.every(
        (p) => prayerBox.get('$keyDate-$p', defaultValue: false),
      );
      if (!allDone) break;
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Widget _buildMonthlyProgressChart() {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month, 1);
    final lastMonth = DateTime(now.year, now.month - 1, 1);

    int thisMonthPrayers = 0;
    int lastMonthPrayers = 0;
    int totalDays = now.day;

    for (int day = 1; day <= totalDays; day++) {
      final date = DateTime(now.year, now.month, day);
      final dateKey = date.toIso8601String().substring(0, 10);

      for (final prayer in prayers) {
        if (prayerBox.get('$dateKey-$prayer', defaultValue: false)) {
          thisMonthPrayers++;
        }
      }
    }

    for (int day = 1; day <= 30; day++) {
      final date = DateTime(lastMonth.year, lastMonth.month, day);
      final dateKey = date.toIso8601String().substring(0, 10);

      for (final prayer in prayers) {
        if (prayerBox.get('$dateKey-$prayer', defaultValue: false)) {
          lastMonthPrayers++;
        }
      }
    }

    final thisMonthAvg = (thisMonthPrayers / (totalDays * 5) * 100).round();
    final lastMonthAvg = (lastMonthPrayers / (30 * 5) * 100).round();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('This Month: $thisMonthAvg%', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Last Month: $lastMonthAvg%', style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: thisMonthAvg / 100,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildMonthlyMotivation() {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month, 1);
    final lastMonth = DateTime(now.year, now.month - 1, 1);

    int thisMonthPrayers = 0;
    int lastMonthPrayers = 0;
    int totalDays = now.day;

    for (int day = 1; day <= totalDays; day++) {
      final date = DateTime(now.year, now.month, day);
      final dateKey = date.toIso8601String().substring(0, 10);

      for (final prayer in prayers) {
        if (prayerBox.get('$dateKey-$prayer', defaultValue: false)) {
          thisMonthPrayers++;
        }
      }
    }

    for (int day = 1; day <= 30; day++) {
      final date = DateTime(lastMonth.year, lastMonth.month, day);
      final dateKey = date.toIso8601String().substring(0, 10);

      for (final prayer in prayers) {
        if (prayerBox.get('$dateKey-$prayer', defaultValue: false)) {
          lastMonthPrayers++;
        }
      }
    }

    final improvement = thisMonthPrayers - lastMonthPrayers;
    final isOneMonthComplete = now.day >= 30;

    if (!isOneMonthComplete) {
      return const Text(
        'Complete this month to see your progress!',
        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      );
    }

    if (improvement > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎉 Great progress! You prayed ${improvement.abs()} more times this month!',
            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '"And whoever fears Allah - He will make for him a way out and will provide for him from where he does not expect." — Qur\'an 65:2-3',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade700),
          ),
        ],
      );
    } else if (improvement < 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📈 Keep going! You can improve next month.',
            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '"And whoever fears Allah - He will make for him a way out." — Qur\'an 65:2',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade700),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '✨ Consistent! You maintained your prayer routine.',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '"Indeed, prayer prohibits immorality and wrongdoing." — Qur\'an 29:45',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade700),
          ),
        ],
      );
    }
  }

  Widget _buildMotivationalCard() {
    final todayCount = _todayCount();
    final streak = _currentStreak();

    String verse;

    if (todayCount == 0) {
      verse = '"Indeed, the prayer is enjoined on the believers at fixed times." — Qur\'an 4:103';
    } else if (todayCount < 3) {
      verse = '"And seek help through patience and prayer." — Qur\'an 2:153';
    } else if (todayCount < 5) {
      verse = '"Indeed, those who have believed and done righteous deeds - they will have the Gardens of Paradise." — Qur\'an 18:107';
    } else {
      verse = '"Successful indeed are the believers." — Qur\'an 23:1';
    }

    return Card(
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.menu_book, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Quran Wisdom',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              verse,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Color(0xFF616161),
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMonthlyReport(BuildContext context) {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month, 1);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Monthly Prayer Report'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: now.day,
            itemBuilder: (context, index) {
              final day = index + 1;
              final date = DateTime(now.year, now.month, day);
              final dateKey = date.toIso8601String().substring(0, 10);
              final dayName = DateFormat('EEEE').format(date);

              int completed = 0;
              for (final prayer in prayers) {
                if (prayerBox.get('$dateKey-$prayer', defaultValue: false)) {
                  completed++;
                }
              }

              return ListTile(
                title: Text('$dayName, ${DateFormat('MMM d').format(date)}'),
                trailing: Text('$completed / 5'),
                leading: Icon(
                  completed == 5 ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: completed == 5 ? Colors.green : Colors.grey,
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      /// ✅ SAME APP BAR AS HOME
      appBar: const AppBarWidget(title: 'Namaz'),

      /// ✅ DRAWER ADDED
      drawer: const AppDrawer(),

      /// ✅ BOTTOM NAVBAR ADDED
      bottomNavigationBar: const AppNavBar(currentIndex: 2),

      body: loading || timings == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [

                /// 🌙 TIMINGS CARD
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Today\'s Namaz Timings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _row('Fajr', timings!.fajr),
                        _row('Dhuhr', timings!.dhuhr),
                        _row('Asr', timings!.asr),
                        _row('Maghrib', timings!.maghrib),
                        _row('Isha', timings!.isha),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ✅ PROGRESS CARD
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Today\'s Progress',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: prayers.map((p) {
                            final done = _isPrayed(p);
                            return GestureDetector(
                              onTap: () => _togglePrayer(p),
                              child: Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: done
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    p[0],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: done
                                          ? Colors.white
                                          : Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${_todayCount()} / 5 prayers completed',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔥 STREAK CARD
                Card(
                  color: Colors.deepPurple.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Current Streak',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '🔥 ${_currentStreak()} days',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 📊 MONTHLY PROGRESS CARD
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Monthly Progress',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () => _showMonthlyReport(context),
                              child: const Text('View Details'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildMonthlyProgressChart(),
                        const SizedBox(height: 12),
                        _buildMonthlyMotivation(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 💪 MOTIVATIONAL SUPPORT
                _buildMotivationalCard(),
              ],
            ),
    );
  }

  Widget _row(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            time,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}