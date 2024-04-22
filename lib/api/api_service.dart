import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/src/mock_client.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:8080/api';

  set client(MockClient client) {
    http.Client();
  }

  Future<Map<String, dynamic>> registerUser(String firstName, String lastName, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register user');
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('$_baseUrl/login'));
    request.body = json.encode({
      "email": email,
      "password": password
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    } else {
      throw Exception('Failed to login user: ${response.reasonPhrase}');
    }
  }
}


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:http/src/mock_client.dart';
//
// class ApiService {
//   static const String _baseUrl = 'http://10.0.2.2:8080/api';
//
//   set client(MockClient client) {
//     http.Client();
//   }
//
//   Future<Map<String, dynamic>> registerUser(String firstName, String lastName, String email, String password) async {
//     final response = await http.post(
//       Uri.parse('$_baseUrl/register'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'firstName': firstName,
//         'lastName': lastName,
//         'email': email,
//         'password': password,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to register user');
//     }
//   }
//
//   Future<Map<String, dynamic>> loginUser(String email, String password) async {
//     final response = await http.post(
//       Uri.parse('$_baseUrl/login'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'email': email,
//         'password': password,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to login user');
//     }
//   }
// }