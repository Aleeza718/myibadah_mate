import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../services/prayer_service.dart';
import '../../services/user_service.dart';
import '../../services/hijri_service.dart';

import '../../models/prayer_times.dart';
import '../../models/hijri_date_model.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/app_navbar.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/calm_ayah_card.dart';
import '../../theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<PrayerTimes?> _prayerFuture;
  late Future<String> _usernameFuture;
  late Future<HijriDateModel?> _hijriFuture;
  late Box _prayerBox;

  @override
  void initState() {
    super.initState();

    _prayerFuture = PrayerService.getTodayPrayerTimes();
    _usernameFuture = UserService.getUsername();
    _hijriFuture = HijriService.getHijriDate();
    _prayerBox = Hive.box('prayerBox');
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, d MMMM y').format(DateTime.now());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const AppBarWidget(title: 'IbadahMate'),
      drawer: const AppDrawer(),
      bottomNavigationBar: const AppNavBar(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🌸 PEACE CARD
              _peaceCard(),

              const SizedBox(height: 20),

              /// 👋 GREETING
              FutureBuilder<String>(
                future: _usernameFuture,
                builder: (context, snapshot) {
                  final name = snapshot.data ?? '';
                  return Text(
                    name.isEmpty
                        ? 'Assalamu Alaikum 🌙'
                        : 'Assalamu Alaikum, $name 🌙',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),

              const SizedBox(height: 6),
              Text(
                'Strengthen your Ibadah today',
                style: TextStyle(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7)),
              ),

              const SizedBox(height: 16),

              /// 📅 TODAY CARD
              _todayCard(today),

              /// 🌙 HIJRI DATE
              FutureBuilder<HijriDateModel?>(
                future: _hijriFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.nights_stay, color: Colors.deepPurple),
                          SizedBox(width: 12),
                          Text('Loading Hijri date...'),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 12),
                          Text('Unable to load Hijri date'),
                        ],
                      ),
                    );
                  }

                  final h = snapshot.data!;
                  return _hijriCard(
                    '${h.day} ${h.month} ${h.year} AH',
                  );
                },
              ),

              const SizedBox(height: 20),

              /// 🕌 PRAYER TIMES WITH TRACKING
              FutureBuilder<PrayerTimes?>(
                future: _prayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Text(
                      'Unable to load prayer times',
                      style: TextStyle(color: Colors.red),
                    );
                  }

                  final p = snapshot.data!;
                  final currentPrayer = _getCurrentPrayer(p);

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: Colors.deepPurple),
                            const SizedBox(width: 10),
                            Text(
                              'Current Prayer: $currentPrayer',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            _prayerTileWithTracking('Fajr', p.fajr, currentPrayer == 'Fajr'),
                            _prayerTileWithTracking('Dhuhr', p.dhuhr, currentPrayer == 'Dhuhr'),
                            _prayerTileWithTracking('Asr', p.asr, currentPrayer == 'Asr'),
                            _prayerTileWithTracking('Maghrib', p.maghrib, currentPrayer == 'Maghrib'),
                            _prayerTileWithTracking('Isha', p.isha, currentPrayer == 'Isha'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Prayer Progress Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Today\'s Progress',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_getCompletedPrayersCount()} / 5 completed',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              /// 🌿 TODAY'S AYAH
              const CalmAyahCard(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _peaceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB39DDB), Color(0xFF9575CD)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Peace begins within',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '“Surely, in the remembrance of Allah do hearts find rest.”\n— Qur’an 13:28',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _todayCard(String today) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
              Text(today,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _hijriCard(String hijriDate) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.nights_stay, color: Colors.deepPurple),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hijri Date',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
              Text(hijriDate,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _prayerTileWithTracking(String name, String time, bool isActive) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final isCompleted = _prayerBox.get('$today-$name', defaultValue: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green.withOpacity(0.1)
            : isActive
                ? Colors.deepPurple.withOpacity(0.12)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCompleted ? Colors.green : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _togglePrayerCompletion(name),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? Colors.green : Colors.grey.shade300,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : const SizedBox(),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isCompleted
                      ? Colors.green
                      : isActive
                          ? Colors.deepPurple
                          : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Text(
            time,
            style: TextStyle(
              color: isCompleted
                  ? Colors.green
                  : isActive
                      ? Colors.deepPurple
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- LOGIC ----------------

  String _getCurrentPrayer(PrayerTimes p) {
    final now = DateTime.now();

    DateTime parse(String t) {
      final parts = t.split(':');
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    }

    final fajr = parse(p.fajr);
    final dhuhr = parse(p.dhuhr);
    final asr = parse(p.asr);
    final maghrib = parse(p.maghrib);
    final isha = parse(p.isha);

    if (now.isBefore(fajr)) return 'Isha';
    if (now.isBefore(dhuhr)) return 'Fajr';
    if (now.isBefore(asr)) return 'Dhuhr';
    if (now.isBefore(maghrib)) return 'Asr';
    if (now.isBefore(isha)) return 'Maghrib';
    return 'Isha';
  }

  void _togglePrayerCompletion(String prayerName) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final key = '$today-$prayerName';
    final currentStatus = _prayerBox.get(key, defaultValue: false);
    _prayerBox.put(key, !currentStatus);
    setState(() {});
  }

  int _getCompletedPrayersCount() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final prayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    int completed = 0;

    for (final prayer in prayers) {
      if (_prayerBox.get('$today-$prayer', defaultValue: false)) {
        completed++;
      }
    }

    return completed;
  }
}
