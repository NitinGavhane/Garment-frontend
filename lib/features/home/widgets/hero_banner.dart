import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';

class HeroBanner extends StatefulWidget {
  const HeroBanner({super.key});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  int _currentPage = 0;
  final _pageController = PageController();
  Timer? _timer;

  final List<String> _images = const [
    'https://ucarecdn.com/5b62ef97-a1bb-4cee-9e70-081f5f51d8aa/image.png',
    'https://ucarecdn.com/84f20b01-a248-4830-9748-8a40dfa7575d/image.png',
    'https://ucarecdn.com/5d364a7f-309c-4bd2-a9e5-01c761cf21ee/image.png',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients) {
        final next = (_currentPage + 1) % _images.length;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 190,
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (i) => setState(() => _currentPage = i),
          itemCount: _images.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: _images[index],
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
                  Positioned(
                    bottom: 12,
                    left: 20,
                    child: Row(
                      children: List.generate(
                        _images.length,
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
            );
          },
        ),
      ),
    );
  }
}
