import 'package:flutter_test/flutter_test.dart';
import 'package:garment_ecommerce/main.dart';
import 'package:garment_ecommerce/providers/wishlist_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    final wishlistProvider = WishlistProvider();
    await tester.pumpWidget(GarmentEcommerceApp(wishlistProvider: wishlistProvider));
    expect(find.byType(GarmentEcommerceApp), findsOneWidget);
  });
}
