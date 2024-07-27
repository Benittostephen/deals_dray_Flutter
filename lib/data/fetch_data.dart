import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/api.dart';

Future<ApiResponse> fetchHomeData() async {
  final response = await http.get(Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    return ApiResponse.fromJson(jsonData);
  } else {
    throw Exception('Failed to load data');
  }
}

