import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService(
    '7188ba294c7106d2e12b8f8d1437e033',
  );

  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather('Maringa');
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    if (_weather == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(
            16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _cityName(),
              SizedBox(
                height: 30,
              ),
              _cardWeather(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cityName() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      padding: EdgeInsets.all(12),
      child: Text(
        _weather!.cityName,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _cardWeather() {
    return Container(
        padding: const EdgeInsets.all(
          16,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              30,
            ),
            gradient: const LinearGradient(
              colors: [
                Colors.purple,
                Colors.blue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(5, 6))
            ]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _iconWeather(),
                    _weatherCondition(),
                    _weatherLocaTime(),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _weatherTemperature(),
                        const SizedBox(
                          height: 30,
                        ),
                        IconButton(
                          onPressed: () {
                            _fetchWeather();
                          },
                          icon: const Icon(
                            Icons.restart_alt_outlined,
                            color: Colors.white,
                            size: 40,
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ));
  }

  Widget _weatherTemperature() {
    return Column(
      children: [
        Container(
          height: 90,
          child: Text(
            " ${_weather?.temperature.round()}°",
            style: const TextStyle(
              fontSize: 80,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          'Feels like ${_weather?.feellike.toStringAsFixed(0)}  °',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _weatherLocaTime() {
    DateTime nowUtc = DateTime.now().toUtc();

    int timezoneOffset = _weather?.timezone ?? 0;

    DateTime localTime = nowUtc.add(
      Duration(
        seconds: timezoneOffset,
      ),
    );

    return Text(
      ("${DateFormat('EEEE').format(localTime)}, ${DateFormat('d MMM').format(localTime)}"),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _weatherCondition() {
    return Text(
      _weather?.mainCondition ?? '',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _iconWeather() {
    String getWeatherAnimation(String mainCondition) {
      if (mainCondition == null) {
        return 'assets/sun.json';
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
          return 'assets/sun.json';
        default:
          return 'assets/sun.json';
      }
    }

    return Container(
      height: 150,
      width: 150,
      child: Lottie.asset(
        getWeatherAnimation(_weather!.mainCondition),
      ),
    );
  }
}
