import 'package:flutter/material.dart';
import '../models/category.dart' as models;
import '../core/services/category_api_service.dart';
import '../core/services/api_client.dart';
import '../core/constants/app_colors.dart';

const List<IconData> _categoryIcons = [
  Icons.checkroom,
  Icons.diamond,
  Icons.man,
  Icons.child_care,
  Icons.directions_run,
  Icons.weekend,
  Icons.shopping_bag,
  Icons.fitness_center,
  Icons.star,
  Icons.directions_walk,
  Icons.home,
  Icons.wb_sunny,
  Icons.watch,
];

final List<Color> _categoryColors = [
  AppColors.categoryWomen,
  AppColors.categoryWomen,
  AppColors.categoryMen,
  AppColors.categoryKids,
  AppColors.categoryFootwear,
  AppColors.categoryWomen,
  AppColors.categoryAccessories,
  AppColors.categoryFootwear,
  AppColors.categoryWomen,
  AppColors.categoryFootwear,
  AppColors.categoryHome,
  AppColors.categoryAccessories,
  AppColors.categoryAccessories,
];

class CategoryProvider extends ChangeNotifier {
  List<models.Category> _categories = [];
  bool _isLoading = false;
  String? _error;
  String _selectedGender = 'ALL';

  List<models.Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedGender => _selectedGender;

  void setGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  List<models.Category> get filteredCategories {
    if (_selectedGender == 'ALL') return _categories;
    // A gender tab shows only categories that belong to that gender. "unisex"
    // (and ungendered) categories are not leaked into every tab — they appear
    // under ALL only.
    return _categories
        .where((c) => c.gender.toUpperCase() == _selectedGender)
        .toList();
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      final rawList = await CategoryApiService.listCategories();
      _categories = rawList.asMap().entries.map((entry) {
        final json = entry.value as Map<String, dynamic>;
        final apiCat = models.ApiCategory.fromJson(json);
        final idx = entry.key % _categoryIcons.length;
        return models.Category(
          id: apiCat.id,
          name: apiCat.name,
          icon: _categoryIcons[idx],
          color: _categoryColors[idx],
          imageUrl: apiCat.imageUrl,
          gender: apiCat.gender,
        );
      }).toList();
      _error = null;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load categories';
    }
    _isLoading = false;
    notifyListeners();
  }
}
