import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static const String baseUrl = 'http://172.29.105.191:8080/api';
  // 192.168.1.71 for home network
  // 172.29.105.191 for school
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

Future<bool> resetPassword(String email, String newPassword) async {
  try {
    var response = await dio.put(
      '$baseUrl/user/reset-password',
      data: {
        "email": email,
        "password": newPassword
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to reset password');
    }
  } catch (e) {
    throw Exception('Failed to reset password: $e');
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


Future <Map<String, dynamic>> updateUser(String token, String firstName, String lastName, String email) async {
  try {
    var response = await dio.put(
      '$baseUrl/user/profile',
      data: {
        "firstName": firstName,
        "lastName": lastName,
        "email": email
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to update user');
    }
  } catch (e) {
    throw Exception('Failed to update user: $e');
  }
}

Future<Map<String, dynamic>> changePassword(String token, String newPassword) async {
  try {
    var response = await dio.put(
      '$baseUrl/user/password',
      data: {
        "password": newPassword,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return {'success': true};
    } else {
      throw Exception('Failed to change password');
    }
  } catch (e) {
    return {'error': 'Failed to change password: $e'};
  }
}
Future<bool> deleteUser(String token) async {
  try {
    var response = await dio.delete(
      '$baseUrl/user/profile',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete user');
    }
  } catch (e) {
    throw Exception('Failed to delete user: $e');
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
