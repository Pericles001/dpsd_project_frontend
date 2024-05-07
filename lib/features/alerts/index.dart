import 'package:flutter/material.dart';

import '../../auth/login.dart';
import '../../home/menu.dart';
import '../faq/index.dart';
import '../housing_ventilation/index.dart';
import '../../api/api_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../pig/index.dart';

class AlertIndex extends StatefulWidget {
  const AlertIndex({super.key});

  @override
  _AlertIndexState createState() => _AlertIndexState();
}

class _AlertIndexState extends State<AlertIndex> {
  int _currentIndex = 0;
  final ApiService _apiService =
      ApiService(); // Create an instance of ApiService

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Define the actual values here
  double? temperature;
  double? humidity;
  double? precipitation;

  // Ambient variables
  Map<String, double> ambientVariables = {};

  // @override
  // void initState() {
  //   super.initState();
  //   fetchAndCompareWeatherData();
  // }

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    fetchAndCompareWeatherData();
  }

  Future<void> showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'alert_channel_id', 'Alerts', 'Notification for new alerts',
        importance: Importance.max, priority: Priority.high, showWhen: false);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }

  Future<void> fetchAndCompareWeatherData() async {
    try {
      final weatherData = await _apiService
          .fetchWeatherData('kigali'); // Replace 'city' with the actual city
      final ambientData = await _apiService.getAmbientVariables(
          'token'); // Replace 'token' with the actual token

      // Parse ambient variables
      for (var variable in ambientData) {
        ambientVariables[variable['name']] = variable['threshold'];
      }

      setState(() {
        temperature = weatherData['temperature'];
        humidity = weatherData['humidity'];
        precipitation = weatherData['precipitation'];
      });

      // Check if the weather data exceeds the thresholds and show a notification if it does
      if (temperature! > ambientVariables['temperature']!) {
        await showNotification(
            'Temperature Alert', 'The temperature is exceeding the threshold');
      }
      if (humidity! > ambientVariables['humidity']!) {
        await showNotification(
            'Humidity Alert', 'The humidity is exceeding the threshold');
      }
      if (precipitation! > ambientVariables['precipitation']!) {
        await showNotification('Precipitation Alert',
            'The precipitation is exceeding the threshold');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  Color getAlertColor(String variableName, double? value) {
    double threshold = ambientVariables.containsKey(variableName)
        ? ambientVariables[variableName]!
        : 0; // Use a default threshold of 0 if the variable does not exist in the ambient variables

    if (value == null) {
      return Colors.grey;
    } else if (value > threshold) {
      return Colors.red;
    } else if (value == threshold) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            color: getAlertColor('temperature', temperature),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('Temperature: ${temperature ?? 'Loading...'}'),
                  trailing: ElevatedButton(
                    child: const Text('Comments'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return FutureBuilder<String>(
                            future: _apiService.getPromptGemini(
                                'Temperature is ${(temperature ?? 0) > (ambientVariables['temp'] ?? 0) ? 'exceeding' : 'lower than'} the threshold'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Text('Loading comment...'),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Text('Error: ${snapshot.error}'),
                                  ),
                                );
                              } else {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Text('Comment: ${snapshot.data}'),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Card(
            color: getAlertColor('humidity', humidity),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('Humidity: ${humidity ?? 'Loading...'}'),
                  trailing: ElevatedButton(
                    child: const Text('Comments'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return FutureBuilder<String>(
                            future: _apiService.getPromptGemini(
                                'Humidity is ${(humidity ?? 0) > (ambientVariables['humidity'] ?? 0) ? 'exceeding' : 'lower than'} the threshold'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Text('Loading comment...'),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Text('Error: ${snapshot.error}'),
                                  ),
                                );
                              } else {
                                return AlertDialog(
                                  content: SingleChildScrollView(
                                    child: Text('Comment: ${snapshot.data}'),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
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
