import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import '../local/auth_local_storage.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthLocalStorage _localStorage =
      AuthLocalStorage(Hive.box('authBox'));

  Future<User?> register({
    required String email,
    required String password,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;
    if (user != null) {
      await _localStorage.saveUser(
        uid: user.uid,
        email: user.email ?? '',
      );
    }

    return user;
  }

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;
    if (user != null) {
      await _localStorage.saveUser(
        uid: user.uid,
        email: user.email ?? '',
      );
    }

    return user;
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _localStorage.clear();
  }

  bool get isLoggedIn => _localStorage.isLoggedIn;
}