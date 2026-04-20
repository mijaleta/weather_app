import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CurrentWeather extends StatelessWidget {
  final Map<String, dynamic> data;

  const CurrentWeather({super.key, required this.data});
// here i can do here 
  @override
  Widget build(BuildContext context) {
    final tempCelsius = (data['main']['temp'] as num).round();
    final feelsLike = (data['main']['feels_like'] as num).round();
    final weatherIcon = 'https://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png';
    final cityName = data['name'];
    final description = data['weather'][0]['description'];
    final humidity = data['main']['humidity'];
    final windSpeed = data['wind']['speed'];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        ),
      child: Column(
        children: [
          Text(
            cityName,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          CachedNetworkImage(
            imageUrl: weatherIcon,
            width: 96,
            height: 96,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Text(
            '$tempCelsius°C',
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Feels like',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$feelsLike°C',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Humidity',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$humidity%',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Wind Speed',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$windSpeed m/s',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}