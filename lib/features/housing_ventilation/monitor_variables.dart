import 'package:flutter/material.dart';
import '../../api/api_service.dart';

class VentilationMonitor extends StatefulWidget {
  const VentilationMonitor({super.key});

  @override
  _VentilationMonitorState createState() => _VentilationMonitorState();
}

class _VentilationMonitorState extends State<VentilationMonitor> {
  double? temperature;
  double? humidity;
  double? precipitation;
  String? sunrise;
  String? sunset;
  final ApiService _apiService = ApiService(); // Create an instance of ApiService

  @override
  void initState() {
    super.initState();
    // We should not call the dialog immediately in initState
    // We'll delay it slightly to ensure the build context is fully available
    Future.delayed(Duration.zero, () {
      showCityDialog();
    });
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
              onPressed: () async {
                Navigator.pop(context);
                if (city != null && city!.isNotEmpty) {
                  try {
                    final weatherData = await _apiService.fetchWeatherData(city!);
                    setState(() {
                      temperature = weatherData['temperature'];
                      humidity = weatherData['humidity'];
                      precipitation = weatherData['precipitation'];
                      sunrise = weatherData['sun']['sunrise'];
                      sunset = weatherData['sun']['sunset'];
                      // You can parse and set other weather parameters here
                    });
                  } catch (e) {
                    print('Error fetching weather data: $e');
                    // Handle error if needed
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor Variables'),
      ),
      body: ListView(
        children: <Widget>[
          _buildWeatherCard('Temperature', temperature != null ? '$temperature°C' : 'Loading...'),
          _buildWeatherCard('Humidity', humidity != null ? '$humidity%' : 'Loading...'),
          _buildWeatherCard('Precipitation', precipitation != null ? '$precipitation' : 'Loading...'),
          _buildWeatherCard('Sunrise', sunrise ?? 'Loading...'),
          _buildWeatherCard('Sunset', sunset ?? 'Loading...'),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(String title, String value) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Current $title: $value',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
