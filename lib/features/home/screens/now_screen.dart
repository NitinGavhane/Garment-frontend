import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/services/product_api_service.dart';
import '../../../models/product.dart';
import '../../product/screens/product_detail_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../profile/screens/profile_screen.dart';

class NowScreen extends StatefulWidget {
  const NowScreen({super.key});

  @override
  State<NowScreen> createState() => _NowScreenState();
}

class _NowScreenState extends State<NowScreen> {
  List<Product> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final rawList = await ProductApiService.listProducts(sort: 'newest');
      final list = rawList.map((json) {
        final api = ApiProductListItem.fromJson(json as Map<String, dynamic>);
        return Product(
          id: api.id,
          title: api.title,
          description: '',
          brand: '',
          category: api.categoryName ?? '',
          categoryId: api.categoryId ?? '',
          price: api.displayPrice,
          originalPrice: api.price,
          discountPercentage: api.discountPrice != null
              ? ((api.price - api.discountPrice!) / api.price * 100).round()
              : 0,
          isFeatured: api.featured,
          stock: api.stock,
          imageUrl: api.primaryImage ?? '',
          gender: api.gender,
        );
      }).toList();
      setState(() {
        _products = list;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.sm),
              color: AppColors.surface,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      ),
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
                        child: Row(
                          children: [
                            Icon(Icons.search, size: AppDimensions.iconSm, color: AppColors.onSurfaceVariant),
                            const SizedBox(width: AppDimensions.sm),
                            Text(
                              'Search trending styles',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  IconButton(
                    icon: const Icon(Icons.person_outline, size: 22),
                    color: AppColors.onSurface,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppDimensions.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trending Now',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.xs),
                          Text(
                            'Fresh styles dropping daily',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.md),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.58,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: _products.length,
                            itemBuilder: (context, index) {
                              final product = _products[index];
                              return ProductCard(
                                product: product,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(product: product),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
