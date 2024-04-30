import 'package:flutter/material.dart';

class DietIndex extends StatefulWidget {
  const DietIndex({Key? key}) : super(key: key);

  @override
  _DietIndexState createState() => _DietIndexState();
}

class _DietIndexState extends State<DietIndex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Index'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'General Diet Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'A balanced diet is essential for the health and productivity of pigs on your farm. Here are some general guidelines:'
                    '\n\n1. Provide a mix of grains, vegetables, and protein sources.'
                    '\n\n2. Ensure access to clean, fresh water at all times.'
                    '\n\n3. Monitor feed intake and adjust portions based on pig age and weight.'
                    '\n\n4. Avoid overfeeding to prevent obesity and health issues.'
                    '\n\n5. Consult with a veterinarian or nutritionist for specific dietary recommendations.',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
