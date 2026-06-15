import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/services/order_api_service.dart';
import '../../../core/services/cart_api_service.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/payment_methods_api_service.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/address_provider.dart';
import '../../../models/address.dart';
import '../../payment/screens/payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Address? _selectedAddress;
  String _selectedPayment = 'Google Pay';
  bool _isPlacing = false;
  String? _error;
  List<Map<String, dynamic>> _paymentMethods = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final addrProvider = context.read<AddressProvider>();
    await addrProvider.fetchAddresses();
    if (mounted) {
      setState(() {
        _selectedAddress = addrProvider.defaultAddress;
      });
    }

    try {
      final methods = await PaymentMethodsApiService.listPaymentMethods();
      if (mounted) {
        setState(() {
          _paymentMethods = methods.cast<Map<String, dynamic>>();
          if (_paymentMethods.isNotEmpty) {
            _selectedPayment = _paymentMethods.first['name'] as String;
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _paymentMethods = [
            {'name': 'Google Pay', 'code': 'gpay', 'is_active': true},
            {'name': 'PhonePe', 'code': 'phonepe', 'is_active': true},
            {'name': 'Paytm', 'code': 'paytm', 'is_active': true},
            {'name': 'Credit Card', 'code': 'card', 'is_active': true},
            {'name': 'Cash on Delivery', 'code': 'cod', 'is_active': true},
          ];
        });
      }
    }
  }

  Future<void> _placeOrder() async {
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    setState(() {
      _isPlacing = true;
      _error = null;
    });

    try {
      final cart = context.read<CartProvider>();
      final items = cart.items.map((ci) => {
        'product_id': ci.product.id,
        'variant_id': null,
        'quantity': ci.quantity,
      }).toList();

      final orderResult = await OrderApiService.createOrder(
        shippingAddress: _selectedAddress?.toString() ?? '',
        items: items,
      );

      final orderId = orderResult['id'] as String;
      final amount = (orderResult['final_amount'] as num).toDouble();

      await CartApiService.getCart();

      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentScreen(
            orderId: orderId,
            amount: amount,
          ),
        ),
      );

      cart.clear();
      if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = 'Failed to place order. Please try again.');
    } finally {
      if (mounted) setState(() => _isPlacing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final subtotal = cart.subtotal;
    final shipping = subtotal > 100 ? 0.0 : 9.99;
    final total = subtotal + shipping;
    final addresses = context.watch<AddressProvider>().addresses;

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: AppTextStyles.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.md),
        children: [
          _sectionHeader('Delivery Address', Iconsax.location),
          const SizedBox(height: AppDimensions.sm),
          if (_selectedAddress != null)
            GestureDetector(
              onTap: () => _showAddressPicker(context, addresses),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Iconsax.home,
                          color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_selectedAddress!.fullName} • ${_selectedAddress!.type}',
                            style: AppTextStyles.subtitle.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_selectedAddress!.street}, ${_selectedAddress!.city}, ${_selectedAddress!.state} - ${_selectedAddress!.pincode}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary, fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        color: AppColors.textHint, size: 20),
                  ],
                ),
              ),
            ),
          const SizedBox(height: AppDimensions.lg),
          _sectionHeader('Payment Method', Iconsax.wallet),
          const SizedBox(height: AppDimensions.sm),
          ..._paymentMethods.map((pm) => _PaymentMethodTile(
                name: pm['name'] as String,
                code: pm['code'] as String? ?? '',
                isSelected: _selectedPayment == pm['name'],
                onTap: () => setState(() => _selectedPayment = pm['name'] as String),
              )),
          const SizedBox(height: AppDimensions.lg),
          _sectionHeader('Order Summary', Iconsax.receipt),
          const SizedBox(height: AppDimensions.sm),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Column(
              children: [
                ...cart.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 44, height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: item.product.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.checkroom_rounded,
                                size: 22,
                                color: AppColors.white.withValues(alpha: 0.5)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.title,
                                    style: AppTextStyles.bodySmall
                                        .copyWith(fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text(
                                  'Qty: ${item.quantity} • ${item.selectedSize} • ${item.selectedColor}',
                                  style: AppTextStyles.caption,
                                ),
                              ],
                            ),
                          ),
                          Text('₹${item.totalPrice.toStringAsFixed(2)}',
                              style: AppTextStyles.priceSmall),
                        ],
                      ),
                    )),
                const Divider(),
                _summaryRow('Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
                _summaryRow('Shipping',
                    shipping == 0 ? 'FREE' : '₹${shipping.toStringAsFixed(2)}'),
                const Divider(),
                _summaryRow('Total', '₹${total.toStringAsFixed(2)}',
                    isTotal: true),
              ],
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _error!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              ),
            ),
          const SizedBox(height: AppDimensions.xl),
          Consumer<AuthProvider>(
            builder: (_, auth, __) {
              if (!auth.isLoggedIn) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Iconsax.info_circle,
                              color: AppColors.warning, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Please sign in to place your order',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.md),
                    AppButton(
                      label: 'Sign In to Continue',
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                    ),
                  ],
                );
              }
              return AppButton(
                label: 'Place Order • ₹${total.toStringAsFixed(2)}',
                onPressed: _placeOrder,
                isLoading: _isPlacing,
              );
            },
          ),
          const SizedBox(height: AppDimensions.lg),
        ],
      ),
    );
  }

  void _showAddressPicker(BuildContext context, List<Address> addresses) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Address', style: AppTextStyles.title),
            const SizedBox(height: AppDimensions.md),
            ...addresses
                .map((a) => RadioListTile<Address>(
                      value: a,
                      groupValue: _selectedAddress,
                      onChanged: (v) {
                        setState(() => _selectedAddress = v!);
                        Navigator.pop(ctx);
                      },
                      title: Text('${a.fullName} • ${a.type}',
                          style: AppTextStyles.subtitle),
                      subtitle: Text(
                          '${a.street}, ${a.city} - ${a.pincode}',
                          style: AppTextStyles.caption),
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                    )),
            const SizedBox(height: AppDimensions.md),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const _NewAddressScreen(),
                  ),
                );
              },
              icon: const Icon(Iconsax.add, size: 18),
              label: const Text('Add New Address'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textPrimary),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.subtitle),
      ],
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: isTotal ? AppTextStyles.title : AppTextStyles.bodySmall),
          Text(value,
              style: isTotal
                  ? AppTextStyles.headline3.copyWith(
                      color: AppColors.secondary, fontSize: 18)
                  : AppTextStyles.body),
        ],
      ),
    );
  }
}

class _NewAddressScreen extends StatefulWidget {
  const _NewAddressScreen();

  @override
  State<_NewAddressScreen> createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<_NewAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<AddressProvider>();
    final success = await provider.createAddress(
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pincode: _pincodeController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address added')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddressProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('New Address', style: AppTextStyles.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _nameController,
                labelText: 'Full Name',
                hintText: 'Enter full name',
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppDimensions.md),
              AppTextField(
                controller: _phoneController,
                labelText: 'Phone',
                hintText: 'Enter phone',
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppDimensions.md),
              AppTextField(
                controller: _streetController,
                labelText: 'Street',
                hintText: 'Enter street',
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppDimensions.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _cityController,
                      labelText: 'City',
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      controller: _stateController,
                      labelText: 'State',
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.md),
              AppTextField(
                controller: _pincodeController,
                labelText: 'Pincode',
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppDimensions.xxl),
              AppButton(
                label: 'Save',
                onPressed: _save,
                isLoading: provider.isLoading,
              ),
              if (provider.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(provider.error!, style: TextStyle(color: AppColors.error)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String name;
  final String code;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.name, required this.code,
    required this.isSelected, required this.onTap,
  });

  IconData _iconFor(String code) {
    switch (code) {
      case 'gpay': return Icons.g_mobiledata;
      case 'phonepe': return Icons.phone_android;
      case 'paytm': return Icons.account_balance_wallet;
      case 'card': return Icons.credit_card;
      case 'netbanking': return Icons.account_balance;
      default: return Icons.money;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(_iconFor(code), size: 24,
                color: isSelected ? AppColors.primary : AppColors.textHint),
            const SizedBox(width: 12),
            Expanded(child: Text(name, style: AppTextStyles.body)),
            const SizedBox(width: 8),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
