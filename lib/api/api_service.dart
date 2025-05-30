import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {

  // Example for baseUrl can be:   static const String baseUrl = 'http://172.29.105.191:8080/api';
  // Base url can change depending on the production environment network 
  // Usage of dotenv is safer than hardcoding the environment path
  static const String baseUrl = 'http://your_base_url:8080/api';


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
        throw Exception('Registration Failed');
      }
    } catch (e) {
      throw Exception('Registration Failed: $e');
    }
  }

  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    try {
      var response = await dio.get(
        'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$city?unitGroup=metric&key=${dotenv.env['WEATHER_API_KEY']}&contentType=json',
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
        data: {"email": email, "password": newPassword},
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
        throw Exception('Login Failed');
      }
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  Future<Map<String, dynamic>> updateUser(
      String token, String firstName, String lastName, String email) async {
    try {
      var response = await dio.put(
        '$baseUrl/user/profile',
        data: {"firstName": firstName, "lastName": lastName, "email": email},
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

  Future<Map<String, dynamic>> changePassword(
      String token, String newPassword) async {
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
        throw Exception('Failed to delete account');
      }
    } catch (e) {
      throw Exception('Failed to delete account: $e');
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
        throw Exception('Health Check failed');
      }
    } catch (e) {
      throw Exception('Health check failed: $e');
    }
  }

//   API methods for pig management
  Future<Map<String, dynamic>> addPig(
      String token, String name, double weight, int age, String breed) async {
    try {
      var response = await dio.post(
        '$baseUrl/pigs',
        data: {"name": name, "weight": weight, "age": age, "breed": breed},
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
        throw Exception('Failed to add pig');
      }
    } catch (e) {
      throw Exception('Failed to add pig: $e');
    }
  }

// method to add pig vitals
  Future<Map<String, dynamic>> addVitals(
      String token,
      int pigId,
      double temperature,
      int heartRate,
      int respiratoryRate,
      double weight) async {
    try {
      var response = await dio.post(
        '$baseUrl/pig_vitals',
        data: {
          "pigId": pigId,
          "temperature": temperature,
          "heartRate": heartRate,
          "respiratoryRate": respiratoryRate,
          "weight": weight
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
        throw Exception('Failed to add vitals');
      }
    } catch (e) {
      throw Exception('Failed to add vitals: $e');
    }
  }

// method to get all pigs
  Future<List<dynamic>> getAllPigs(String token) async {
    try {
      var response = await dio.get(
        '$baseUrl/pigs',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get all pigs');
      }
    } catch (e) {
      throw Exception('Failed to get all pigs: $e');
    }
  }

// method to get pig vitals
  Future<List<dynamic>> getPigVitals(String token, int pigId) async {
    try {
      var response = await dio.get(
        '$baseUrl/pig_vitals',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get pig vitals');
      }
    } catch (e) {
      throw Exception('Failed to get pig vitals: $e');
    }
  }

  // method to add ambient variable
  Future<Map<String, dynamic>> addAmbientVariable(
      String token, String name, double threshold) async {
    try {
      var response = await dio.post(
        '$baseUrl/ambient_variables',
        data: {"name": name, "threshold": threshold},
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
        throw Exception('Failed to add ambient variable');
      }
    } catch (e) {
      throw Exception('Failed to add ambient variable: $e');
    }
  }

//   method used to get the list of ambient variables
  Future<List<dynamic>> getAmbientVariables(String token) async {
    try {
      var response = await dio.get(
        '$baseUrl/ambient_variables',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get all ambient variables');
      }
    } catch (e) {
      throw Exception('Failed to get all ambient variables: $e');
    }
  }

// method to identify a disease based on the symptoms
  Future<String> identifyDisease(String token, String symptoms) async {
    try {
      var response = await dio.post(
        '$baseUrl/disease',
        data: {
          "symptoms": symptoms,
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
        throw Exception('Failed to identify disease');
      }
    } catch (e) {
      throw Exception('Failed to identify disease: $e');
    }
  }

//   method to call the openAI api method for prompts: https://api.openai.com/v1/completion
// use the api key stored in .env file in the root of the project (openai_api_key)

  Future<Map<String, dynamic>> openAI(String prompt) async {
    try {
      var response = await dio.post(
        'https://api.openai.com/v1/completions',
        data: {
          "model": "text-davinci-003",
          "prompt": prompt,
          "max_tokens": 100,
          "temperature": 0.5,
          "n": 1,
          "stop": ["\n"]
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Convert the response data to a Map
        return response.data;
      } else {
        throw Exception('Failed to get response from OpenAI');
      }
    } catch (e) {
      throw Exception('Failed to get response from OpenAI: $e');
    }
  }

  Future<String> getPromptGemini(String prompt) async {
    try {
      var response = await dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${dotenv.env['GOOGLE_API_KEY']}',
        data: {
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Convert the response data to a Map
        var data = response.data;
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('Failed to get response from Gemini API');
      }
    } catch (e) {
      throw Exception('Failed to get response from Gemini API: $e');
    }
  }
}
