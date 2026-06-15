import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'address_list_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  String _shippingCountry = 'India';

  static const List<String> _countries = [
    'India', 'United States', 'United Kingdom', 'Canada', 'Australia',
    'Germany', 'France', 'UAE', 'Singapore', 'Other',
  ];

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (_, scrollController) => Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Shipping Country', style: AppTextStyles.title),
              const SizedBox(height: AppDimensions.md),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: _countries.map((c) => RadioListTile<String>(
                        value: c,
                        groupValue: _shippingCountry,
                        onChanged: (v) {
                          setState(() => _shippingCountry = v!);
                          Navigator.pop(ctx);
                        },
                        title: Text(c, style: AppTextStyles.body),
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                      )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account', style: AppTextStyles.subtitle),
            const SizedBox(height: AppDimensions.sm),
            _settingTile(Iconsax.user, 'Personal Information', 'Edit your name, email, phone', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()))),
            _settingTile(Iconsax.lock, 'Change Password', 'Update your account password', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen()))),
            _settingTile(Iconsax.home_2, 'Address', 'Manage your saved addresses', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddressListScreen()))),
            const SizedBox(height: AppDimensions.lg),
            Text('Preferences', style: AppTextStyles.subtitle),
            const SizedBox(height: AppDimensions.sm),
            _switchTile(Iconsax.notification, 'Push Notifications', _notifications, (v) => setState(() => _notifications = v)),
            _switchTile(Iconsax.moon, 'Dark Mode', _darkMode, (v) => setState(() => _darkMode = v)),
            const SizedBox(height: AppDimensions.lg),
            Text('More', style: AppTextStyles.subtitle),
            const SizedBox(height: AppDimensions.sm),
            _settingTile(Iconsax.location, 'Shipping Country', _shippingCountry, onTap: _showCountryPicker),
            _settingTile(Iconsax.info_circle, 'About', 'Version 1.0.0'),
          ],
        ),
      ),
    );
  }

  Widget _settingTile(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
        title: Text(title, style: AppTextStyles.body),
        subtitle: Text(subtitle, style: AppTextStyles.caption),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        onTap: onTap,
      ),
    );
  }

  Widget _switchTile(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppColors.textPrimary),
        ),
        title: Text(title, style: AppTextStyles.body),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
