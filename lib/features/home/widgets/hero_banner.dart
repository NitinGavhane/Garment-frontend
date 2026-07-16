import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/banner.dart';
import '../../../providers/banner_provider.dart';

/// Home hero slider. Banners are managed from the Admin app and loaded from the
/// database via [BannerProvider]; when none are configured it falls back to the
/// default images so the home screen is never empty.
class HeroBanner extends StatefulWidget {
  const HeroBanner({super.key});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  int _currentPage = 0;
  int _count = 1;
  final _pageController = PageController();
  Timer? _timer;

  static const List<String> _fallbackImages = [
    'https://ucarecdn.com/5b62ef97-a1bb-4cee-9e70-081f5f51d8aa/image.png',
    'https://ucarecdn.com/84f20b01-a248-4830-9748-8a40dfa7575d/image.png',
    'https://ucarecdn.com/5d364a7f-309c-4bd2-a9e5-01c761cf21ee/image.png',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
    // Banners are fetched centrally in HomeScreen; this widget just consumes them.
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients && _count > 1) {
        final next = (_currentPage + 1) % _count;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _openLink(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null || !(uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'))) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final heroBanners = context.watch<BannerProvider>().heroBanners;
    // Use DB banners when available, otherwise the bundled fallbacks.
    final List<BannerItem> items = heroBanners.isNotEmpty
        ? heroBanners
        : _fallbackImages
            .map((u) => BannerItem(id: u, imageUrl: u))
            .toList();
    _count = items.length;
    if (_currentPage >= _count) _currentPage = 0;

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 190,
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (i) => setState(() => _currentPage = i),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () => _openLink(item.linkUrl),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: AppColors.surfaceContainerHighest,
                        child: const Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.onSurfaceVariant,
                          size: 48,
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.surfaceContainerHighest,
                        child: const Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.onSurfaceVariant,
                          size: 48,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.onSurface.withValues(alpha: 0.6),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    if ((item.title ?? '').isNotEmpty || (item.subtitle ?? '').isNotEmpty)
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 28,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if ((item.title ?? '').isNotEmpty)
                              Text(
                                item.title!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.surface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            if ((item.subtitle ?? '').isNotEmpty)
                              Text(
                                item.subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.surface.withValues(alpha: 0.9),
                                  fontSize: 13,
                                ),
                              ),
                          ],
                        ),
                      ),
                    Positioned(
                      bottom: 12,
                      left: 20,
                      child: Row(
                        children: List.generate(
                          items.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: _currentPage == i ? 20 : 6,
                            height: 5,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: _currentPage == i
                                  ? AppColors.surface
                                  : AppColors.surface.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
