import 'package:flutter/material.dart';
import '../services/firestore_services.dart';
import '../services/auth_services.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.currentUser,
  });

  final Message message;
  final AppUser? currentUser;

  bool get isMine => currentUser?.uid == message.senderId;

  @override
  Widget build(BuildContext context) {
    final align = isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bg = isMine ? Colors.blue : Colors.grey.shade300;
    final fg = isMine ? Colors.white : Colors.black87;

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: align,
            children: [
              if (!isMine)
                Text(message.senderEmail, style: TextStyle(fontSize: 10, color: fg.withOpacity(0.8))),
              Text(message.text, style: TextStyle(color: fg, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
