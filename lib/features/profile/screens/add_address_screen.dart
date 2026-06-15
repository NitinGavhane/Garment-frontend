import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../models/address.dart';
import '../../../providers/address_provider.dart';

class AddAddressScreen extends StatefulWidget {
  final Address? address;

  const AddAddressScreen({super.key, this.address});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  String _selectedType = 'Home';

  bool get _isEditing => widget.address != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final a = widget.address!;
      _nameController.text = a.fullName;
      _phoneController.text = a.phone;
      _streetController.text = a.street;
      _cityController.text = a.city;
      _stateController.text = a.state;
      _pincodeController.text = a.pincode;
      _selectedType = a.type;
    }
  }

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
    bool success;

    if (_isEditing) {
      success = await provider.updateAddress(
        addressId: widget.address!.id,
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        type: _selectedType,
      );
    } else {
      success = await provider.createAddress(
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        type: _selectedType,
      );
    }

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Address updated' : 'Address added')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddressProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Address' : 'Add Address', style: AppTextStyles.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: _nameController,
                labelText: 'Full Name',
                hintText: 'Enter full name',
                prefixIcon: const Icon(Iconsax.user, size: 20),
                validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: AppDimensions.md),
              AppTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                hintText: 'Enter phone number',
                prefixIcon: const Icon(Iconsax.call, size: 20),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.trim().isEmpty ? 'Phone is required' : null,
              ),
              const SizedBox(height: AppDimensions.md),
              AppTextField(
                controller: _streetController,
                labelText: 'Street / Area',
                hintText: 'Enter street address',
                prefixIcon: const Icon(Iconsax.location, size: 20),
                validator: (v) => v == null || v.trim().isEmpty ? 'Street is required' : null,
              ),
              const SizedBox(height: AppDimensions.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _cityController,
                      labelText: 'City',
                      hintText: 'City',
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      controller: _stateController,
                      labelText: 'State',
                      hintText: 'State',
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.md),
              AppTextField(
                controller: _pincodeController,
                labelText: 'Pincode',
                hintText: 'Enter pincode',
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.trim().isEmpty ? 'Pincode is required' : null,
              ),
              const SizedBox(height: AppDimensions.lg),
              Text('Address Type', style: AppTextStyles.subtitle),
              const SizedBox(height: AppDimensions.sm),
              Row(
                children: ['Home', 'Work', 'Other'].map((type) {
                  final selected = _selectedType == type;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: type == 'Work' ? 8 : 0,
                        right: type == 'Work' ? 8 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedType = type),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primary : AppColors.divider,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                type == 'Home'
                                    ? Iconsax.home
                                    : type == 'Work'
                                        ? Iconsax.building
                                        : Iconsax.location,
                                size: 16,
                                color: selected ? AppColors.white : AppColors.textPrimary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                type,
                                style: TextStyle(
                                  color: selected ? AppColors.white : AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppDimensions.xxl),
              AppButton(
                label: _isEditing ? 'Update Address' : 'Save Address',
                onPressed: _save,
                isLoading: provider.isLoading,
              ),
              if (provider.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.md),
                  child: Text(
                    provider.error!,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
