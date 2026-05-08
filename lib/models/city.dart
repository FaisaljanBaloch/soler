class City {
  final String name;
  final double latitude;
  final double longitude;
  final String? admin1;
  final String? country;

  const City({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.admin1,
    this.country,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      admin1: json['admin1'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'admin1': admin1,
    'country': country,
  };
}
