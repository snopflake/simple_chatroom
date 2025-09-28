import 'dart:async';
import 'dart:math';

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

class MockAuthService implements AuthService {
  final _controller = StreamController<AppUser?>.broadcast();
  AppUser? _user;

  MockAuthService(); // <-- tidak perlu add(null) di sini

  // ✅ KIRIM state saat ini dulu, lalu teruskan stream berikutnya
  @override
  Stream<AppUser?> get authStateChanges async* {
    yield _user;               // emit nilai awal (null saat belum login)
    yield* _controller.stream; // teruskan update selanjutnya
  }

  @override
  AppUser? get currentUser => _user;

  @override
  Future<AppUser?> signIn(String email, String password) async {
    _user = AppUser(uid: _randId(), email: email);
    _controller.add(_user);
    return _user;
  }

  @override
  Future<AppUser?> signUp(String email, String password) async {
    _user = AppUser(uid: _randId(), email: email);
    _controller.add(_user);
    return _user;
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(null);
  }

  String _randId() =>
      DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(9999).toString();
}
