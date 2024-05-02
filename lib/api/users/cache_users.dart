import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../api_service.dart';

class CacheUsers {
  late final Dio dio;
  final _apiService = ApiService();

  Future<void> cacheAllUsers() async {
    // Step 1: Call the getAllUsers method and get the response.
    final List<Map<String, dynamic>> response = (await _apiService.getAllUsers()) as List<Map<String, dynamic>>;

    if (kDebugMode) {
      print('Users: $response');
    }

    // Step 2: Get the application's document directory.
    final directory = await getApplicationDocumentsDirectory();

    // Step 3: Create a new file in this directory to store the cached data.
    final file = File('${directory.path}/cached_users.json');

    // Step 4: Read the existing cached users.
    List<Map<String, dynamic>> cachedUsers = [];
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      cachedUsers = jsonDecode(jsonString);
    }

    // Step 5: Compare the new users with the cached users and append any new users.
    for (var user in response) {
      if (!cachedUsers.contains(user)) {
        cachedUsers.add(user);
      }
    }

    // Step 6: Convert the updated user list to a JSON string.
    final jsonString = jsonEncode(cachedUsers);

    // Step 7: Write the JSON string to the file.
    await file.writeAsString(jsonString);
  }

  Future<List<Map<String, dynamic>>> getCachedUsers() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/cached_users.json');

    if (await file.exists()) {
      final jsonString = await file.readAsString();
      return jsonDecode(jsonString);
    } else {
      throw Exception('No cached users found');
    }
  }

  Future<Directory> getApplicationDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }
}