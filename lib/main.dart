import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/library_screen.dart';
import 'screens/profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const SerengApp());
}

class SerengApp extends StatelessWidget {
  const SerengApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'SERENG',

      theme: ThemeData(
        brightness: Brightness.dark,

        scaffoldBackgroundColor:
            const Color(0xFF0B0B0F),

        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.dark,
        ),
      ),

      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState
    extends State<MainScreen> {

  int selectedIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    ExploreScreen(),
    LibraryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:
          const Color(0xFF0B0B0F),

      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),

      bottomNavigationBar: NavigationBar(

        height: 80,

        backgroundColor:
            const Color(0xFF111116),

        selectedIndex: selectedIndex,

        indicatorColor:
            const Color(0xFF4A4458),

        labelBehavior:
            NavigationDestinationLabelBehavior.alwaysShow,

        onDestinationSelected: (index) {

          setState(() {
            selectedIndex = index;
          });

        },

        destinations: const [

          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),

            selectedIcon: Icon(
              Icons.home,
            ),

            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.explore_outlined,
            ),

            selectedIcon: Icon(
              Icons.explore,
            ),

            label: 'Explore',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.library_music_outlined,
            ),

            selectedIcon: Icon(
              Icons.library_music,
            ),

            label: 'Library',
          ),

          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
            ),

            selectedIcon: Icon(
              Icons.person,
            ),

            label: 'Profile',
          ),

        ],
      ),
    );
  }
}
