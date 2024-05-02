import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.71:8080/api';
  // 192.168.1.71
  // 172.29.105.191
  final Dio dio = Dio();

  Future<String> registerTestUser() async {
    try {
      var response = await dio.post(
        '$baseUrl/register',
        data: {
          "firstName": "new_test",
          "lastName": "new_test13",
          "email": "new_test24d@test",
          "password": "default"
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to register test user');
      }
    } catch (e) {
      throw Exception('Failed to register test user: $e');
    }
  }

  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    try {
      var response = await dio.get(
        'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$city?unitGroup=metric&key=LQ892399QVFZUUCELK66XYCSF&contentType=json',
      );

      if (response.statusCode == 200) {
        var data = response.data;
        return {
          'temperature': data['days'][0]['temp'],
          'humidity': data['days'][0]['humidity'],
          'precipitation': data['days'][0]['precip'],
          'sun': {
            'sunrise': data['days'][0]['sunrise'],
            'sunset': data['days'][0]['sunset'],
          },
          'wind': {
            'windgust': data['days'][0]['windgust'],
            'windspeed': data['days'][0]['windspeed'],
            'winddir': data['days'][0]['winddir'],
          },
        };
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<Map<String, dynamic>> registerUser(
      String firstName, String lastName, String email, String password) async {
    try {
      var response = await dio.post(
        '$baseUrl/register',
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": password
        },
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('User registered successfully');
        }
        return response.data;
      } else {
        throw Exception(
            'Failed to register user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      var response = await dio.post(
        '$baseUrl/login',
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to login user');
      }
    } catch (e) {
      throw Exception('Failed to login user: $e');
    }
  }

  // method used to get all users from the database
  Future<Map<String, dynamic>> getAllUsers() async {
    try {
      var response = await dio.get('$baseUrl/users');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get all users');
      }
    } catch (e) {
      throw Exception('Failed to get all users: $e');
    }
  }

  Future<Map<String, dynamic>> checkHealth() async {
    try {
      var response = await dio.get('$baseUrl/health');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to check health');
      }
    } catch (e) {
      throw Exception('Failed to check health: $e');
    }
  }
}

// import 'dart:async';
// import 'dart:convert';
// import 'dart:html';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/src/mock_client.dart';
//
// class ApiService {
//   // static const String _baseUrl = 'http://10.0.2.2:8080/api';
//   static const String _baseUrl = 'http://172.29.105.191:8080/api';
//   static const Duration _timeoutDuration =
//       Duration(seconds: 30); // Increase the timeout duration
//
//   set client(MockClient client) {
//     http.Client();
//   }
//
//   Future<String> registerTestUser() async {
//     var client = http.Client();
//     var headers = {'Content-Type': 'application/json'};
//     var request = http.Request('POST', Uri.parse('$_baseUrl/register'));
//     request.body = json.encode({
//       "firstName": "new_test",
//       "lastName": "new_test13",
//       "email": "new_test24d@test",
//       "password": "default"
//     });
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await client.send(request);
//
//     if (response.statusCode == 200) {
//       return await response.stream.bytesToString();
//     } else {
//       throw Exception('Failed to register test user: ${response.reasonPhrase}');
//     }
//   }
//
//   Future<Map<String, dynamic>> fetchWeatherData(String city) async {
//     var response = await http.get(Uri.parse(
//         'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$city?unitGroup=metric&key=LQ892399QVFZUUCELK66XYCSF&contentType=json'));
//
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       var temperature = data['days'][0]['temp'];
//       var humidity = data['days'][0]['humidity'];
//       var precipitation = data['days'][0]['precip'];
//       var sun = {
//         'sunrise': data['days'][0]['sunrise'],
//         'sunset': data['days'][0]['sunset'],
//       };
//       var wind = {
//         'windgust': data['days'][0]['windgust'],
//         'windspeed': data['days'][0]['windspeed'],
//         'winddir': data['days'][0]['winddir'],
//       };
//       return {
//         'temperature': temperature,
//         'humidity': humidity,
//         'precipitation': precipitation,
//         'sun': sun,
//         'wind': wind,
//       };
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
// Future<Map<String, dynamic>> registerUser(String firstName, String lastName, String email, String password) async {
//   try {
//     var headers = {
//       'Content-Type': 'application/json'
//     };
//     var request = http.Request('POST', Uri.parse('$_baseUrl/register'));
//     request.body = json.encode({
//       "firstName": firstName,
//       "lastName": lastName,
//       "email": email,
//       "password": password
//     });
//     request.headers.addAll(headers);
//     http.StreamedResponse response = await request.send().timeout(_timeoutDuration); // Add the timeout
//     print(response.statusCode);
//     int statusCode = response.statusCode;
//     if (statusCode == 200) {
//       if (kDebugMode) {
//         print('User registered successfully');
//       }
//       return jsonDecode(await response.stream.bytesToString());
//     } else {
//       String reasonPhrase = response.reasonPhrase ?? 'No reason provided by server';
//       throw Exception('Failed to register user. Status code: ${response.statusCode}, Reason: $reasonPhrase');
//     }
//   } on TimeoutException catch (_) {
//     throw Exception('Request timed out. Please try again.');
//   }
// }
//
//   Future<Map<String, dynamic>> loginUser(String email, String password) async {
//     try {
//       var headers = {'Content-Type': 'application/json'};
//       var request = http.Request('POST', Uri.parse('$_baseUrl/login'));
//       request.body = json.encode({"email": email, "password": password});
//       request.headers.addAll(headers);
//
//       http.StreamedResponse response =
//           await request.send().timeout(_timeoutDuration); // Add the timeout
//
//       if (response.statusCode == 200) {
//         return jsonDecode(await response.stream.bytesToString());
//       } else {
//         throw Exception('Failed to login user: ${response.reasonPhrase}');
//       }
//     } on TimeoutException catch (_) {
//       throw Exception('Request timed out. Please try again.');
//     }
//   }
//
//   Future<Map<String, dynamic>> checkHealth() async {
//     try {
//       var headers = {'Content-Type': 'application/json'};
//       var request = http.Request('GET', Uri.parse('$_baseUrl/health'));
//       request.headers.addAll(headers);
//
//       http.StreamedResponse response =
//           await request.send().timeout(_timeoutDuration); // Add the timeout
//
//       if (response.statusCode == 200) {
//         return jsonDecode(await response.stream.bytesToString());
//       } else {
//         throw Exception('Failed to check health: ${response.reasonPhrase}');
//       }
//     } on TimeoutException catch (_) {
//       throw Exception('Request timed out. Please try again.');
//     }
//   }
// }
