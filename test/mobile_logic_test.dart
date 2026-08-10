import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:garment_ecommerce/models/cart_item.dart';
import 'package:garment_ecommerce/models/product.dart';
import 'package:garment_ecommerce/providers/cart_provider.dart';
import 'package:garment_ecommerce/providers/wishlist_provider.dart';

Product _p(String id, double price, [double? originalPrice]) => Product(
  id: id,
  title: 'Saree $id',
  description: '',
  brand: 'Dristi',
  category: 'Sarees',
  categoryId: 'cat1',
  price: price,
  originalPrice: originalPrice ?? price,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CartItem/CartProvider pricing logic (offline)', () {
    test('CartItem.totalPrice is price * quantity', () {
      final item = CartItem(
        id: 'i1',
        product: _p('p1', 1000),
        quantity: 3,
        selectedSize: 'M',
        selectedColor: 'Red',
      );
      expect(item.totalPrice, 3000);
    });

    testWidgets('subtotal is sum of line totals', (tester) async {
      final cart = CartProvider();
      await cart.addToCart(product: _p('p1', 1000), quantity: 2, selectedSize: 'M', selectedColor: 'Red');
      await cart.addToCart(product: _p('p2', 499.99), quantity: 1, selectedSize: 'L', selectedColor: 'Blue');
      expect(cart.items.length, 2);
      expect(cart.subtotal, closeTo(2499.99, 0.001));
      expect(cart.count, 2);
      expect(cart.isEmpty, false);
    });

    testWidgets('same product+size+color merges quantity, does not duplicate', (tester) async {
      final cart = CartProvider();
      await cart.addToCart(product: _p('p1', 1000), quantity: 1, selectedSize: 'M', selectedColor: 'Red');
      await cart.addToCart(product: _p('p1', 1000), quantity: 2, selectedSize: 'M', selectedColor: 'Red');
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 3);
      expect(cart.subtotal, 3000);
    });

    testWidgets('different variant stays a separate line', (tester) async {
      final cart = CartProvider();
      await cart.addToCart(product: _p('p1', 1000), quantity: 1, selectedSize: 'M', selectedColor: 'Red');
      await cart.addToCart(product: _p('p1', 1000), quantity: 1, selectedSize: 'XL', selectedColor: 'Red');
      expect(cart.items.length, 2);
    });

    testWidgets('updateQuantity changes quantity, zero removes the line', (tester) async {
      final cart = CartProvider();
      await cart.addToCart(product: _p('p1', 1000), quantity: 2, selectedSize: 'M', selectedColor: 'Red');
      await cart.updateQuantity(0, 1);
      expect(cart.items.first.quantity, 3);
      await cart.updateQuantity(0, -3);
      expect(cart.items.isNotEmpty, false, reason: 'drop to <=0 removes the item');
      expect(cart.isEmpty, true);
    });

    testWidgets('removeItem and clear behave', (tester) async {
      final cart = CartProvider();
      await cart.addToCart(product: _p('p1', 1000), quantity: 1, selectedSize: 'M', selectedColor: 'Red');
      await cart.addToCart(product: _p('p2', 500), quantity: 1, selectedSize: 'L', selectedColor: 'Blue');
      cart.removeItem(0);
      expect(cart.items.length, 1);
      expect(cart.items.first.product.id, 'p2');
      cart.clear();
      expect(cart.isEmpty, true);
      expect(cart.subtotal, 0);
    });
  });

  group('ApiCartItem parsing', () {
    test('fromJson maps snake_case fields and defaults gracefully', () {
      final item = ApiCartItem.fromJson({
        'id': 'ci1',
        'product_id': 'p9',
        'product_title': 'Kurti',
        'variant_id': 'v1',
        'variant_info': 'Size: M, Color: Black',
        'quantity': 4,
        'price': 899.5,
        'image_url': 'http://img/x.jpg',
      });
      expect(item.productId, 'p9');
      expect(item.totalPrice, 3598);
    });

    test('fromJson tolerates missing price', () {
      final item = ApiCartItem.fromJson({'id': 'x', 'product_id': 'y', 'quantity': 2, 'price': null});
      expect(item.totalPrice, 0);
    });

    test('ApiCartResponse rejects nothing / totals', () {
      final resp = ApiCartResponse.fromJson({
        'items': [
          {'id': 'a', 'product_id': 'p1', 'quantity': 2, 'price': 100},
          {'id': 'b', 'product_id': 'p2', 'quantity': 1, 'price': 50},
        ],
        'total': 250.0,
      });
      expect(resp.items.length, 2);
      expect(resp.total, 250.0);
    });
  });

  group('Product pricing helpers', () {
    test('gstPercentage combines CGST + SGST (intra-state total)', () {
      expect(_p('x', 100).gstPercentage, 18.0);
    });

    test('fromApiProduct computes discount percentage from price drop', () {
      final api = ApiProduct.fromJson({
        'id': 'p1',
        'title': 'Saree',
        'price': 1000.0,
        'discount_price': 800.0,
        'category_id': 'c1',
        'description': '',
        'brand': 'D',
        'available_sizes': ['M'],
        'available_colors': ['Red'],
        'cgst_percentage': 9.0,
        'sgst_percentage': 9.0,
        'igst_percentage': 18.0,
      });
      final p = Product.fromApiProduct(api);
      expect(p.discountPercentage, 20);
      expect(p.price, 800);
    });

    test('fromApiProduct with no discount yields 0%', () {
      final api = ApiProduct.fromJson({
        'id': 'p2',
        'title': 'Kurti',
        'price': 500.0,
        'discount_price': null,
        'category_id': 'c1',
        'description': '',
        'brand': 'D',
        'available_sizes': ['M'],
        'available_colors': ['Red'],
        'cgst_percentage': 9.0,
        'sgst_percentage': 9.0,
        'igst_percentage': 18.0,
      });
      expect(Product.fromApiProduct(api).discountPercentage, 0);
    });
  });

  group('WishlistProvider local state (offline)', () {
    testWidgets('init loads persisted wishlist ids from shared preferences', (tester) async {
      SharedPreferences.setMockInitialValues({
        'wishlist_ids': jsonEncode(['p1', 'p2', 'p3']),
      });
      final wl = WishlistProvider();
      await wl.init();
      expect(wl.isLoaded, true);
      expect(wl.count, 3);
      expect(wl.isWishlisted('p1'), true);
      expect(wl.isWishlisted('p9'), false);
    });

    testWidgets('init with empty storage starts empty', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final wl = WishlistProvider();
      await wl.init();
      expect(wl.isLoaded, true);
      expect(wl.count, 0);
    });
  });

  group('Referral link share URL parsing', () {
    test('share link carries product path segment and ref query', () {
      final uri = Uri.parse('https://dristifashions.com/product/p-abc?ref=CODE99');
      expect(uri.pathSegments.contains('product'), true);
      expect(uri.queryParameters['ref'], 'CODE99');
    });
  });
}