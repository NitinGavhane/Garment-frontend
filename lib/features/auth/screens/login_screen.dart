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
  bool _otpSent = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  int _timerSeconds = 30;
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());
  final List<String> _prevValues = List.generate(6, (_) => '');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
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

  void _onOtpChange(int index, String value) {
    if (value.length > 1) {
      _otpControllers[index].text = value.substring(value.length - 1);
    }
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && _prevValues[index].isNotEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    _prevValues[index] = value.isEmpty ? '' : value;
  }

  String get _otp => _otpControllers.map((c) => c.text).join();

  void _clearOtpFields() {
    for (var c in _otpControllers) {
      c.clear();
    }
    for (var i = 0; i < _prevValues.length; i++) {
      _prevValues[i] = '';
    }
    _focusNodes[0].requestFocus();
  }

  Future<void> _loginWithOtp() async {
    if (_otp.length < 6) {
      _showSnack('Please enter the full 6-digit OTP');
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.loginWithOtp(
      email: _emailController.text.trim(),
      otp: _otp,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
    } else {
      _clearOtpFields();
      _showSnack('Enter Valid OTP');
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
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        _useOtp = true;
                        _passwordController.clear();
                      }),
                      child: Text(
                        'Sign in with OTP',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.nykaaPink,
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
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
                  ],
                ),
              ],

              if (_useOtp && _otpSent) ...[
                const SizedBox(height: 8),
                Form(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 48,
                        height: 56,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColors.nykaaBlack,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: const Color(0xFFF5F5F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.nykaaPink,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (v) => _onOtpChange(index, v),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: _timerSeconds <= 0
                        ? () {
                            _clearOtpFields();
                            _startTimer();
                            _sendOtp();
                          }
                        : null,
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
                ),
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
                        ? (_otpSent ? 'Verify' : 'Send OTP')
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
