import 'package:ai_chat_bot/apis/appwrite.dart';
import 'package:ai_chat_bot/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import "pages/profile.dart";
import "pages/chat.dart";
import "pages/home.dart";

var apiKey = env['gemini_api_key'] ?? '';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    Gemini.init(apiKey: apiKey);
    Appwrite.init(env['db_id']);
  } catch (e) {
    debugPrint("Could not load .env file: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = [HomePage(), ChatPage(), ProfilePage()];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xff020d1f),
          unselectedItemColor: Colors.white,
          selectedItemColor: const Color.fromARGB(179, 171, 216, 223),
          currentIndex: selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.white),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded, color: Colors.white),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.white),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
