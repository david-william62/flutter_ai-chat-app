import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'services/firebase_service.dart';
import 'services/gemini_service.dart';
import 'services/auth_service.dart';
import 'providers/chat_provider.dart';
import 'screens/auth_gate.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Error loading .env file: $e');
    debugPrint('Please create a .env file from .env.example');
  }

  try {
    // Initialize Firebase
    if (kIsWeb) {
      // Web needs manual configuration
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
          appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
          messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
          projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
          storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
          databaseURL: dotenv.env['FIREBASE_DATABASE_URL'] ?? '',
        ),
      );
    } else {
      // Android/iOS use google-services.json/GoogleService-Info.plist
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint('Error initializing Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseService>(create: (_) => FirebaseService()),
        Provider<GeminiService>(
          create: (_) => GeminiService(dotenv.env['GEMINI_API_KEY'] ?? ''),
        ),
        Provider<AuthService>(
          create: (_) =>
              AuthService(webClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID']),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider<ChatProvider>(
          create: (context) => ChatProvider(
            context.read<FirebaseService>(),
            context.read<GeminiService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'AI Chat Bot',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
      ),
    );
  }
}
