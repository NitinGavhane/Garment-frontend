import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// A payment method offered at checkout, as configured in the Admin app.
///
/// Deliberately carries no gateway field: which provider settles the payment is
/// the backend's business, and the buyer is never shown it.
class PaymentMethod {
  final String id;
  final String code;
  final String name;
  final String? description;
  final String? iconUrl;

  const PaymentMethod({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.iconUrl,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
    );
  }

  /// Fallback icon for the well-known codes. A method configured with an
  /// icon_url uses that instead; anything unrecognised gets a neutral wallet,
  /// so a brand-new method added from the Admin app still renders sensibly.
  IconData get fallbackIcon {
    switch (code) {
      case 'upi':
        return Iconsax.mobile;
      case 'card':
        return Iconsax.card;
      case 'netbanking':
        return Iconsax.bank;
      case 'wallet':
        return Iconsax.wallet_3;
      default:
        return Iconsax.wallet;
    }
  }
}
