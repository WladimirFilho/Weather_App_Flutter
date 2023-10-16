import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_models.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
// api key
  final _weatherService = WeatherService('919bd8f7ec64be9346402fff0316d9cc');
  Weather? _weather;

// fetch weather
  _fetchWeather() async {
    // get the current weather
    String cityName = await _weatherService.getCurrentCity();

    // get the weather for the city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

// weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sunny.json'; // deafult animatio
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/clear.json';
      default:
        return 'assets/sunny.json';
    }
  }

// initial state
  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 37, 36, 36),
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.pin_drop,
                        size: 50,
                        color: Color.fromARGB(255, 91, 91, 91),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        _weather?.cityName ?? "Loading city...",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 174, 174, 174),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: // animation
                      Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                          getWeatherAnimation(_weather?.mainConditions)),
                      // weather condition
                      // Text(_weather?.mainConditions ?? ''),
                    ],
                  ),
                ),
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // weather temperature
                      Text(
                        '${_weather?.temperature.round()}°',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 174, 174, 174),
                          fontSize: 50,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
