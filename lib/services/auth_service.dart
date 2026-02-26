import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'namaz_sync_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Box _box = Hive.box('authBox');

  // 🔐 REGISTER
  Future<User?> register({required String email, required String password}) async {
    final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    // Save locally for offline login
    _box.put('isLoggedIn', true);
    _box.put('uid', result.user!.uid);
    _box.put('email', email);
    _box.put('password', password);

    return result.user;
  }

  // 🔑 LOGIN
  Future<User?> login({required String email, required String password}) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Save locally
      _box.put('isLoggedIn', true);
      _box.put('uid', result.user!.uid);
      _box.put('email', email);
      _box.put('password', password);

      return result.user;
    } catch (e) {
      // Offline login
      final savedEmail = _box.get('email');
      final savedPassword = _box.get('password');

      if (savedEmail == email && savedPassword == password) {
        _box.put('isLoggedIn', true);
        return null; // offline login, no Firebase user
      } else {
        rethrow; // credentials don't match
      }
    }
  }

  // 🔓 LOGOUT
  Future<void> logout() async {
    // Sync prayer data to MySQL before logout
    await NamazSyncService().syncOnLogout();

    try {
      await _auth.signOut();
    } catch (_) {}

    // Clear all local data
    _box.clear();

    // Clear other boxes
    final hijriBox = await Hive.openBox('hijriBox');
    await hijriBox.clear();

    final prayerBox = await Hive.openBox('prayerBox');
    await prayerBox.clear();

    // Clear any other boxes if they exist
    try {
      final zikrBox = await Hive.openBox('zikrBox');
      await zikrBox.clear();
    } catch (_) {}

    try {
      final namazBox = await Hive.openBox('namazBox');
      await namazBox.clear();
    } catch (_) {}

    try {
      final userBox = await Hive.openBox('userBox');
      await userBox.clear();
    } catch (_) {}
  }

  bool isLoggedIn() => _box.get('isLoggedIn', defaultValue: false);
}