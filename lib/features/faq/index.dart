import 'package:dpsd_project2_frontend_iteration_1/components/navigation_bar.dart';
import 'package:flutter/material.dart';


class FAQIndex extends StatelessWidget {
  const FAQIndex({super.key});

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
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}