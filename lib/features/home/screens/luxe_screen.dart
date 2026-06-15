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

class LuxeScreen extends StatefulWidget {
  const LuxeScreen({super.key});

  @override
  State<LuxeScreen> createState() => _LuxeScreenState();
}

class _LuxeScreenState extends State<LuxeScreen> {
  List<Product> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final rawList = await ProductApiService.listProducts();
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
      list.sort((a, b) => b.price.compareTo(a.price));
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
      backgroundColor: AppColors.inverseSurface,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.sm),
              color: AppColors.inverseSurface,
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
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
                        child: Row(
                          children: [
                            Icon(Icons.search, size: AppDimensions.iconSm, color: Colors.white.withValues(alpha: 0.5)),
                            const SizedBox(width: AppDimensions.sm),
                            Text(
                              'Search luxury',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  IconButton(
                    icon: const Icon(Icons.person_outline, size: 22, color: Colors.white70),
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
                  ? const Center(child: CircularProgressIndicator(color: Colors.white54))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppDimensions.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Luxe Edit',
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.xs),
                          Text(
                            'Premium selections for the discerning',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.4),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.md + 4),
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
