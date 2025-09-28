import 'dart:async';

/// Kontrak notifikasi (agar mudah ganti ke FCM).
abstract class NotificationService {
  Future<void> requestPermission();
  Future<void> subscribeGlobalTopic();
  Stream<String> get onMessage; // payload sederhana
}

/// Implementasi mock.
/// TODO(Firebase): buat FcmNotificationService untuk implementasi asli.
class MockNotificationService implements NotificationService {
  final _ctrl = StreamController<String>.broadcast();

  @override
  Future<void> requestPermission() async {/* noop in mock */}

  @override
  Future<void> subscribeGlobalTopic() async {/* noop in mock */}

  @override
  Stream<String> get onMessage => _ctrl.stream;

  // Helper opsional untuk simulasi
  void simulateIncoming(String text) {
    _ctrl.add(text);
  }
}
