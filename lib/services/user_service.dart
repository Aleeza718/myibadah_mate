import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class UserService {
  static const String _boxName = 'userBox';
  static const String _usernameKey = 'username';

  /// Get username (email-based) – OFFLINE FIRST
  static Future<String> getUsername() async {
    final box = await Hive.openBox(_boxName);

    // 1️⃣ If stored locally → use it
    final cachedName = box.get(_usernameKey);
    if (cachedName != null) {
      return cachedName;
    }

    // 2️⃣ Else get from Firebase
    final user = FirebaseAuth.instance.currentUser;

    if (user?.email != null) {
      final email = user!.email!;
      final username = email.split('@').first;

      // Save locally for offline use
      await box.put(_usernameKey, username);
      return username;
    }

    return 'User';
  }

  /// Clear username on logout
  static Future<void> clearUser() async {
    final box = await Hive.openBox(_boxName);
    await box.delete(_usernameKey);
  }
}