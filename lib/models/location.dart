class Location {
  const Location({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.admin1,
    this.country,
  });

  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? admin1;
  final String? country;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json['id'] as int,
    name: json['name'] as String,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    admin1: json['admin1'] as String?,
    country: json['country'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    if (admin1 != null) 'admin1': admin1,
    if (country != null) 'country': country,
  };
}
