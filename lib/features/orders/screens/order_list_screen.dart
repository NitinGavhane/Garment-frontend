import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/order.dart';
import '../../../models/product.dart';
import '../../../models/address.dart';
import '../../../providers/order_provider.dart';
import '../widgets/order_card.dart';
import 'order_detail_screen.dart';
import 'order_return_replace_sheet.dart';
import '../models/order_return_replace_request.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchOrders();
    });
  }

  List<Order> get _orders {
    final providerOrders = context.read<OrderProvider>().orders;
    final converted = providerOrders.map((api) => Order(
      id: api.id,
      orderNumber: api.orderNumber,
      items: api.items.map((i) => OrderItem(
        id: i.id,
        product: Product(
          id: i.productId,
          title: i.productName,
          description: '',
          brand: '',
          category: '',
          categoryId: '',
          price: i.price,
          originalPrice: i.price,
          imageUrl: '',
        ),
        quantity: i.quantity,
        price: i.price,
        size: '',
        color: '',
      )).toList(),
      subtotal: api.subtotal,
      shipping: 0,
      discount: api.discountAmount,
      gst: api.gstAmount,
      total: api.finalAmount,
      status: _parseOrderStatus(api.orderStatus),
      address: const Address(id: '', fullName: '', phone: '', street: '', city: '', state: '', pincode: ''),
      paymentMethod: api.paymentStatus,
      createdAt: api.createdAt,
      estimatedDelivery: api.estimatedDelivery ?? api.createdAt,
    )).toList();

    if (_selectedFilter == 'All') return converted;
    final status = _parseStatus(_selectedFilter);
    return converted.where((o) => o.status == status).toList();
  }

  OrderStatus _parseOrderStatus(String status) {
    switch (status.toLowerCase()) {
      case 'placed': return OrderStatus.placed;
      case 'confirmed': return OrderStatus.confirmed;
      case 'processing': return OrderStatus.processing;
      case 'dispatched': return OrderStatus.dispatched;
      case 'out_for_delivery': return OrderStatus.outForDelivery;
      case 'delivered': return OrderStatus.delivered;
      case 'cancelled': return OrderStatus.cancelled;
      default: return OrderStatus.processing;
    }
  }

  void _showReturnReplaceSheet(
      BuildContext context, Order order, ReturnReplaceType type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: OrderReturnReplaceSheet(order: order, type: type),
      ),
    );
  }

  OrderStatus? _parseStatus(String filter) {
    switch (filter) {
      case 'Active':
        return OrderStatus.processing;
      case 'Shipped':
        return OrderStatus.dispatched;
      case 'Delivered':
        return OrderStatus.delivered;
      case 'Cancelled':
        return OrderStatus.cancelled;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Active', 'Shipped', 'Delivered', 'Cancelled'];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders', style: AppTextStyles.title),
      ),
      body: Consumer<OrderProvider>(
        builder: (_, provider, __) {
          final orders = _orders;

          return Column(
            children: [
              SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final f = filters[index];
                    final isSelected = _selectedFilter == f;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilter = f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.divider,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          f,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textSecondary,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimensions.sm),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : orders.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.receipt_long,
                                    size: 64, color: AppColors.textHint),
                                const SizedBox(height: 16),
                                Text('No orders found',
                                    style: AppTextStyles.subtitle),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(AppDimensions.md),
                            itemCount: orders.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              return OrderCard(
                                order: order,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        OrderDetailScreen(order: order),
                                  ),
                                ),
                                onReturn: order.isReturnReplaceEligible
                                    ? () => _showReturnReplaceSheet(
                                        context, order, ReturnReplaceType.returnRequest)
                                    : null,
                                onReplace: order.isReturnReplaceEligible
                                    ? () => _showReturnReplaceSheet(
                                        context, order, ReturnReplaceType.replaceRequest)
                                    : null,
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
