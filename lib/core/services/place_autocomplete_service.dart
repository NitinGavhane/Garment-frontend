import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceSuggestion {
  final String displayName;
  final String street;
  final String city;
  final String state;
  final String pincode;
  final double lat;
  final double lon;

  const PlaceSuggestion({
    required this.displayName,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    required this.lat,
    required this.lon,
  });
}

class PlaceAutocompleteService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';

  static Future<List<PlaceSuggestion>> suggest(String query) async {
    if (query.trim().length < 3) return [];

    try {
      final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: {
        'q': query.trim(),
        'format': 'json',
        'addressdetails': '1',
        'limit': '5',
        'countrycodes': 'in',
      });

      final response = await http.get(uri, headers: {
        'User-Agent': 'GarmentEcommerceApp/1.0',
      });

      if (response.statusCode != 200) return [];

      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) {
        final addr = item['address'] as Map<String, dynamic>? ?? {};
        final parts = <String>[];
        if (addr['road'] != null) parts.add(addr['road'] as String);
        if (addr['suburb'] != null) parts.add(addr['suburb'] as String);
        if (addr['neighbourhood'] != null) parts.add(addr['neighbourhood'] as String);
        final street = parts.isNotEmpty ? parts.join(', ') : '';

        return PlaceSuggestion(
          displayName: item['display_name'] as String? ?? '',
          street: street,
          city: (addr['city'] ?? addr['town'] ?? addr['village'] ?? '') as String,
          state: (addr['state'] ?? '') as String,
          pincode: (addr['postcode'] ?? '') as String,
          lat: double.parse(item['lat'] as String),
          lon: double.parse(item['lon'] as String),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
