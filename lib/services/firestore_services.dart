import 'dart:async';
import 'auth_services.dart';

/// ===== FIRESTORE (CHAT DB) =====
/// TODO[3]: Buat `FirebaseFirestoreService implements FirestoreService`
///   - flutter pub add cloud_firestore
///   - Collection: 'messages'
///   - Document fields: { senderId, senderEmail, text, timestamp(serverTimestamp) }
///   - messagesStream():
///       FirebaseFirestore.instance.collection('messages')
///         .orderBy('timestamp', descending: true)
///         .snapshots().map((qs) => qs.docs.map(...).toList())
///   - sendMessage(text):
///       add({ ..., 'timestamp': FieldValue.serverTimestamp() })

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

abstract class FirestoreService {
  Stream<List<Message>> messagesStream(); // real-time
  Future<void> sendMessage(String text);
}

/// Mock: in-memory list agar UI hidup tanpa backend
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
    _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp)); // old->new
    _ctrl.add(List<Message>.unmodifiable(_messages));
  }
}
