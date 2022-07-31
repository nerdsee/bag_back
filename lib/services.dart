import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bag_back/luggage_scan_result.dart';

class Services {
  Future<Response> saveResult(LuggageScanResult result) async {
    final response = await http.get(Uri.parse(
        'http://localhost:3001/bagback/luggage/${result.luggageID}/${result.locationTag}'));

    return Response.fromJson(jsonDecode(response.body));
  }

  static String _ip = "192.168.1.111:3001";

  Future<LuggageScanResult> getLuggage(String baggageID) async {
    final request = 'http://$_ip/bagback/luggage/$baggageID';
    print("getLuggage: $request");

    final response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = LuggageScanResult.fromJson(jsonDecode(response.body));
      print("Converted Result: $result");
      return result;
    } else {
      throw Exception('Failed to load LuggageScan');
    }
  }
}

class Response {
  const Response({this.message = "", this.errorCode = ""});

  final String message;
  final String errorCode;

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      message: json['message'],
      errorCode: json['error_code'],
    );
  }

  @override
  String toString() {
    return "Response: ($errorCode) $message";
  }
}
