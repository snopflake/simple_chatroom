import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import 'pages/chat_page.dart';
import 'services/auth_services.dart';
import 'services/firestore_services.dart';
import 'services/notification_services.dart';

/// Singletons sederhana.
/// TODO(Firebase): ganti ke implementasi Firebase di sini jika sudah siap.
final AuthService authService = MockAuthService();
final FirestoreService firestoreService = MockFirestoreService(authService);
final NotificationService notificationService = MockNotificationService();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO(Firebase): panggil Firebase.initializeApp() ketika integrasi Firebase diaktifkan.
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
        if (snap.connectionState == ConnectionState.waiting) {
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
