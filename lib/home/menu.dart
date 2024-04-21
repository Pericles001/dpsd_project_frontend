import 'package:flutter/material.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu ({super.key});

  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  // Assuming you have a User model with the following fields
  String fullName = 'John Doe';
  String gender = 'Male';
  String role = 'Farmer';
  String birthdate = '1990-01-01';

  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $fullName'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: const ListTile(
                  title: Text('Option 1'),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: const ListTile(
                  title: Text('Option 2'),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (isEditing)
                        TextFormField(
                          initialValue: fullName,
                          onChanged: (value) {
                            fullName = value;
                          },
                        )
                      else
                        ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: Text(fullName),
                          subtitle: const Text('Full Name'),
                        ),
                      if (isEditing)
                        TextFormField(
                          initialValue: gender,
                          onChanged: (value) {
                            gender = value;
                          },
                        )
                      else
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(gender),
                          subtitle: const Text('Gender'),
                        ),
                      if (isEditing)
                        TextFormField(
                          initialValue: role,
                          onChanged: (value) {
                            role = value;
                          },
                        )
                      else
                        ListTile(
                          leading: const Icon(Icons.work),
                          title: Text(role),
                          subtitle: const Text('Role'),
                        ),
                      if (isEditing)
                        TextFormField(
                          initialValue: birthdate,
                          onChanged: (value) {
                            birthdate = value;
                          },
                        )
                      else
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: Text(birthdate),
                          subtitle: const Text('Birthdate'),
                        ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              isEditing = !isEditing;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
bottomNavigationBar: BottomNavigationBar(
  selectedItemColor: Theme.of(context).colorScheme.secondary,
  unselectedItemColor: Theme.of(context).colorScheme.onSurface,
  showSelectedLabels: false, // Don't show labels for selected items
  showUnselectedLabels: false, // Don't show labels for unselected items
  items: const <BottomNavigationBarItem>[
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