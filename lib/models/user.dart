class User {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final double walletBalance;
  final String referralCode;
  final bool isVerified;
  final String role;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.walletBalance = 0,
    this.referralCode = '',
    this.isVerified = true,
    this.role = 'customer',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      walletBalance: (json['wallet_balance'] as num?)?.toDouble() ?? 0,
      referralCode: json['referral_code'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
      role: json['role'] as String? ?? 'customer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'wallet_balance': walletBalance,
      'referral_code': referralCode,
      'is_verified': isVerified,
      'role': role,
    };
  }
}
