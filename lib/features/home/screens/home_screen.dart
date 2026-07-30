import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/product_card.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/category_provider.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/banner_provider.dart';
import '../widgets/top_bar.dart';
import '../widgets/gender_filter_tabs.dart';
import '../widgets/category_chips.dart';
import '../widgets/hero_banner.dart';
import '../widgets/brand_strip.dart';
import '../widgets/promo_grid.dart';
import '../widgets/offer_strip.dart';
import '../../cart/screens/cart_screen.dart';
import '../../product/screens/product_list_screen.dart';
import '../../wishlist/screens/wishlist_screen.dart';
import '../../profile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
      context.read<ProductProvider>().fetchProducts();
      context.read<BannerProvider>().fetchBanners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().count;
    final categoryProvider = context.watch<CategoryProvider>();
    final categories = categoryProvider.filteredCategories;
    final productProvider = context.watch<ProductProvider>();
    final selectedGender = categoryProvider.selectedGender;
    final genderFilteredProducts = productProvider.filterByGender(selectedGender);
    final featuredProducts = genderFilteredProducts.where((p) => p.isFeatured).toList();
    final newArrivals = genderFilteredProducts.where((p) => p.isNew).toList().take(8).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              cartCount: cartCount,
              onSearchSubmit: (query) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListScreen(
                    searchQuery: query,
                    title: 'Search Results',
                  ),
                ),
              ),
              onWishlistTap: () {
                final auth = context.read<AuthProvider>();
                if (!auth.isLoggedIn) {
                  Navigator.pushNamed(context, '/login');
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WishlistScreen()),
                  );
                }
              },
              onCartTap: () {
                final auth = context.read<AuthProvider>();
                if (!auth.isLoggedIn) {
                  Navigator.pushNamed(context, '/login');
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                }
              },
              onNotificationTap: () {},
              onProfileTap: () {
                final auth = context.read<AuthProvider>();
                if (!auth.isLoggedIn) {
                  Navigator.pushNamed(context, '/login');
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                }
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeroBanner(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GenderFilterTabs(
                        selectedGender: selectedGender,
                        onTabChanged: (tab) {
                          context.read<CategoryProvider>().setGender(tab);
                          context.read<ProductProvider>().fetchProducts(gender: tab);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Categories',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/categories'),
                            child: Text(
                              'View All',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.brandGold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CategoryChips(
                      categories: categories,
                      onCategoryTap: (cat) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductListScreen(category: cat),
                        ),
                      ),
                    ),
                    const OfferStrip(),
                    if (featuredProducts.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Iconsax.star1, size: 16, color: AppColors.festiveGold),
                                const SizedBox(width: 6),
                                Text(
                                  'THE DRISTHI EDIT',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.brandGold,
                                    letterSpacing: 2.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Featured Creations',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductListScreen(
                                        title: 'Featured',
                                        initialGender: selectedGender,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'View All',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.brandGold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.58,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: featuredProducts.length > 8 ? 8 : featuredProducts.length,
                              itemBuilder: (context, index) {
                                final product = featuredProducts[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    '/product-detail',
                                    arguments: {
                                      'product_id': product.id,
                                      'title': product.title,
                                      'price': product.price,
                                      'original_price': product.originalPrice,
                                      'image_url': product.imageUrl,
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    const PromoGrid(
                      onBrandDayTap: null,
                      onStylishStealsTap: null,
                      onPlayVideo: null,
                    ),
                    if (newArrivals.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'JUST IN',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.brandGold,
                                letterSpacing: 2.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'New Arrivals',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductListScreen(
                                        title: 'New Arrivals',
                                        initialGender: selectedGender,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Browse Full Catalogue',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.brandGold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.58,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: newArrivals.length,
                              itemBuilder: (context, index) {
                                final product = newArrivals[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    '/product-detail',
                                    arguments: {
                                      'product_id': product.id,
                                      'title': product.title,
                                      'price': product.price,
                                      'original_price': product.originalPrice,
                                      'image_url': product.imageUrl,
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    const BrandStrip(),
                    const SizedBox(height: 32),
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
