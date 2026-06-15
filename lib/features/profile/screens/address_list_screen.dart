import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers/address_provider.dart';
import '../../../core/services/api_client.dart';
import 'add_address_screen.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().fetchAddresses();
    });
  }

  Future<void> _deleteAddress(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await context.read<AddressProvider>().deleteAddress(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (_, provider, __) {
        final addresses = provider.addresses;

        return Scaffold(
          appBar: AppBar(
            title: Text('My Addresses', style: AppTextStyles.title),
          ),
          body: RefreshIndicator(
            onRefresh: () => provider.fetchAddresses(),
            child: addresses.isEmpty && !provider.isLoading
                ? Center(
                    child: Text('No addresses found',
                        style: AppTextStyles.bodySmall),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppDimensions.md),
                    itemCount: addresses.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final addr = addresses[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: addr.isDefault
                              ? Border.all(color: AppColors.primary, width: 1.5)
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  addr.type == 'Home' ? Iconsax.home : Iconsax.building,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${addr.fullName} • ${addr.type}',
                                  style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                if (addr.isDefault)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text('Default', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${addr.street}, ${addr.city}, ${addr.state} - ${addr.pincode}',
                              style: AppTextStyles.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(addr.phone, style: AppTextStyles.caption),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => AddAddressScreen(address: addr)),
                                  ).then((_) => provider.fetchAddresses()),
                                  icon: const Icon(Icons.edit, size: 16),
                                  label: const Text('Edit', style: TextStyle(fontSize: 13)),
                                ),
                                const SizedBox(width: 8),
                                if (!addr.isDefault)
                                  TextButton.icon(
                                    onPressed: () => _deleteAddress(addr.id),
                                    icon: const Icon(Icons.delete_outline, size: 16),
                                    label: const Text('Delete', style: TextStyle(fontSize: 13)),
                                    style: TextButton.styleFrom(foregroundColor: AppColors.error),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddAddressScreen()),
            ).then((_) => provider.fetchAddresses()),
            icon: const Icon(Iconsax.add),
            label: const Text('Add Address'),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
          ),
        );
      },
    );
  }
}
