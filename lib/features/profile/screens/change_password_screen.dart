import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../providers/auth_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password', style: AppTextStyles.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.lg),
              Text(
                'Enter your current password and a new password.',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppDimensions.xl),
              AppTextField(
                controller: _currentPasswordController,
                labelText: 'Current Password',
                hintText: 'Enter current password',
                isPassword: true,
                obscure: _obscureCurrent,
                prefixIcon: const Icon(Iconsax.lock, size: 20),
                onTogglePassword: () =>
                    setState(() => _obscureCurrent = !_obscureCurrent),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Current password is required' : null,
              ),
              const SizedBox(height: AppDimensions.md),
              AppTextField(
                controller: _newPasswordController,
                labelText: 'New Password',
                hintText: 'Enter new password',
                isPassword: true,
                obscure: _obscureNew,
                prefixIcon: const Icon(Iconsax.lock_1, size: 20),
                onTogglePassword: () =>
                    setState(() => _obscureNew = !_obscureNew),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'New password is required';
                  if (v.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.md),
              AppTextField(
                controller: _confirmPasswordController,
                labelText: 'Confirm New Password',
                hintText: 'Re-enter new password',
                isPassword: true,
                obscure: _obscureConfirm,
                prefixIcon: const Icon(Iconsax.lock_1, size: 20),
                onTogglePassword: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please confirm your password';
                  if (v != _newPasswordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.xxl),
              AppButton(
                label: 'Update Password',
                onPressed: _save,
                isLoading: auth.isLoading,
              ),
              if (auth.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.md),
                  child: Text(
                    auth.error!,
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
