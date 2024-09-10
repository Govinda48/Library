import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/model.dart'; // Update the import to your model file

class ApiService {
  final String apiUrl =
      'https://669b3f09276e45187d34eb4e.mockapi.io/api/v1/employee';

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
