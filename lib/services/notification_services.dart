import 'dart:async';

/// ===== PUSH NOTIFICATION (FCM) =====
/// TODO[4]: Buat `FcmNotificationService implements NotificationService`
///   - flutter pub add firebase_messaging
///   - iOS: requestPermission() wajib
///   - subscribeGlobalTopic(): FirebaseMessaging.instance.subscribeToTopic('chatroom')
///   - onMessage: FirebaseMessaging.onMessage
///   - main(): set handler background (onBackgroundMessage) dan init permission
/// TODO[5]: Atur rules App Check/keamanan jika diperlukan

abstract class NotificationService {
  Future<void> requestPermission();
  Future<void> subscribeGlobalTopic();
  Stream<String> get onMessage; // payload sederhana
}

class MockNotificationService implements NotificationService {
  final _ctrl = StreamController<String>.broadcast();

  @override
  Future<void> requestPermission() async {/* noop */}

  @override
  Future<void> subscribeGlobalTopic() async {/* noop */}

  @override
  Stream<String> get onMessage => _ctrl.stream;

  // Utility untuk simulasi manual saat demo
  void simulateIncoming(String text) => _ctrl.add(text);
}
