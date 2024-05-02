import 'package:flutter/foundation.dart';
import 'package:test/test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:dpsd_project2_frontend_iteration_1/api/api_service.dart';
import 'dart:convert';

void main() {
  group('ApiService', () {
    test('registerTestUser', () async {
      final apiService = ApiService();
      final dioAdapter = DioAdapter(dio: apiService.dio);

      // Mock the Dio client
      apiService.dio.httpClientAdapter = dioAdapter;

      dioAdapter.onPost(
        '${ApiService.baseUrl}/register',
        (request) => request.reply(200, jsonEncode({"success": true})),
        // Convert Map to String
        data: {
          "firstName": "new_test",
          "lastName": "new_test13",
          "email": "new_test245d@test",
          "password": "default"
        },
      );

      final response = await apiService.registerTestUser();

      if (kDebugMode) {
        print(" Response: $response");
      }

      expect(response, '{"success":true}');
    });

    // test a defined user: test12, test13, test24d@test, default
    test('registerUserCustom', () async {
      final apiService = ApiService();
      final dioAdapter = DioAdapter(dio: apiService.dio);

      // Mock the Dio client
      apiService.dio.httpClientAdapter = dioAdapter;

      dioAdapter.onPost(
        '${ApiService.baseUrl}/register',
        (request) => request.reply(200, {"success": false}),
        // No need to encode to JSON here
        data: {
          "firstName": "name_2",
          "lastName": "name_2",
          "email": "name_20@gmail.com",
          "password": "name_2"
        },
      );

      final response = await apiService.registerUser(
          'name_2', 'name_2', 'name_20@gmail.com', 'name_2');

      print(" Response: $response");

      expect(response, {"success": true}); // Expect a Map<String, dynamic> here
    });
    test('fetchWeatherData', () async {
      final apiService = ApiService();
      final dioAdapter = DioAdapter(dio: apiService.dio);

      // Mock the Dio client
      apiService.dio.httpClientAdapter = dioAdapter;

      dioAdapter.onGet(
        'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/London?unitGroup=metric&key=LQ892399QVFZUUCELK66XYCSF&contentType=json',
        (request) => request.reply(200, {
          "days": [
            {
              "temp": 15,
              "humidity": 50,
              "precip": 0.5,
              "sunrise": "06:00",
              "sunset": "18:00",
              "windgust": 10,
              "windspeed": 5,
              "winddir": "N"
            }
          ]
        }),
      );

      final response = await apiService.fetchWeatherData('London');

      print(" Response: $response");

      expect(response, {
        'temperature': 15,
        'humidity': 50,
        'precipitation': 0.5,
        'sun': {
          'sunrise': '06:00',
          'sunset': '18:00',
        },
        'wind': {
          'windgust': 10,
          'windspeed': 5,
          'winddir': 'N',
        },
      });
    });

    test('checkHealth', () async {
      final apiService = ApiService();
      final dioAdapter = DioAdapter(dio: apiService.dio);

      // Mock the Dio client
      apiService.dio.httpClientAdapter = dioAdapter;

      dioAdapter.onGet(
        '${ApiService.baseUrl}/health',
        (request) => request.reply(200, {"status": "DOWN"}),
      );

      final response = await apiService.checkHealth();

      expect(response, {"status": "DOWN"});
    });

    test('getAllUsers', () async {
      final apiService = ApiService();
      final dioAdapter = DioAdapter(dio: apiService.dio);

      // Mock the Dio client
      apiService.dio.httpClientAdapter = dioAdapter;

      // Mock list of users
      var mockUsers = [
        {
          "id": 1,
          "firstName": "John",
          "lastName": "Doe",
          "email": "john.doe@gmail.com"
        },
        {
          "id": 2,
          "firstName": "Jane",
          "lastName": "Doe",
          "email": "jane.doe@gmail.com"
        },
        // Add more users as needed
      ];

      dioAdapter.onGet(
        '${ApiService.baseUrl}/users',
        (request) => request.reply(200, {"users": mockUsers}),
      );

      final response = await apiService.getAllUsers();

      print(" Response: $response");

      expect(response, {"users": mockUsers});
    });
  });
}
