import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  final Function(int)? onSelectTab;
  final Map<String, String>? namazTimings;
  final VoidCallback? onLogout;

  const AppDrawer({
    super.key,
    this.onSelectTab,
    this.namazTimings,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFC8A2C8), Color(0xFF9575CD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IbadahMate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),

          /// 🏠 Home
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              if (onSelectTab != null) {
                onSelectTab!(0);
              } else {
                final currentRoute = ModalRoute.of(context)?.settings.name;
                if (currentRoute != '/home') {
                  Navigator.pushNamed(context, '/home');
                }
              }
            },
          ),

          /// 📖 Quran
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Quran'),
            onTap: () {
              Navigator.pop(context);
              if (onSelectTab != null) {
                onSelectTab!(1);
              } else {
                final currentRoute = ModalRoute.of(context)?.settings.name;
                if (currentRoute != '/quran') {
                  Navigator.pushNamed(context, '/quran');
                }
              }
            },
          ),

          /// 🕌 Namaz
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Namaz Timings'),
            onTap: () {
              Navigator.pop(context);
              final currentRoute = ModalRoute.of(context)?.settings.name;
              if (currentRoute != '/namaz') {
                Navigator.pushNamed(context, '/namaz');
              }
            },
          ),

          /// 🧭 Qibla (ADDED — nothing else)
          ListTile(
            leading: const Icon(Icons.explore),
            title: const Text('Qibla Direction'),
            onTap: () {
              Navigator.pop(context);
              final currentRoute = ModalRoute.of(context)?.settings.name;
              if (currentRoute != '/qibla') {
                Navigator.pushNamed(context, '/qibla');
              }
            },
          ),

          /// 🔢 Tasbih
          ListTile(
            leading: const Icon(Icons.format_list_numbered),
            title: const Text('Tasbih Counter'),
            onTap: () {
              Navigator.pop(context);
              final currentRoute = ModalRoute.of(context)?.settings.name;
              if (currentRoute != '/tasbih') {
                Navigator.pushNamed(context, '/tasbih');
              }
            },
          ),

          /// ⚙️ Settings
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              final currentRoute = ModalRoute.of(context)?.settings.name;
              if (currentRoute != '/settings') {
                Navigator.pushNamed(context, '/settings');
              }
            },
          ),

          const Divider(),

          /// 🔒 Logout
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              // Sign out and clear all local data
              await AuthService().logout();

              // Navigate to login screen immediately
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, '/login');
              });
            },
          ),
        ],
      ),
    );
  }
}