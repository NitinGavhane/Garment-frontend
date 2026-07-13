import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/product_grid_section.dart';
import '../../../core/widgets/animations.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/category_provider.dart';
import '../../../providers/product_provider.dart';
import '../widgets/top_bar.dart';
import '../widgets/gender_filter_tabs.dart';
import '../widgets/category_chips.dart';
import '../widgets/hero_banner.dart';
import '../widgets/brand_strip.dart';
import '../widgets/promo_grid.dart';
import '../widgets/banner_section.dart';
import '../widgets/blog_section.dart';
import '../widgets/web_home_view.dart';
import '../widgets/web/web_chrome.dart';
import '../../../models/product.dart';
import '../../../models/category.dart';
import '../../cart/screens/cart_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../product/screens/product_list_screen.dart';
import '../../wishlist/screens/wishlist_screen.dart';
import '../../profile/screens/address_list_screen.dart';
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

    // Wide viewports (the website on desktop) get the premium landing layout.
    // Narrow viewports (the mobile app) fall through to the unchanged layout
    // below. 900px catches desktop browsers and mobile "Desktop site" mode
    // (~980px) while keeping phones (portrait & landscape) on the app layout.
    if (MediaQuery.of(context).size.width >= 900) {
      return _buildWeb(
        context,
        cartCount: cartCount,
        selectedGender: selectedGender,
        featuredProducts: featuredProducts,
        allProducts: genderFilteredProducts,
        categories: categories,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            TopBar(
              cartCount: cartCount,
              onSearchTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
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
              onAddressTap: () {
                final auth = context.read<AuthProvider>();
                if (!auth.isLoggedIn) {
                  Navigator.pushNamed(context, '/login');
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddressListScreen(),
                    ),
                  );
                }
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GenderFilterTabs(
                      selectedGender: selectedGender,
                      onTabChanged: (tab) {
                        context.read<CategoryProvider>().setGender(tab);
                        context.read<ProductProvider>().fetchProducts(gender: tab);
                      },
                    ),
                    RevealSection(
                      delayMs: 100,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Categories',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurface)),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, '/categories'),
                                  child: Text('See All',
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.tertiary)),
                                ),
                              ],
                            ),
                          ),
                          CategoryChips(
                            categories: categories,
                            onCategoryTap: (cat) => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductListScreen(category: cat),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const RevealSection(
                      delayMs: 200,
                      child: HeroBanner(),
                    ),
                    const RevealSection(
                      delayMs: 300,
                      child: BrandStrip(),
                    ),
                    RevealSection(
                      delayMs: 400,
                      child: PromoGrid(
                        onBrandDayTap: null,
                        onStylishStealsTap: null,
                        onPlayVideo: () async {
                          final uri = Uri.parse('https://youtu.be/gbLmku5QACM?si=8UjZX1sLXiRzuEig');
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                      ),
                    ),
                    const RevealSection(
                      delayMs: 500,
                      child: BannerSection(
                        title: 'SPONSORED PRODUCTS',
                      ),
                    ),
                    const RevealSection(
                      delayMs: 600,
                      child: BannerSection(
                        title: 'TOP CATEGORIES',
                      ),
                    ),
                    const RevealSection(
                      delayMs: 700,
                      child: BannerSection(
                        title: 'BRANDS IN FOCUS',
                      ),
                    ),
                    const RevealSection(
                      delayMs: 800,
                      child: BannerSection(
                        title: 'BRAND TO EXPLORE',
                      ),
                    ),
                    const RevealSection(
                      delayMs: 900,
                      child: BlogSection(),
                    ),
                    RevealSection(
                      delayMs: 1000,
                      child: ProductGridSection(
                        title: 'Featured Products',
                        subtitle: 'Handpicked just for you',
                        products: featuredProducts,
                        onViewAll: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductListScreen(
                              title: 'Featured',
                              initialGender: selectedGender,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (genderFilteredProducts.isNotEmpty)
                      RevealSection(
                        delayMs: 1100,
                        child: ProductGridSection(
                          title: selectedGender == 'ALL' ? 'ALL PRODUCTS' : '$selectedGender PRODUCTS',
                          products: genderFilteredProducts,
                        ),
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

  // ─── Website (desktop) layout ──────────────────────────────────────────────
  //
  // All website navigation, cart and wishlist actions route through [WebNav]
  // so the destination pages (Shop, Product Detail, Collections, About/Contact)
  // share one consistent design system and behaviour.

  Widget _buildWeb(
    BuildContext context, {
    required int cartCount,
    required String selectedGender,
    required List<Product> featuredProducts,
    required List<Product> allProducts,
    required List<Category> categories,
  }) {
    return WebHomeView(
      cartCount: cartCount,
      products: allProducts,
      categories: categories,
      onCategoryOpen: (cat) =>
          WebNav.goShop(context, title: cat.name, initialCategoryId: cat.id),
      onSearchTap: () => WebNav.goSearch(context),
      onWishlistTap: () => WebNav.goWishlist(context),
      onCartTap: () => WebNav.goCart(context),
      onProfileTap: () => WebNav.goProfile(context),
      onShopNow: () => WebNav.goShop(context, initialGender: selectedGender),
      onExplore: () => WebNav.goCollections(context),
      onCategoryTap: (label) => WebNav.goShopByCategoryLabel(context, label),
      onNavTap: (label) => WebNav.handleNav(context, label),
      onProductTap: (p) => WebNav.goProduct(context, p),
      onAddToBag: (p) => WebNav.addToBag(context, p),
      onWishlistProduct: (p) => WebNav.toggleWishlist(context, p),
    );
  }
}
