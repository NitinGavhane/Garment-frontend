import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _avatarUrl;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      _nameController.text = user.fullName;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
      _avatarUrl = user.avatarUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _avatarUrl = image.path);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.updateProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: AppTextStyles.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.lg),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.divider,
                    backgroundImage: _avatarUrl != null
                        ? NetworkImage(_avatarUrl!)
                        : null,
                    child: _avatarUrl == null
                        ? Text(
                            user?.fullName.split(' ').map((n) => n[0]).join() ?? '',
                            style: AppTextStyles.displayLarge.copyWith(
                              color: AppColors.textHint,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.surface, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 18, color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.xxl),
              AppTextField(
                controller: _nameController,
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: const Icon(Iconsax.user, size: 20),
                validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: AppDimensions.md),
              AppTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: const Icon(Iconsax.sms, size: 20),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.md),
              AppTextField(
                controller: _phoneController,
                labelText: 'Phone',
                hintText: 'Enter your phone number',
                prefixIcon: const Icon(Iconsax.call, size: 20),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppDimensions.xxl),
              AppButton(
                label: 'Save Changes',
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
