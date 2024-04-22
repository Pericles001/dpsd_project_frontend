import 'package:dpsd_project2_frontend_iteration_1/home/menu.dart';
import 'package:flutter/material.dart';
import '../features/alerts/index.dart';
import '../features/faq/index.dart';
import '../features/housing_ventilation/index.dart';


class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  final _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          HomeMenu(),
          VentilationIndex(),
          AlertIndex(),
          FAQIndex(),
          // Add your Pigs Manager page here
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HomeMenu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Ambient',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'FAQ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Pigs Manager',
          ),
        ],
      ),
    );
  }
}


