import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../models/cart_item.dart';
import '../../../providers/cart_provider.dart';
import '../../checkout/screens/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;
    final subtotal = cart.subtotal;
    final shipping = subtotal > 100 ? 0 : 9.99;
    final total = subtotal + shipping;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cart (${cart.count})',
          style: AppTextStyles.title,
        ),
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.shopping_bag,
                      size: 80, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add items to get started',
                    style: AppTextStyles.subtitle,
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppDimensions.md),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _CartItemCard(
                        item: item,
                        onIncrement: () =>
                            context.read<CartProvider>().updateQuantity(index, 1),
                        onDecrement: () =>
                            context.read<CartProvider>().updateQuantity(index, -1),
                        onRemove: () =>
                            context.read<CartProvider>().removeItem(index),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal',
                                style: AppTextStyles.body),
                            Text('₹${subtotal.toStringAsFixed(2)}',
                                style: AppTextStyles.subtitle),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Shipping',
                                style: AppTextStyles.bodySmall),
                            Text(
                              shipping == 0
                                  ? 'FREE'
                                  : '₹${shipping.toStringAsFixed(2)}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: shipping == 0
                                    ? AppColors.success
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: AppTextStyles.title,
                            ),
                            Text(
                              '₹${total.toStringAsFixed(2)}',
                              style: AppTextStyles.headline3.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.md),
                        AppButton(
                          label: 'Checkout • ₹${total.toStringAsFixed(2)}',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CheckoutScreen(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.white),
      ),
      onDismissed: (_) => onRemove(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: item.product.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(
                Icons.checkroom_rounded,
                size: 36,
                color: AppColors.white.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.selectedColor} • ${item.selectedSize}',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${item.product.price.toStringAsFixed(2)}',
                    style: AppTextStyles.priceSmall,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: onRemove,
                  child: const Icon(Iconsax.trash,
                      size: 18, color: AppColors.textHint),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _qtyButton(Iconsax.minus, onDecrement),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.quantity}',
                          style: AppTextStyles.subtitle.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _qtyButton(Iconsax.add, onIncrement),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: AppColors.textPrimary),
      ),
    );
  }
}
