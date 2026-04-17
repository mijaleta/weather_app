import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final String apiKey = dotenv.env['OPENWEATHER_API_KEY']!;

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'),
    );
    if (response.statusCode != 200) throw Exception('City not found');
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> fetchForecast(String city) async {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric'),
    );
    return json.decode(response.body);
  }
}