import 'package:flutter/foundation.dart';
import 'package:test/test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:dpsd_project2_frontend_iteration_1/api/api_service.dart';
import 'dart:convert';

void main() {
  group('ApiService', ()
  {
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
            (request) =>
            request.reply(200, {
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
    test('loginUser', () async {
      final apiService = ApiService();
      final dioAdapter = DioAdapter(dio: apiService.dio);

      // Mock the Dio client
      apiService.dio.httpClientAdapter = dioAdapter;

      dioAdapter.onPost(
        '${ApiService.baseUrl}/login',
            (request) => request.reply(200, {"success": true}),
        data: {"email": "fg@gmail.com", "password": "fg"},
      );
    });

test('updateUser', () async {
  final apiService = ApiService();
  final dioAdapter = DioAdapter(dio: apiService.dio);

  // Mock the Dio client
  apiService.dio.httpClientAdapter = dioAdapter;

  // Mock token
  const token = 'mock_token';

  dioAdapter.onPut(
    '${ApiService.baseUrl}/users',
    (request) => request.reply(200, {"success": true}),
    data: {
      "firstName": "new_test",
      "lastName": "new_test13",
      "email": "new_test245d@test"
    },
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  final response = await apiService.updateUser(
      token, 'new_test', 'new_test13', 'new_test245d@test');

  print(" Response: $response");

  expect(response, {"success": true});
});

test('deleteUser', () async {
  final apiService = ApiService();
  final dioAdapter = DioAdapter(dio: apiService.dio);

  // Mock the Dio client
  apiService.dio.httpClientAdapter = dioAdapter;

  // Mock token
  const token = 'mock_token';

  dioAdapter.onDelete(
    '${ApiService.baseUrl}/user/profile',
    (request) => request.reply(200, {}),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  final success = await apiService.deleteUser(token);

  print(" Success: $success");

  expect(success, true);
});

test('addPig', () async {
  final apiService = ApiService();
  final dioAdapter = DioAdapter(dio: apiService.dio);

  apiService.dio.httpClientAdapter = dioAdapter;

  dioAdapter.onPost(
    '${ApiService.baseUrl}/pigs',
    (request) => request.reply(200, {"success": true}),
    data: {"name": "test", "weight": 30.0, "age": 2, "breed": "test breed"},
    headers: {
      'Authorization': 'Bearer mock_token',
      'Content-Type': 'application/json',
    },
  );

  final response = await apiService.addPig(
      'mock_token', 'test', 30.0, 2, 'test breed');

  expect(response, {"success": true});
});

test('addVitals', () async {
  final apiService = ApiService();
  final dioAdapter = DioAdapter(dio: apiService.dio);

  apiService.dio.httpClientAdapter = dioAdapter;

  dioAdapter.onPost(
    '${ApiService.baseUrl}/pig_vitals',
    (request) => request.reply(200, {"success": true}),
    data: {
      "pigId": 1,
      "temperature": 37.0,
      "heartRate": 80,
      "respiratoryRate": 20,
      "weight": 30.0
    },
    headers: {
      'Authorization': 'Bearer mock_token',
      'Content-Type': 'application/json',
    },
  );

  final response = await apiService.addVitals(
      'mock_token', 1, 37.0, 80, 20, 30.0);

  expect(response, {"success": true});
});

test('getAllPigs', () async {
  final apiService = ApiService();
  final dioAdapter = DioAdapter(dio: apiService.dio);

  apiService.dio.httpClientAdapter = dioAdapter;

  var mockPigs = [
    {
      "id": 1,
      "name": "test",
      "weight": 30.0,
      "age": 2,
      "breed": "test breed"
    },
    // Add more pigs as needed
  ];

  dioAdapter.onGet(
    '${ApiService.baseUrl}/pigs',
    (request) => request.reply(200, mockPigs),
    headers: {
      'Authorization': 'Bearer mock_token',
    },
  );

  final response = await apiService.getAllPigs('mock_token');

  expect(response, mockPigs);
});

test('getPigVitals', () async {
  final apiService = ApiService();
  final dioAdapter = DioAdapter(dio: apiService.dio);

  apiService.dio.httpClientAdapter = dioAdapter;

  var mockVitals = [
    {
      "pigId": 1,
      "temperature": 37.0,
      "heartRate": 80,
      "respiratoryRate": 20,
      "weight": 30.0
    },
    // Add more vitals as needed
  ];

  dioAdapter.onGet(
    '${ApiService.baseUrl}/pig_vitals',
    (request) => request.reply(200, mockVitals),
    headers: {
      'Authorization': 'Bearer mock_token',
    },
  );

  final response = await apiService.getPigVitals('mock_token', 1);

  expect(response, mockVitals);
});

test('addAmbientVariable', () async {
  final apiService = ApiService();
  final dioAdapter = DioAdapter(dio: apiService.dio);

  apiService.dio.httpClientAdapter = dioAdapter;

  dioAdapter.onPost(
    '${ApiService.baseUrl}/ambient_variables',
    (request) => request.reply(200, {"success": true}),
    data: {"name": "test", "treshold": 30.0},
    headers: {
      'Authorization': 'Bearer mock_token',
      'Content-Type': 'application/json',
    },
  );

  final response = await apiService.addAmbientVariable(
      'mock_token', 'test', 30.0);

  expect(response, {"success": true});
});

test('getAmbientVariables', () async {
  final apiService = ApiService();
  final dioAdapter = DioAdapter(dio: apiService.dio);

  apiService.dio.httpClientAdapter = dioAdapter;

  var mockVariables = [
    {
      "id": 1,
      "name": "test",
      "treshold": 30.0
    },
    // Add more variables as needed
  ];

  dioAdapter.onGet(
    '${ApiService.baseUrl}/ambient_variables',
    (request) => request.reply(200, mockVariables),
    headers: {
      'Authorization': 'Bearer mock_token',
    },
  );

  final response = await apiService.getAmbientVariables('mock_token');

  expect(response, mockVariables);
});

test('identifyDisease', () async {
  final apiService = ApiService();
  final dioAdapter = DioAdapter(dio: apiService.dio);

  apiService.dio.httpClientAdapter = dioAdapter;

  dioAdapter.onPost(
    '${ApiService.baseUrl}/disease',
    (request) => request.reply(200, "test disease"),
    data: {"symptoms": "test symptoms"},
    headers: {
      'Authorization': 'Bearer mock_token',
      'Content-Type': 'application/json',
    },
  );

  final response = await apiService.identifyDisease(
      'mock_token', 'test symptoms');

  expect(response, "test disease");
});

  });
}