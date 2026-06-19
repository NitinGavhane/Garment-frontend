import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_button.dart';
import '../../../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _step = 1;
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  int _timerSeconds = 30;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showSnack('Please enter a valid email address');
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.forgotPassword(email: email);

    if (!mounted) return;

    if (success) {
      setState(() {
        _step = 2;
      });
      _startTimer();
    } else {
      _showSnack(auth.error ?? 'Failed to send OTP');
    }
  }

  void _startTimer() {
    _timerSeconds = 30;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _timerSeconds--;
      });
      return _timerSeconds > 0;
    });
  }

  Future<void> _resetPassword() async {
    if (_otpController.text.trim().length < 6) {
      _showSnack('Please enter the full 6-digit OTP');
      return;
    }
    if (_passwordController.text.length < 6) {
      _showSnack('Password must be at least 6 characters');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnack('Passwords do not match');
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.resetPassword(
      email: _emailController.text.trim(),
      otp: _otpController.text.trim(),
      newPassword: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      _showSnack('Password reset successfully! Please sign in.');
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    } else {
      _showSnack(auth.error ?? 'Failed to reset password. Try again.');
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            if (_step > 1) {
              setState(() => _step--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Reset Password',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.nykaaBlack,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _step == 1
                    ? 'Enter your registered email address'
                    : 'Enter the OTP sent to\n${_emailController.text.trim()}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              if (_step == 1) ...[
                AppTextField(
                  controller: _emailController,
                  hintText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Iconsax.sms, size: 20),
                ),
                const SizedBox(height: 24),
                Consumer<AuthProvider>(
                  builder: (_, auth, __) => AppButton(
                    label: 'Send OTP',
                    onPressed: _sendOtp,
                    isLoading: auth.isLoading,
                  ),
                ),
              ],

              if (_step == 2) ...[
                AppTextField(
                  controller: _otpController,
                  hintText: 'Enter 6-digit OTP',
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Iconsax.lock, size: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  _timerSeconds > 0
                      ? 'Resend code in ${_timerSeconds}s'
                      : 'Did not receive? Tap Resend',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                if (_timerSeconds <= 0)
                  GestureDetector(
                    onTap: _sendOtp,
                    child: Text(
                      'Resend OTP',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.nykaaPink,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Next',
                  onPressed: () {
                    if (_otpController.text.trim().length < 6) {
                      _showSnack('Please enter the full 6-digit OTP');
                      return;
                    }
                    setState(() => _step = 3);
                  },
                ),
              ],

              if (_step == 3) ...[
                AppTextField(
                  controller: _passwordController,
                  hintText: 'New Password',
                  isPassword: true,
                  obscure: _obscurePassword,
                  prefixIcon: const Icon(Iconsax.lock, size: 20),
                  onTogglePassword: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  isPassword: true,
                  obscure: _obscureConfirm,
                  prefixIcon: const Icon(Iconsax.lock, size: 20),
                  onTogglePassword: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                const SizedBox(height: 8),
                Consumer<AuthProvider>(
                  builder: (_, auth, __) {
                    if (auth.error != null) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          auth.error!,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.error,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 24),
                Consumer<AuthProvider>(
                  builder: (_, auth, __) => AppButton(
                    label: 'Reset Password',
                    onPressed: _resetPassword,
                    isLoading: auth.isLoading,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
