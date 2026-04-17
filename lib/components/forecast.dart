import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Forecast extends StatelessWidget {
  final List<dynamic> data;

  const Forecast({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Get one forecast per day (every 8th item = 24 hours)
    final dailyForecast = data
        .asMap()
        .entries
        .where((entry) => entry.key % 8 == 0)
        .map((entry) => entry.value)
        .take(3)
        .toList();

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            '3-Day Forecast',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // Desktop/tablet: row layout with wider cards
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: dailyForecast.asMap().entries.map((entry) {
                    return SizedBox(
                      width: 180,  // Increased card width
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _buildForecastCard(entry.value, entry.key),
                      ),
                    );
                  }).toList(),
                );
              } else {
                // Mobile: column layout
                return Column(
                  children: dailyForecast.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SizedBox(
                        width: 280,  // Wider cards on mobile
                        child: _buildForecastCard(entry.value, entry.key),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildForecastCard(dynamic day, int index) {
    final date = DateTime.parse(day['dt_txt']);
    final dayName = _getDayName(date);
    final tempMax = (day['main']['temp_max'] as num).round();
    final tempMin = (day['main']['temp_min'] as num).round();
    final weatherIcon = day['weather'][0]['icon'];
    final weatherMain = day['weather'][0]['main'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dayName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          CachedNetworkImage(
            imageUrl: 'https://openweathermap.org/img/wn/$weatherIcon.png',
            width: 64,
            height: 64,
            placeholder: (context, url) => const SizedBox(
              width: 64,
              height: 64,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(height: 8),
          Text(
            '${tempMax}°',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            '${tempMin}°',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            weatherMain,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getDayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}