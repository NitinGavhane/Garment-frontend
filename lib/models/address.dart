class Address {
  final String id;
  final String fullName;
  final String phone;
  final String street;
  final String city;
  final String state;
  /// ISO-3166-1 alpha-2. Decides which payment methods checkout offers.
  final String country;
  final String pincode;
  final bool isDefault;
  final String type;

  const Address({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    this.country = 'IN',
    required this.pincode,
    this.isDefault = false,
    this.type = 'Home',
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: (json['country'] as String?) ?? 'IN',
      pincode: json['pincode'] as String,
      isDefault: json['is_default'] as bool? ?? false,
      type: json['type'] as String? ?? 'Home',
    );
  }

  /// The one-line shipping string the orders endpoint stores. Mirrors the web
  /// storefront's `formatAddressLine` so the backend can parse it back into
  /// the billing fields ShipRocket needs (name, phone, street, city, state,
  /// pincode, country).
  @override
  String toString() => [
        fullName,
        phone,
        street,
        city,
        state,
        pincode,
        country,
      ]
          .where((e) => e.trim().isNotEmpty)
          .join(', ');
}
