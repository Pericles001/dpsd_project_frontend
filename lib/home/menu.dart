import 'dart:convert';

import 'package:dpsd_project2_frontend_iteration_1/features/housing_ventilation/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/alerts/index.dart';
import '../features/faq/index.dart';
import '../features/profile/change_password.dart';
import '../api/api_service.dart';
import '../main.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  // User information
  String firstName = '';
  String lastName = '';
  String email = '';

  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool isEditing = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userJson = prefs.getString('user');
    if (userJson != null) {
      var user = jsonDecode(userJson);
      setState(() {
        firstName = user['firstName'];
        lastName = user['lastName'];
        email = user['email'];
        _firstNameController.text = firstName;
        _lastNameController.text = lastName;
        _emailController.text = email;
      });
    }
  }

  _updateUserInfo() async {
    // Create an instance of ApiService
    ApiService apiService = ApiService();

    // Get the token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    // Prepare the user data
    var user = {
      'firstName': _firstNameController.text.isEmpty
          ? firstName
          : _firstNameController.text,
      'lastName': _lastNameController.text.isEmpty
          ? lastName
          : _lastNameController.text,
      'email': _emailController.text.isEmpty ? email : _emailController.text,
    };

    // Call the API to update the user information
    var response = await apiService.updateUser(
      token,
      user['firstName']!,
      user['lastName']!,
      user['email']!,
    );

    // If the update was successful, save the updated information in the shared preferences
    await prefs.setString('user', jsonEncode(user));
    setState(() {
      firstName = user['firstName'] ?? '';
      lastName = user['lastName'] ?? '';
      email = user['email'] ?? '';

      isEditing = false;
    });
    }

  _deleteAccount() async {
    // Show warning dialog
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirm) {
      // Implement the account deletion
      print('Deleting account...');
      // retrieve the token from the shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var apiService = ApiService();
      bool success = await apiService.deleteUser(token!);

      // Show popup message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(success ? 'Success' : 'Error'),
            content: Text(success
                ? 'Account deleted successfully'
                : 'Failed to delete account'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (success) {
                    // Navigate to the welcome page if the deletion was successful
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Welcome $firstName $lastName'),
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
                child: ListTile(
                  title: const Text('Change Password'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: const Text('Delete Account'),
                  onTap: _deleteAccount,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (isEditing)
                        TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                          ),
                        )
                      else
                        ListTile(
                          leading: const Icon(Icons.account_circle),
                          title: Text('$firstName $lastName'),
                          subtitle: const Text('Full Name'),
                        ),
                      if (isEditing)
                        TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                          ),
                        ),
                      if (isEditing)
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                        )
                      else
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: Text(email),
                          subtitle: const Text('Email'),
                        ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: Icon(isEditing ? Icons.check : Icons.edit),
                          onPressed: () {
                            if (isEditing) {
                              _updateUserInfo();
                            } else {
                              setState(() {
                                isEditing = true;
                              });
                            }
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
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        showSelectedLabels: false,
        // Don't show labels for selected items
        showUnselectedLabels: false,
        // Don't show labels for unselected items
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeMenu()),
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
                MaterialPageRoute(builder: (context) => const AlertIndex()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQIndex()),
              );
              break;
            case 4:
              // Add your Pigs Manager page here
              break;
            case 5:
              _logout();
              break;
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
