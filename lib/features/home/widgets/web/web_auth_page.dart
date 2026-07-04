import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth_provider.dart';
import 'web_ui.dart';

/// Website sign-in / registration page. A split layout: brand panel on the
/// left, a login / register / OTP form on the right. Wired to [AuthProvider].
class WebAuthPage extends StatefulWidget {
  final bool startOnRegister;
  const WebAuthPage({super.key, this.startOnRegister = false});

  @override
  State<WebAuthPage> createState() => _WebAuthPageState();
}

enum _Mode { login, register, otp }

class _WebAuthPageState extends State<WebAuthPage> {
  late _Mode _mode;

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _otp = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _mode = widget.startOnRegister ? _Mode.register : _Mode.login;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _otp.dispose();
    super.dispose();
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: error ? WebTokens.danger : WebTokens.blueDeep,
    ));
  }

  Future<void> _submitLogin() async {
    final auth = context.read<AuthProvider>();
    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      _snack('Enter your email and password', error: true);
      return;
    }
    final ok = await auth.login(email: _email.text.trim(), password: _password.text);
    if (!mounted) return;
    if (ok) {
      _snack('Welcome back!');
      Navigator.of(context).pop();
    } else {
      _snack(auth.error ?? 'Login failed', error: true);
    }
  }

  Future<void> _submitRegister() async {
    final auth = context.read<AuthProvider>();
    if (_name.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _phone.text.trim().isEmpty ||
        _password.text.length < 6) {
      _snack('Fill all fields (password min 6 chars)', error: true);
      return;
    }
    final ok = await auth.register(
      fullName: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      password: _password.text,
    );
    if (!mounted) return;
    if (ok) {
      _snack('Verification code sent to ${_email.text.trim()}');
      setState(() => _mode = _Mode.otp);
    } else {
      _snack(auth.error ?? 'Registration failed', error: true);
    }
  }

  Future<void> _submitOtp() async {
    final auth = context.read<AuthProvider>();
    if (_otp.text.trim().length < 4) {
      _snack('Enter the verification code', error: true);
      return;
    }
    final ok = await auth.verifyOtp(email: _email.text.trim(), otp: _otp.text.trim());
    if (!mounted) return;
    if (ok) {
      _snack('Account verified — please sign in');
      setState(() => _mode = _Mode.login);
    } else {
      _snack(auth.error ?? 'Verification failed', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthProvider>().isLoading;
    return Scaffold(
      backgroundColor: WebTokens.surface,
      body: Row(
        children: [
          const Expanded(flex: 5, child: _BrandPanel()),
          Expanded(
            flex: 5,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: _form(loading),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _form(bool loading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back, size: 16, color: WebTokens.muted),
                const SizedBox(width: 6),
                Text('Back to store', style: WebTokens.sans(13, color: WebTokens.muted)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          _mode == _Mode.login
              ? 'Welcome Back'
              : _mode == _Mode.register
                  ? 'Create Account'
                  : 'Verify Email',
          style: WebTokens.display(34, color: WebTokens.ink),
        ),
        const SizedBox(height: 8),
        Text(
          _mode == _Mode.login
              ? 'Sign in to continue shopping with Dristi Fashions.'
              : _mode == _Mode.register
                  ? 'Join Dristi Fashions for a premium shopping experience.'
                  : 'Enter the code we sent to ${_email.text.trim()}.',
          style: WebTokens.sans(14, color: WebTokens.muted, height: 1.6),
        ),
        const SizedBox(height: 32),
        if (_mode == _Mode.register)
          _field('Full Name', _name, icon: Icons.person_outline),
        if (_mode == _Mode.login || _mode == _Mode.register)
          _field('Email', _email, icon: Icons.email_outlined),
        if (_mode == _Mode.register)
          _field('Phone', _phone, icon: Icons.phone_outlined),
        if (_mode == _Mode.login || _mode == _Mode.register)
          _field('Password', _password,
              icon: Icons.lock_outline,
              obscure: _obscure,
              trailing: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                    size: 18, color: WebTokens.muted),
              )),
        if (_mode == _Mode.otp)
          _field('Verification Code', _otp, icon: Icons.pin_outlined),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: loading
                ? null
                : _mode == _Mode.login
                    ? _submitLogin
                    : _mode == _Mode.register
                        ? _submitRegister
                        : _submitOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: WebTokens.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: loading
                ? const SizedBox(
                    width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(
                    _mode == _Mode.login
                        ? 'SIGN IN'
                        : _mode == _Mode.register
                            ? 'CREATE ACCOUNT'
                            : 'VERIFY',
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1)),
          ),
        ),
        const SizedBox(height: 24),
        if (_mode != _Mode.otp)
          Center(
            child: GestureDetector(
              onTap: () => setState(() => _mode = _mode == _Mode.login ? _Mode.register : _Mode.login),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: RichText(
                  text: TextSpan(
                    style: WebTokens.sans(14, color: WebTokens.muted),
                    children: [
                      TextSpan(text: _mode == _Mode.login ? 'New to Dristi? ' : 'Already have an account? '),
                      TextSpan(
                        text: _mode == _Mode.login ? 'Create an account' : 'Sign in',
                        style: WebTokens.sans(14, color: WebTokens.blue, w: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _field(String label, TextEditingController c,
      {IconData? icon, bool obscure = false, Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: WebTokens.sans(13, color: WebTokens.ink, w: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: c,
            obscureText: obscure,
            style: WebTokens.sans(14, color: WebTokens.ink),
            decoration: InputDecoration(
              prefixIcon: icon != null ? Icon(icon, size: 20, color: WebTokens.muted) : null,
              suffixIcon: trailing,
              filled: true,
              fillColor: WebTokens.surfaceAlt,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: WebTokens.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: WebTokens.blue, width: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.2, -0.4),
          radius: 1.3,
          colors: [WebTokens.blue, WebTokens.blueDeep],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('assets/logo.jpg', width: 54, height: 54, fit: BoxFit.cover),
                ),
                const SizedBox(width: 14),
                Text('DRISTI FASHIONS',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1.5)),
              ],
            ),
            const SizedBox(height: 40),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: 'Fashion That\n', style: WebTokens.display(44, color: Colors.white)),
                TextSpan(text: 'Reflects You', style: WebTokens.serifItalic(48, color: WebTokens.goldBright)),
              ]),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 400,
              child: Text(
                'Sign in to track orders, save your wishlist, check out faster and unlock member-only offers.',
                style: WebTokens.sans(16, color: WebTokens.onDarkMuted, height: 1.8),
              ),
            ),
            const SizedBox(height: 40),
            for (final t in const [
              'Faster, secure checkout',
              'Track every order in real time',
              'Save favourites to your wishlist',
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 20, color: WebTokens.goldBright),
                    const SizedBox(width: 12),
                    Text(t, style: WebTokens.sans(15, color: Colors.white, w: FontWeight.w500)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
