import 'package:flutter/material.dart';
import '../features/faq/index.dart';
import '../features/housing_ventilation/index.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: -1, // Set to -1 so no item is selected
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Theme.of(context).colorScheme.onSurface,
      showSelectedLabels: false, // Don't show labels for selected items
      showUnselectedLabels: false, // Don't show labels for unselected items
      onTap: (index) {
        switch (index) {
          case 0: // 'HomeMenu' item
            return;
          case 1: // 'Ambient' item
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VentilationIndex()),
            );
            break;
          case 2: // 'Alerts' item
            // Implement navigation to Alerts page
            break;
          case 3: // 'FAQ' item
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FAQIndex()),
            );
            break;
          case 4: // 'Pigs Manager' item
            // Implement navigation to Pigs Manager page
            break;
          // Add more conditions here for other items if needed
        }
      },
      items: const <BottomNavigationBarItem>[
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
    );
  }
}