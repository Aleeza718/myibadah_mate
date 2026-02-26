import 'package:hive/hive.dart';

class AuthLocalStorage {
  static const String boxName = 'authBox';

  static const String keyUid = 'uid';
  static const String keyEmail = 'email';

  final Box box;

  AuthLocalStorage(this.box);

  Future<void> saveUser({
    required String uid,
    required String email,
  }) async {
    await box.put(keyUid, uid);
    await box.put(keyEmail, email);
  }

  String? get uid => box.get(keyUid);
  String? get email => box.get(keyEmail);

  bool get isLoggedIn => uid != null;

  Future<void> clear() async {
    await box.clear();
  }
}