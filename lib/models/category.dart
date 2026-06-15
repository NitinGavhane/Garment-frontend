import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int productCount;
  final String? imageUrl;
  final String gender;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.productCount = 0,
    this.imageUrl,
    this.gender = '',
  });
}

class ApiCategory {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? imageUrl;
  final String gender;
  final bool isActive;
  final DateTime createdAt;

  const ApiCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.imageUrl,
    this.gender = '',
    this.isActive = true,
    required this.createdAt,
  });

  factory ApiCategory.fromJson(Map<String, dynamic> json) {
    return ApiCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      gender: json['gender'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
