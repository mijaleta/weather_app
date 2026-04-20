import 'package:flutter/material.dart' hide SearchBar;
import '../components/search_bar.dart';
import '../components/current_weather.dart';
import '../components/forecast.dart';
import '../services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? weather;
  List<dynamic>? forecast;
  bool loading = false;
  String error = "";

  final WeatherService _weatherService = WeatherService();

  void searchCity(String city) async {
    setState(() {
      loading = true;
      error = "";
      weather = null;
      forecast = null;
    });

    try {
      final weatherData = await _weatherService.fetchWeather(city);
      final forecastData = await _weatherService.fetchForecast(city);

      setState(() {
        weather = weatherData;
        forecast = forecastData['list'];
        loading = false;
      });
    } catch (err) {
      setState(() {
        error = "City not found";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Weather  ',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SearchBar(onSearch: searchCity),
                const SizedBox(height: 32),
                if (loading)
                  const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Loading weather data...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                if (error.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          error,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Try searching for a valid city name',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                if (weather != null)
                  Column(
                    children: [
                      CurrentWeather(data: weather!),
                      if (forecast != null) Forecast(data: forecast!),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
