import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:dpsd_project2_frontend_iteration_1/api/api_service.dart'; // Add this line

void main() {
  group('ApiService', () {
    test('registerTestUser', () async {
      final apiService = ApiService();

      // Mock the http client
      apiService.client = MockClient((request) async {
        return http.Response('{"success": true}', 200);
      });

      final response = await apiService.registerTestUser();

      expect(response, '{"success": true}');

    });

    // test a defined user: test12, test13, test24d@test, default
    test('registerUserCustom', () async {
      final apiService = ApiService();

      // Mock the http client
      apiService.client = MockClient((request) async {
        return http.Response('{"success": true}', 200);
      });

      final response = await apiService.registerUser('name_1', 'name_1', 'name_1@gmail.com', 'name_1');

      expect(response, '{"success": true}');

    });


    test('fetchWeatherData', () async {
      final apiService = ApiService();

      // Mock the http client
      apiService.client = MockClient((request) async {
        return http.Response('{"days": [{"temp": 20, "humidity": 50, "precip": 0.5, "sunrise": "06:00", "sunset": "18:00", "windgust": 10, "windspeed": 5, "winddir": "N"}]}', 200);
      });

      final response = await apiService.fetchWeatherData('Nairobi');

      print(" Response: $response");

      expect(response, {
        'temperature': 20,
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



    test('checkHealth',() async {
      final apiService = ApiService();
      apiService.client = MockClient((request) async {
        return http.Response('{"status": "UP"}', 200);
      });

      final response = await apiService.checkHealth();

      expect(response, {"status": "UP"});
    });
  });
}