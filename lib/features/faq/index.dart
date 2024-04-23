import 'package:flutter/material.dart';

import '../../auth/login.dart';
import '../../home/menu.dart';
import '../alerts/index.dart';
import '../housing_ventilation/index.dart';

class FAQIndex extends StatefulWidget {
  const FAQIndex({super.key});

  @override
  _FAQIndexState createState() => _FAQIndexState();
}

class _FAQIndexState extends State<FAQIndex> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
      ),
      body: ListView(
        children: const <Widget>[
          Card(
            child: ListTile(
              title: Text('Question 1'),
              subtitle: Text('Answer 1'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Question 2'),
              subtitle: Text('Answer 2'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Question 3'),
              subtitle: Text('Answer 3'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        showSelectedLabels: false, // Don't show labels for selected items
        showUnselectedLabels: false, // Don't show labels for unselected items
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeMenu()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VentilationIndex()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AlertIndex()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FAQIndex()),
              );
              break;
            case 4:
            // Add your Pigs Manager page here
              break;
            case 5:
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage()),
              );
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
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}