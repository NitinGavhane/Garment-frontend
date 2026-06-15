class Address {
  final String id;
  final String fullName;
  final String phone;
  final String street;
  final String city;
  final String state;
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
      pincode: json['pincode'] as String,
      isDefault: json['is_default'] as bool? ?? false,
      type: json['type'] as String? ?? 'Home',
    );
  }
}
