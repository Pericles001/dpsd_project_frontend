import 'package:flutter/material.dart';

import '../../auth/login.dart';
import '../../home/menu.dart';
import '../alerts/index.dart';
import '../housing_ventilation/index.dart';
import '../pig/index.dart';

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
              title: Text('Question: How do I recover my password? '),
              subtitle: Text('Answer: You can recover your password by clicking on the "Forgot password?" link on the login page. You will receive an email with instructions on how to reset your password.'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Question: How can I add a new pig to my account?'),
              subtitle: Text('Answer: You can add a new pig to your account by clicking on the "Add Pig" button on the Pigs Manager page. You will need to enter the pig\'s details, such as its name, breed, and age.'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Question: How do I view the weather forecast for my location?'),
              subtitle: Text('Answer: You can view the weather forecast for your location by clicking on the "Ambient" tab on the bottom navigation bar. You will see the current temperature, humidity, and other weather parameters for your location.)'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Question: How do I receive alerts for my pigs?'),
              subtitle: Text('Answer: You can receive alerts for your pigs by clicking on the "Alerts" tab on the bottom navigation bar. You will receive alerts for important events, such as high temperature, low humidity, and other conditions that may affect your pigs.'),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PigManagerIndex()),
              );
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