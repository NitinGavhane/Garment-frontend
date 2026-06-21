import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/services/api_client.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/product_provider.dart';
import 'providers/category_provider.dart';
import 'providers/location_provider.dart';
import 'providers/order_provider.dart';
import 'providers/address_provider.dart';
import 'routes/app_routes.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.init();
  final wishlistProvider = WishlistProvider();
  await wishlistProvider.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(GarmentEcommerceApp(wishlistProvider: wishlistProvider));
}

class GarmentEcommerceApp extends StatefulWidget {
  final WishlistProvider wishlistProvider;

  const GarmentEcommerceApp({super.key, required this.wishlistProvider});

  @override
  State<GarmentEcommerceApp> createState() => _GarmentEcommerceAppState();
}

class _GarmentEcommerceAppState extends State<GarmentEcommerceApp> {
  String? _pendingProductId;
  String? _pendingRefCode;

  Future<void> _handleDeepLink() async {
    try {
      final initialUri = await _getInitialUri();
      if (initialUri != null) {
        _parseAndNavigate(initialUri);
      }
    } catch (_) {}
  }

  Future<String?> _getInitialUri() async {
    // Returns the initial URI from the app launch
    // On Android/iOS, this comes from the platform channel
    try {
      final platform = MethodChannel('com.garment.ecommerce/deeplink');
      final uri = await platform.invokeMethod<String>('getInitialUri');
      return uri;
    } catch (_) {
      return null;
    }
  }

  void _parseAndNavigate(String uri) {
    final uriParsed = Uri.tryParse(uri);
    if (uriParsed == null) return;
    final segments = uriParsed.pathSegments;
    if (segments.length >= 2 && segments[0] == 'product') {
      final productId = segments[1];
      final refCode = uriParsed.queryParameters['ref'];
      setState(() {
        _pendingProductId = productId;
        _pendingRefCode = refCode;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _handleDeepLink();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuth()),
        ChangeNotifierProvider.value(value: widget.wishlistProvider),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
      ],
      child: MaterialApp(
        title: 'Fashion Store',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: SplashScreen(
          pendingProductId: _pendingProductId,
          pendingRefCode: _pendingRefCode,
        ),
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}

class GarmentEcommerceApp extends StatelessWidget {
  final WishlistProvider wishlistProvider;

  const GarmentEcommerceApp({super.key, required this.wishlistProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuth()),
        ChangeNotifierProvider.value(value: wishlistProvider),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
      ],
      child: MaterialApp(
        title: 'Fashion Store',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
