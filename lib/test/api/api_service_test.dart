import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:dpsd_project2_frontend_iteration_1/api/api_service.dart'; // Add this line

void main() {
  group('ApiService', () {
    test('registerUser', () async {
      final apiService = ApiService();

      // Mock the http client
      apiService.client = MockClient((request) async {
        return http.Response('{"success": true}', 200);
      });

      final response = await apiService.registerUser('John', 'Doe', 'john.doe@example.com', 'password123');

      expect(response['success'], true);
    });
  });
}