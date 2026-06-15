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
