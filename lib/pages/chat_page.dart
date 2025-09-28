import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import '../services/firestore_services.dart';
import '../services/notification_services.dart';
import '../widgets/message_bubble.dart';

/// TODO[3]: Setelah punya FirebaseFirestoreService, ganti mockservice di main.dart.
/// TODO[4]: Saat FCM aktif, tampilkan snackbar ketika ada onMessage & atur background handler di main().
class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.auth,
    required this.firestore,
    required this.notif,
  });

  final AuthService auth;
  final FirestoreService firestore;
  final NotificationService notif;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _msgC = TextEditingController();
  final _scrollC = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.notif.requestPermission();
    widget.notif.subscribeGlobalTopic();

    // Listener notifikasi (mock/FCM)
    widget.notif.onMessage.listen((payload) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notif: $payload')));
    });
  }

  @override
  void dispose() {
    _msgC.dispose();
    _scrollC.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _msgC.text.trim();
    if (text.isEmpty) return;
    await widget.firestore.sendMessage(text);
    _msgC.clear();

    // Auto scroll ke bawah
    await Future.delayed(const Duration(milliseconds: 50));
    if (_scrollC.hasClients) {
      _scrollC.animateTo(
        _scrollC.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room (Skeleton)'),
        actions: [
          IconButton(
            tooltip: 'Keluar',
            onPressed: () => widget.auth.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: widget.firestore.messagesStream(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snap.data!;
                return ListView.builder(
                  controller: _scrollC,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final m = messages[i];
                    return MessageBubble(message: m, currentUser: user);
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgC,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Tulis pesan…',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _send,
                    icon: const Icon(Icons.send),
                    label: const Text('Kirim'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
