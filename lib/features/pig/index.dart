import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/login.dart';
import '../../home/menu.dart';
import '../alerts/index.dart';
import '../faq/index.dart';
import '../../api/api_service.dart';
import '../housing_ventilation/index.dart';

class PigManagerIndex extends StatefulWidget {
  const PigManagerIndex({super.key});

  @override
  _PigManagerIndexState createState() => _PigManagerIndexState();
}

class _PigManagerIndexState extends State<PigManagerIndex> {
  int _currentIndex = 0;
  ApiService apiService = ApiService();
  String token = '';
  List<String> pigs = [];

  @override
  void initState() {
    super.initState();
    getToken();
    loadPigs();
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
    });
  }

  Future<void> addPig(String name, double weight, int age, String breed) async {
    bool isSuccess = false;
    try {
      await apiService.addPig(token, name, weight, age, breed);
      await loadPigs(); // Load the updated list of pigs
      isSuccess = true;
    } catch (e) {
      // Handle exception
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                isSuccess ? 'Pig added successfully' : 'Failed to add pig')),
      );
    }
  }

  Future<void> loadPigs() async {
    bool isSuccess = false;
    try {
      List<dynamic> pigList = await apiService.getAllPigs(token);
      setState(() {
        pigs = pigList.map<String>((pig) => pig['name'] as String).toList();
      });
      isSuccess = true;
    } catch (e) {
      // Handle exception
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(isSuccess
                ? 'Pigs loaded successfully'
                : 'Failed to load pigs')),
      );
    }
  }

  Future<void> addPigVitals(
    int pigId,
    double temperature,
    int heartRate,
    int respiratoryRate,
    double weight,
  ) async {
    bool isSuccess = false;
    try {
      await apiService.addVitals(
        token,
        pigId,
        temperature,
        heartRate,
        respiratoryRate,
        weight,
      );
      isSuccess = true;
    } catch (e) {
      // Handle exception
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(isSuccess
                ? 'Vitals added successfully'
                : 'Failed to add vitals')),
      );
    }
  }

  Future<String> checkPigDisease(String symptoms) async {
    try {
      String result = await apiService.identifyDisease(token, symptoms);
      return result;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to identify disease')),
      );
      return '';
    }
  }

  Future<List<dynamic>> getPigVitals(int pigId) async {
    try {
      List<dynamic> vitalsList = await apiService.getPigVitals(token, pigId);
      return vitalsList;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get pig vitals')),
      );
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pig Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                title: const Text('Add Pig'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Add Pig'),
                        content: AddPigForm(
                          onSubmit: (name, weight, age, breed) {
                            addPig(name, weight, age, breed);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: pigs.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(pigs[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              // Navigate to view vitals page
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ViewPigVitalsDialog(
                                    pigId: index + 1,
                                    // Assuming pigId starts from 1
                                    getPigVitals: getPigVitals,
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              // Navigate to add vitals page
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AddPigVitalsDialog(
                                    pigId: index + 1,
                                    // Assuming pigId starts from 1
                                    onSubmit: addPigVitals,
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.healing),
                            onPressed: () {
                              // Navigate to check disease page
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CheckPigDiseaseDialog(
                                    onSubmit: checkPigDisease,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
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

class AddPigForm extends StatefulWidget {
  final void Function(String name, double weight, int age, String breed)
      onSubmit;

  const AddPigForm({super.key, required this.onSubmit});

  @override
  _AddPigFormState createState() => _AddPigFormState();
}

class _AddPigFormState extends State<AddPigForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _weightController,
            decoration: const InputDecoration(labelText: 'Weight'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the weight';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _ageController,
            decoration: const InputDecoration(labelText: 'Age'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the age';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _breedController,
            decoration: const InputDecoration(labelText: 'Breed'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the breed';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit(
                  _nameController.text,
                  double.parse(_weightController.text),
                  int.parse(_ageController.text),
                  _breedController.text,
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    _breedController.dispose();
    super.dispose();
  }
}

class AddPigVitalsDialog extends StatelessWidget {
  final int pigId;
  final void Function(int pigId, double temperature, int heartRate,
      int respiratoryRate, double weight) onSubmit;

  const AddPigVitalsDialog({
    super.key,
    required this.pigId,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Pig Vitals'),
      content: AddPigVitalsForm(
        onSubmit: (temperature, heartRate, respiratoryRate, weight) {
          onSubmit(pigId, temperature, heartRate, respiratoryRate, weight);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vitals added successfully!'),
            ),
          );
        },
      ),
    );
  }
}

class AddPigVitalsForm extends StatefulWidget {
  final void Function(
          double temperature, int heartRate, int respiratoryRate, double weight)
      onSubmit;

  const AddPigVitalsForm({super.key, required this.onSubmit});

  @override
  _AddPigVitalsFormState createState() => _AddPigVitalsFormState();
}

class _AddPigVitalsFormState extends State<AddPigVitalsForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _respiratoryRateController =
      TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: _temperatureController,
            decoration: const InputDecoration(labelText: 'Temperature'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the temperature';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _heartRateController,
            decoration: const InputDecoration(labelText: 'Heart Rate'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the heart rate';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _respiratoryRateController,
            decoration: const InputDecoration(labelText: 'Respiratory Rate'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the respiratory rate';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _weightController,
            decoration: const InputDecoration(labelText: 'Weight'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the weight';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit(
                  double.parse(_temperatureController.text),
                  int.parse(_heartRateController.text),
                  int.parse(_respiratoryRateController.text),
                  double.parse(_weightController.text),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    _heartRateController.dispose();
    _respiratoryRateController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}

class ViewPigVitalsDialog extends StatelessWidget {
  final int pigId;
  final Future<List<dynamic>> Function(int pigId) getPigVitals;

  const ViewPigVitalsDialog({
    super.key,
    required this.pigId,
    required this.getPigVitals,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pig Vitals'),
      content: FutureBuilder(
        future: getPigVitals(pigId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Failed to load pig vitals: ${snapshot.error}');
          } else {
            List<dynamic> vitals = snapshot.data as List<dynamic>;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Temperature')),
                  DataColumn(label: Text('Heart Rate')),
                  DataColumn(label: Text('Respiratory Rate')),
                  DataColumn(label: Text('Weight')),
                ],
                rows: vitals
                    .map((vital) => DataRow(cells: [
                          DataCell(Text('${vital["temperature"]}')),
                          DataCell(Text('${vital["heartRate"]}')),
                          DataCell(Text('${vital["respiratoryRate"]}')),
                          DataCell(Text('${vital["weight"]}')),
                        ]))
                    .toList(),
              ),
            );
          }
        },
      ),
    );
  }
}

class CheckPigDiseaseDialog extends StatefulWidget {
  final Future<String> Function(String symptoms) onSubmit;

  const CheckPigDiseaseDialog({super.key, required this.onSubmit});

  @override
  _CheckPigDiseaseDialogState createState() => _CheckPigDiseaseDialogState();
}

class _CheckPigDiseaseDialogState extends State<CheckPigDiseaseDialog> {
  final TextEditingController _symptomsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Check Pig Diseases'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: _symptomsController,
            decoration: const InputDecoration(labelText: 'Symptoms'),
          ),
          ElevatedButton(
            onPressed: () async {
              String result = await widget.onSubmit(_symptomsController.text);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Disease Identification Result'),
                    content: Text(result),
                  );
                },
              );
            },
            child: const Text('Check Disease'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
  }
}
