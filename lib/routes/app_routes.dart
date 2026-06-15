import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/widgets/animations.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/home/screens/now_screen.dart';
import '../features/home/screens/luxe_screen.dart';
import '../features/cart/screens/cart_screen.dart';
import '../features/orders/screens/order_list_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/wishlist/screens/wishlist_screen.dart';
import '../features/search/screens/search_screen.dart';
import '../features/product/screens/product_list_screen.dart';
import '../features/categories/screens/categories_screen.dart';
import '../providers/cart_provider.dart';

class AppRoutes {
  static const String login = '/login';
  static const String main = '/main';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String wishlist = '/wishlist';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String categories = '/categories';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return SlideFadeRoute(page: const LoginScreen());
      case cart:
        return SlideFadeRoute(page: const CartScreen());
      case orders:
        return SlideFadeRoute(page: const OrderListScreen());
      case wishlist:
        return SlideFadeRoute(page: const WishlistScreen());
      case search:
        return SlideFadeRoute(page: const SearchScreen());
      case categories:
        return SlideFadeRoute(page: const CategoriesScreen());
      case main:
        return SlideFadeRoute(page: const MainShell());
      default:
        return SlideFadeRoute(page: const MainShell());
    }
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  DateTime? _lastBackPress;

  final _screens = [
    const HomeScreen(),
    const ProductListScreen(maxPrice: 999.0, title: 'Under 999'),
    const NowScreen(),
    const LuxeScreen(),
    const CartScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().count;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final now = DateTime.now();
        if (_lastBackPress == null ||
            now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
          _lastBackPress = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Press back again to exit')),
          );
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: child,
        ),
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: AnimatedTabBar(
        tabs: [
          const AnimatedTabData(icon: Icons.home, label: 'Home'),
          const AnimatedTabData(icon: Icons.sell_outlined, label: 'Under 999'),
          const AnimatedTabData(icon: Icons.bolt, label: 'Now'),
          const AnimatedTabData(icon: Icons.diamond_outlined, label: 'Luxe'),
          AnimatedTabData(
            icon: Icons.shopping_cart_outlined,
            label: 'Bag',
            badgeCount: cartCount,
          ),
        ],
        selectedIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
      ),
    );
  }
}
