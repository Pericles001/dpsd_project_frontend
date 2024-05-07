import 'package:dpsd_project2_frontend_iteration_1/features/housing_ventilation/monitor_variables.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/login.dart';
import '../../home/menu.dart';
import '../alerts/index.dart';
import '../faq/index.dart';
import '../../api/api_service.dart';
import '../pig/index.dart';

class VentilationIndex extends StatefulWidget {
  const VentilationIndex({super.key});

  @override
  _VentilationIndexState createState() => _VentilationIndexState();
}

class _VentilationIndexState extends State<VentilationIndex> {
  int _currentIndex = 0;
  ApiService apiService = ApiService();
  String token = '';
  List<String> conversation = [];

  @override
  void initState() {
    super.initState();
    getToken();
    loadVariables();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
    });
  }

  Future<void> saveVariable(String name, double threshold) async {
    try {
      // Call the function to add the variable to the database
      await apiService.addAmbientVariable(token, name, threshold);

      // If the function call is successful, save the variable to the local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> variables = prefs.getStringList('variables') ?? [];
      variables.add('$name:$threshold');
      await prefs.setStringList('variables', variables);
    } catch (e) {
      // Handle any errors that occur during the function call
      print('Failed to add variable: $e');
    }
  }

  Future<void> loadVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> variables = prefs.getStringList('variables') ?? [];
    // Now you can use the 'variables' list to display the variables
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventilation & Marketing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: const Text('Add variable'),
                      onTap: () {
                        final formKey = GlobalKey<FormState>();
                        final nameController = TextEditingController();
                        final thresholdController = TextEditingController();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Add Variable'),
                              content: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TextFormField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Name of variable',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the name of the variable';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: thresholdController,
                                      decoration: const InputDecoration(
                                        labelText: 'Threshold of variable',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the threshold of the variable';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Submit'),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      try {
                                        await saveVariable(
                                          nameController.text,
                                          double.parse(
                                              thresholdController.text),
                                        );
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Variable added successfully')),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Failed to add variable')),
                                        );
                                      }
                                    }
                                  },
                                ),
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VentilationMonitor(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final formKey = GlobalKey<FormState>();
                final promptController = TextEditingController();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('Guidelines'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Form(
                                  key: formKey,
                                  child: TextFormField(
                                    controller: promptController,
                                    decoration: const InputDecoration(
                                      labelText:
                                          'Enter your question here (Marketing - Ventilation...)',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your question';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                ...conversation.map((message) => Text(message)),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Submit'),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  var response = await apiService
                                      .getPromptGemini(promptController.text);
                                  setState(() {
                                    conversation.add(promptController.text);
                                    conversation.add(response);
                                  });
                                }
                              },
                            ),
                            TextButton(
                              child: const Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              child: const Card(
                child: ListTile(
                  title: Text('Guidelines'),
                  subtitle: Text('Ask questions here'),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Ambient Variables',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  FutureBuilder<List<dynamic>>(
                    future: apiService.getAmbientVariables(token),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(snapshot.data?[index]['name']),
                                subtitle: Text(
                                  'Threshold: ${snapshot.data?[index]['threshold'].toString()}',
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PigManagerIndex()),
              );
              break;
            case 5:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
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
