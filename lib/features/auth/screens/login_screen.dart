import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_button.dart';
import '../../../providers/auth_provider.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _useOtp = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();
  bool _obscurePassword = true;
  bool _otpSent = false;
  int _timerSeconds = 30;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _loginWithPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showSnack('Please enter a valid email');
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showSnack('Please enter your password');
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      email: email,
      password: _passwordController.text,
    );
    if (success && mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
    }
  }

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showSnack('Please enter a valid email');
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.sendLoginOtp(email: email);

    if (!mounted) return;

    if (success) {
      setState(() {
        _otpSent = true;
        _timerSeconds = 30;
      });
      _startTimer();
      _showSnack('OTP sent to your email');
    } else {
      _showSnack(auth.error ?? 'Failed to send OTP');
    }
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _timerSeconds--;
      });
      return _timerSeconds > 0;
    });
  }

  Future<void> _loginWithOtp() async {
    if (_otpController.text.trim().length < 6) {
      _showSnack('Please enter the full 6-digit OTP');
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.loginWithOtp(
      email: _emailController.text.trim(),
      otp: _otpController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
    } else {
      _showSnack(auth.error ?? 'Invalid OTP. Try again.');
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
          onPressed: () => Navigator.pop(context),
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
                'Sign In',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.nykaaBlack,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your credentials to continue',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _useOtp = false;
                        _otpSent = false;
                        _otpController.clear();
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _useOtp
                                  ? AppColors.textHint
                                  : AppColors.nykaaPink,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          'Password',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _useOtp
                                ? AppColors.textSecondary
                                : AppColors.nykaaPink,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _useOtp = true;
                        _passwordController.clear();
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _useOtp
                                  ? AppColors.nykaaPink
                                  : AppColors.textHint,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          'OTP Login',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _useOtp
                                ? AppColors.nykaaPink
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              AppTextField(
                controller: _emailController,
                hintText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Iconsax.sms, size: 20),
              ),
              const SizedBox(height: 16),

              if (!_useOtp) ...[
                AppTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                  obscure: _obscurePassword,
                  prefixIcon: const Icon(Iconsax.lock, size: 20),
                  onTogglePassword: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.nykaaPink,
                      ),
                    ),
                  ),
                ),
              ],

              if (_useOtp) ...[
                if (!_otpSent)
                  AppButton(
                    label: 'Send OTP',
                    onPressed: _sendOtp,
                  )
                else ...[
                  AppTextField(
                    controller: _otpController,
                    hintText: 'Enter 6-digit OTP',
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Iconsax.lock, size: 20),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _timerSeconds <= 0 ? _sendOtp : null,
                    child: Text(
                      _timerSeconds > 0
                          ? 'Resend code in ${_timerSeconds}s'
                          : 'Resend OTP',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: _timerSeconds <= 0
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: _timerSeconds <= 0
                            ? AppColors.nykaaPink
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ],

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
              const SizedBox(height: 16),
              Consumer<AuthProvider>(
                builder: (_, auth, __) => SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: _useOtp
                        ? (_otpSent ? 'Sign In with OTP' : 'Send OTP')
                        : 'Sign In',
                    onPressed: _useOtp
                        ? (_otpSent ? _loginWithOtp : _sendOtp)
                        : _loginWithPassword,
                    isLoading: auth.isLoading,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.nykaaPink,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
