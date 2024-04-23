import 'package:flutter/material.dart';
import 'package:dpsd_project2_frontend_iteration_1/api/api_service.dart';

class VentilationMonitor extends StatefulWidget {
  const VentilationMonitor({Key? key}) : super(key: key);

  @override
  _VentilationMonitorState createState() => _VentilationMonitorState();
}

class _VentilationMonitorState extends State<VentilationMonitor> {
  double? temperature;
  double? humidity;
  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    showCityDialog();
  }

  Future<void> showCityDialog() async {
    String? city;
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter City'),
          content: TextField(
            onChanged: (value) {
              city = value;
            },
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "Please enter the city of the farm",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                Navigator.pop(context);
                if (city != null && city!.isNotEmpty) {
                  fetchData(city!);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchData(String city) async {
    try {
      var data = await apiService.fetchWeatherData(city);

      setState(() {
        temperature = data['temperature'];
        humidity = data['humidity'];
      });
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor Variables'),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Temperature',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Current temperature: ${temperature ?? "Loading..."}°C',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Humidity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Current humidity: ${humidity ?? "Loading..."}%',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}