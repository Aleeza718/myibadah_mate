import 'package:flutter/material.dart';

class AppNavBar extends StatelessWidget {
  final int currentIndex;

  const AppNavBar({
    super.key,
    required this.currentIndex,
  });

  void _onItemTapped(BuildContext context, int index) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    String targetRoute;

    switch (index) {
      case 0:
        targetRoute = '/home';
        break;
      case 1:
        targetRoute = '/quran';
        break;
      case 2:
        targetRoute = '/namaz';
        break;
      case 3:
        targetRoute = '/qibla';
        break;
      case 4:
        targetRoute = '/tasbih';
        break;
      default:
        return;
    }

    if (currentRoute != targetRoute) {
      Navigator.pushNamed(context, targetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'Quran',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: 'Namaz',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Qibla',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.circle_outlined),
          label: 'Tasbih',
        ),
      ],
    );
  }
}