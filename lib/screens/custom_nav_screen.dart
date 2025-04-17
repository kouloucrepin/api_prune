import 'package:flutter/material.dart';
import 'package:prune_classifier/screens/about_project.dart';
import 'camera_screen.dart';
import 'history_screen.dart';
import 'help_screen.dart';
import 'settings_screen.dart';

class CustomNavScreen extends StatefulWidget {
  const CustomNavScreen({super.key});

  @override
  State<CustomNavScreen> createState() => _CustomNavScreenState();
}

class _CustomNavScreenState extends State<CustomNavScreen> {
  int _selectedIndex = 2;
  late PageController _pageController;

  final List<Widget> _screens = const [
    HelpScreen(),
    HistoryScreen(),
    CameraScreen(),
    SettingsScreen(),
    AboutProjectScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _screens,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) {
              if (index == 2) {
                return GestureDetector(
                  onTap: () => _onTabSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _selectedIndex == index
                          ? Colors.deepPurple
                          : Colors.deepPurple.withOpacity(0.3),
                      boxShadow: [
                        if (_selectedIndex == index)
                          const BoxShadow(
                            color: Colors.deepPurple,
                            blurRadius: 12,
                          ),
                      ],
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                );
              } else {
                return IconButton(
                  icon: Icon(
                    _getIcon(index),
                    color: _selectedIndex == index
                        ? Colors.deepPurple
                        : Colors.grey,
                  ),
                  onPressed: () => _onTabSelected(index),
                );
              }
            }),
          ),
        ),
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.help_outline;
      case 1:
        return Icons.history;
      case 3:
        return Icons.settings;
      case 4:
        return Icons.info_outline;
      default:
        return Icons.circle;
    }
  }
}
