import 'package:dpsd_project2_frontend_iteration_1/features/housing_ventilation/set_treshold.dart';
import 'package:flutter/material.dart';

import '../../auth/login.dart';
import '../../home/menu.dart';
import '../alerts/index.dart';
import '../faq/index.dart';
import '' ; // Import the VentilationSetThreshold widget
import '../housing_ventilation/set_treshold.dart';

class VentilationIndex extends StatefulWidget {
  const VentilationIndex({Key? key}) : super(key: key);

  @override
  _VentilationIndexState createState() => _VentilationIndexState();
}

class _VentilationIndexState extends State<VentilationIndex> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventilation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: const Text('Set Threshold'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VentilationSetThreshold(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: const Text('Monitor Variables'),
                      onTap: () {
                        // Implement functionality for 'Monitor Variables' card
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Card(
              child: ListTile(
                title: Text('Guidelines'),
                subtitle: Text('General guide on ventilation goes here'),
              ),
            ),
            // Add more ventilation elements as needed
          ],
        ),
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