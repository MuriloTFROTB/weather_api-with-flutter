class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final int timezone;
  final double feellike;
  final String icon;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.timezone,
    required this.feellike,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      timezone: json['timezone'],
      feellike: json['main']['feels_like'].toDouble(),
      icon: json['weather'][0]['icon']
    );
  }
}
