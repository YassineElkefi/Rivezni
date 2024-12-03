import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivezni/core/providers/auth_provider.dart';
import 'package:rivezni/features/authentication/screens/login.dart';
import 'package:rivezni/features/discover/screens/discover.dart';
import 'package:rivezni/features/home/screens/home.dart';
import 'package:rivezni/features/settings/screens/settings.dart';

class Navigation_Bar extends StatefulWidget {
  const Navigation_Bar({super.key});

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<Navigation_Bar> {
  int _selectedIndex = 1;

  final List<Widget> _widgetOptions = <Widget>[
    const Settings(),
    const Home(),
    const Discover(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: _selectedIndex == index ? 8.0 : 4.0),
        child: Icon(
          icon,
          size: _selectedIndex == index ? 30.0 : 24.0,
          color: _selectedIndex == index ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (!authProvider.isLoggedIn) {
          return const Login();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Rivezni'),
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: Stack(
            children: [
              BottomAppBar(
                shape: const CircularNotchedRectangle(),
                notchMargin: 6.0,
                child: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.settings, 0),
                      _buildNavItem(Icons.folder_copy_rounded, 1),
                      _buildNavItem(Icons.location_searching_rounded, 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
