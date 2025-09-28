import 'dart:async';
import 'auth_services.dart';

/// Model pesan sederhana (UI-friendly).
class Message {
  final String id;
  final String senderId;
  final String senderEmail;
  final String text;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.senderId,
    required this.senderEmail,
    required this.text,
    required this.timestamp,
  });
}

/// Kontrak database chat.
abstract class FirestoreService {
  Stream<List<Message>> messagesStream(); // real-time
  Future<void> sendMessage(String text);
}

/// Implementasi mock (in-memory).
/// TODO(Firebase): buat FirebaseFirestoreService yang implement kontrak ini.
class MockFirestoreService implements FirestoreService {
  final AuthService _auth;
  final _ctrl = StreamController<List<Message>>.broadcast();
  final List<Message> _messages = [];

  MockFirestoreService(this._auth) {
    _ctrl.add(const []);
  }

  @override
  Stream<List<Message>> messagesStream() => _ctrl.stream;

  @override
  Future<void> sendMessage(String text) async {
    final user = _auth.currentUser;
    if (user == null || text.trim().isEmpty) return;

    final msg = Message(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      senderId: user.uid,
      senderEmail: user.email,
      text: text.trim(),
      timestamp: DateTime.now(),
    );
    _messages.add(msg);
    // urutkan dari yang lama ke baru; UI bisa reverse bila perlu
    _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    _ctrl.add(List<Message>.unmodifiable(_messages));
  }
}
