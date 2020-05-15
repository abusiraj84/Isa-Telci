import 'dart:convert';
import '../Models/Songs.dart';
import 'package:http/http.dart' show Client;

class ApiService {
  final String baseUrl = "http://192.168.1.116:8000/api/songs";
  Client client = Client();

  Future<Map> getSongs() async {
    final response = await client.get(baseUrl);
    if (response.statusCode == 200) {
      // print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  Future<Map> getAlbums() async {
    final response = await client.get('http://192.168.1.116:8000/api/albums');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  Future<Map> a(int id) async {
    final response =
        await client.get('http://192.168.1.116:8000/api/albums/$id');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
