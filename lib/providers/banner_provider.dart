import 'package:flutter/foundation.dart';
import '../core/services/home_api_service.dart';
import '../models/banner.dart';

/// Loads the sliding hero banners managed from the Admin app and stored in the
/// database. Fetched from `GET /api/v1/home` (the `banners` array); the User
/// app never bundles banner images.
class BannerProvider extends ChangeNotifier {
  List<BannerItem> _banners = [];
  bool _isLoading = false;
  String? _error;

  List<BannerItem> get banners => _banners;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Banners for a given page section (defaults to the hero slider), ordered.
  List<BannerItem> section(String section) {
    final list = _banners.where((b) => b.section == section).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return list;
  }

  List<BannerItem> get heroBanners => section('hero');

  Future<void> fetchBanners() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await HomeApiService.getHomeContent();
      final raw = (data['banners'] as List<dynamic>?) ?? [];
      _banners = raw
          .map((e) => BannerItem.fromJson(e as Map<String, dynamic>))
          .where((b) => b.imageUrl.isNotEmpty)
          .toList();
      _error = null;
    } catch (e) {
      _error = 'Failed to load banners';
      // Leave any previously loaded banners in place; the UI falls back to the
      // default hero when the list is empty.
    }
    _isLoading = false;
    notifyListeners();
  }
}
