import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/src/mock_client.dart';

class ApiService {
  // static const String _baseUrl = 'http://10.0.2.2:8080/api';
  static const String _baseUrl = 'http://172.29.105.191:8080/api';
  static const Duration _timeoutDuration = Duration(seconds: 30); // Increase the timeout duration

  set client(MockClient client) {
    http.Client();
  }

  Future<String> registerTestUser() async {
    var client = http.Client();
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$_baseUrl/register'));
    request.body = json.encode({
      "firstName": "new_test",
      "lastName": "new_test13",
      "email": "new_test24d@test",
      "password": "default"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await client.send(request);

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      throw Exception('Failed to register test user: ${response.reasonPhrase}');
    }
  }
  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
  var response = await http.get(Uri.parse(
      'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$city?unitGroup=metric&key=LQ892399QVFZUUCELK66XYCSF&contentType=json'));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var temperature = data['days'][0]['temp'];
    var humidity = data['days'][0]['humidity'];
    var precipitation = data['days'][0]['precip'];
    var sun = {
      'sunrise': data['days'][0]['sunrise'],
      'sunset': data['days'][0]['sunset'],
    };
    var wind = {
      'windgust': data['days'][0]['windgust'],
      'windspeed': data['days'][0]['windspeed'],
      'winddir': data['days'][0]['winddir'],
    };
    return {
      'temperature': temperature,
      'humidity': humidity,
      'precipitation': precipitation,
      'sun': sun,
      'wind': wind,
    };
  } else {
    throw Exception('Failed to load data');
  }
}

Future<Map<String, dynamic>> registerUser(String firstName, String lastName, String email, String password) async {
  try {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$_baseUrl/register'));
    request.body = json.encode({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send().timeout(_timeoutDuration); // Add the timeout

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
      print('User registered successfully');
    } else {
      throw Exception('Failed to register user. Status code: ${response.statusCode}, Reason: ${response.reasonPhrase}');
    }
  } on TimeoutException catch (_) {
    throw Exception('Request timed out. Please try again.');
  }
}

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('$_baseUrl/login'));
      request.body = json.encode({
        "email": email,
        "password": password
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send().timeout(_timeoutDuration); // Add the timeout

      if (response.statusCode == 200) {
        return jsonDecode(await response.stream.bytesToString());
      } else {
        throw Exception('Failed to login user: ${response.reasonPhrase}');
      }
    } on TimeoutException catch (_) {
      throw Exception('Request timed out. Please try again.');
    }
  }

  Future <Map<String, dynamic>> checkHealth() async {
    try {
      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('GET', Uri.parse('$_baseUrl/health'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send().timeout(_timeoutDuration); // Add the timeout

      if (response.statusCode == 200) {
        return jsonDecode(await response.stream.bytesToString());
      } else {
        throw Exception('Failed to check health: ${response.reasonPhrase}');
      }
    } on TimeoutException catch (_) {
      throw Exception('Request timed out. Please try again.');
    }
  }

}
