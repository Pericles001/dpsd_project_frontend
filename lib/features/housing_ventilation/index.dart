import 'package:flutter/material.dart';
import 'package:dpsd_project2_frontend_iteration_1/components/navigation_bar.dart';

class VentilationIndex extends StatelessWidget {
  const VentilationIndex({super.key});

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
                        // Implement functionality for 'Set Threshold' card
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
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}