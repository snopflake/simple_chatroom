import 'dart:async';
import 'dart:math';

/// ===== AUTH SERVICE =====
/// TODO[2]: Buat class `FirebaseAuthService implements AuthService`
///   - flutter pub add firebase_auth
///   - map:
///       signIn   -> FirebaseAuth.instance.signInWithEmailAndPassword(...)
///       signUp   -> FirebaseAuth.instance.createUserWithEmailAndPassword(...)
///       signOut  -> FirebaseAuth.instance.signOut()
///       stream   -> FirebaseAuth.instance.authStateChanges()
///   - AppUser bisa diisi dari User.uid & User.email

class AppUser {
  final String uid;
  final String email;
  AppUser({required this.uid, required this.email});
}

abstract class AuthService {
  Stream<AppUser?> get authStateChanges;
  AppUser? get currentUser;

  Future<AppUser?> signIn(String email, String password);
  Future<AppUser?> signUp(String email, String password);
  Future<void> signOut();
}

/// Mock: berjalan tanpa backend (untuk skeleton & demo UI)
class MockAuthService implements AuthService {
  final _controller = StreamController<AppUser?>.broadcast();
  AppUser? _user;

  MockAuthService();

  // Penting: emit state awal agar AuthWrapper tidak "loading" selamanya.
  @override
  Stream<AppUser?> get authStateChanges async* {
    yield _user;               // awal (null jika belum login)
    yield* _controller.stream; // berikutnya
  }

  @override
  AppUser? get currentUser => _user;

  @override
  Future<AppUser?> signIn(String email, String password) async {
    _user = AppUser(uid: _randId(), email: email);
    _controller.add(_user);
    return _user;
    // TODO[2]: di FirebaseAuthService, return dari credential.user
  }

  @override
  Future<AppUser?> signUp(String email, String password) async {
    _user = AppUser(uid: _randId(), email: email);
    _controller.add(_user);
    return _user;
    // TODO[2]: di FirebaseAuthService, return dari credential.user
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(null);
    // TODO[2]: FirebaseAuth.instance.signOut()
  }

  String _randId() =>
      DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(9999).toString();
}
