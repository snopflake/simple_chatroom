import 'package:flutter/material.dart';

// TODO[1]: (Firebase Core)
// - flutter pub add firebase_core
// - jalankan: flutterfire configure  (disarankan) → akan membuat firebase_options.dart
// - ganti komentar init di main() menjadi Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// - import 'package:firebase_core/firebase_core.dart'; dan 'firebase_options.dart'

import 'pages/login_page.dart';
import 'pages/chat_page.dart';
import 'services/auth_services.dart';
import 'services/firestore_services.dart';
import 'services/notification_services.dart';

/// Singletons sementara (mock).
/// TODO[2][3][4]: Setelah implementasi Firebase siap, GANTI instance Mock* menjadi Firebase*.
final AuthService authService = MockAuthService();
final FirestoreService firestoreService = MockFirestoreService(authService);
final NotificationService notificationService = MockNotificationService();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO[1]: Inisialisasi Firebase di sini saat sudah siap.
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Skeleton',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: AuthWrapper(
        auth: authService,
        firestore: firestoreService,
        notif: notificationService,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({
    super.key,
    required this.auth,
    required this.firestore,
    required this.notif,
  });

  final AuthService auth;
  final FirestoreService firestore;
  final NotificationService notif;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: auth.authStateChanges,
      builder: (context, snap) {
        // NOTE: dengan MockAuthService, snapshot awal langsung null → tampil LoginPage.
        if (snap.connectionState == ConnectionState.waiting) {
          // OPTIONAL: bisa fallback langsung ke LoginPage agar tidak "loading" lama.
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.data != null) {
          return ChatPage(auth: auth, firestore: firestore, notif: notif);
        }
        return LoginPage(auth: auth);
      },
    );
  }
}
