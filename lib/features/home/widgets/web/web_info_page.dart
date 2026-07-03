import 'package:flutter/material.dart';

import 'web_chrome.dart';
import 'web_ui.dart';

enum WebInfoMode { about, contact }

/// About Us / Contact Us website page. Static, design-system content.
class WebInfoPage extends StatelessWidget {
  final WebInfoMode mode;
  const WebInfoPage({super.key, required this.mode});

  bool get _isAbout => mode == WebInfoMode.about;

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      activeNav: _isAbout ? 'ABOUT US' : 'CONTACT US',
      body: Column(
        children: [
          WebPageHeader(
            centered: true,
            eyebrow: _isAbout ? 'Who We Are' : 'Get In Touch',
            title: _isAbout ? 'About Dristi Fashions' : 'Contact Us',
            subtitle: _isAbout
                ? 'Fashion that reflects your personality — crafted with perfection, comfort and elegance.'
                : 'We\'d love to hear from you. Reach out and our team will get back within 24 hours.',
          ),
          _isAbout ? const _AboutBody() : const _ContactBody(),
        ],
      ),
    );
  }
}


// ─── About ───────────────────────────────────────────────────────────────────

class _AboutBody extends StatelessWidget {
  const _AboutBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WebSection(
          background: WebTokens.surface,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: const SizedBox(
                    height: 400,
                    child: WebImage(
                        url: 'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=800&q=80'),
                  ),
                ),
              ),
              const SizedBox(width: 56),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Our Story', style: WebTokens.display(32, color: WebTokens.ink)),
                    const SizedBox(height: 18),
                    Text(
                      'At Dristi Fashions, we believe clothing is a form of self-expression. '
                      'Founded with a passion for premium fabrics and thoughtful design, we craft '
                      'ladies wear, men\'s wear, kids wear and ethnic collections that blend timeless '
                      'elegance with modern comfort.\n\n'
                      'Every piece is created with attention to detail, ethical sourcing and a '
                      'commitment to quality — so you always look and feel your best, for every '
                      'occasion.',
                      style: WebTokens.sans(15, color: WebTokens.body, height: 1.9),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        WebSection(
          background: WebTokens.surfaceAlt,
          child: Column(
            children: [
              const WebHeading(eyebrow: 'What Drives Us', title: 'Our Values'),
              const SizedBox(height: 44),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < _values.length; i++) ...[
                    Expanded(child: _ValueCard(_values[i])),
                    if (i != _values.length - 1) const SizedBox(width: 24),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static const List<(IconData, String, String)> _values = [
    (Icons.workspace_premium_outlined, 'Premium Quality',
        'Finest fabrics and meticulous finishing on every garment we make.'),
    (Icons.favorite_border, 'Crafted with Care',
        'Thoughtful, ethical design that puts comfort and detail first.'),
    (Icons.diversity_3_outlined, 'For Everyone',
        'Collections for ladies, men and kids — style for the whole family.'),
  ];
}

class _ValueCard extends StatelessWidget {
  final (IconData, String, String) data;
  const _ValueCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: WebTokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WebTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: WebTokens.cream,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(data.$1, color: WebTokens.gold, size: 28),
          ),
          const SizedBox(height: 20),
          Text(data.$2, style: WebTokens.sans(18, color: WebTokens.ink, w: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(data.$3, style: WebTokens.sans(14, color: WebTokens.body, height: 1.7)),
        ],
      ),
    );
  }
}

// ─── Contact ─────────────────────────────────────────────────────────────────

class _ContactBody extends StatelessWidget {
  const _ContactBody();

  @override
  Widget build(BuildContext context) {
    return const WebSection(
      background: WebTokens.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ContactItem(Icons.email_outlined, 'Email Us', 'support@dristifashions.com'),
                SizedBox(height: 28),
                _ContactItem(Icons.phone_outlined, 'Call Us', '+91 98765 43210'),
                SizedBox(height: 28),
                _ContactItem(Icons.location_on_outlined, 'Visit Us',
                    'Dristi Fashions, Fashion Street,\nMumbai, Maharashtra, India'),
                SizedBox(height: 28),
                _ContactItem(Icons.schedule, 'Working Hours',
                    'Mon – Sat: 10:00 AM – 8:00 PM'),
              ],
            ),
          ),
          SizedBox(width: 56),
          Expanded(flex: 6, child: _ContactForm()),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _ContactItem(this.icon, this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: WebTokens.cream,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: WebTokens.gold, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: WebTokens.sans(15, color: WebTokens.ink, w: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(value, style: WebTokens.sans(14, color: WebTokens.body, height: 1.6)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactForm extends StatelessWidget {
  const _ContactForm();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: WebTokens.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WebTokens.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Send us a message',
              style: WebTokens.display(24, color: WebTokens.ink)),
          const SizedBox(height: 24),
          const Row(
            children: [
              Expanded(child: _Field(label: 'Full Name', hint: 'Your name')),
              SizedBox(width: 20),
              Expanded(child: _Field(label: 'Email', hint: 'you@example.com')),
            ],
          ),
          const SizedBox(height: 20),
          const _Field(label: 'Subject', hint: 'How can we help?'),
          const SizedBox(height: 20),
          const _Field(label: 'Message', hint: 'Write your message…', maxLines: 5),
          const SizedBox(height: 28),
          Builder(
            builder: (context) => WebGoldButton(
              label: 'SEND MESSAGE',
              icon: Icons.send_outlined,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thanks! We\'ll get back to you within 24 hours.'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: WebTokens.blueDeep,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  const _Field({required this.label, required this.hint, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: WebTokens.sans(13, color: WebTokens.ink, w: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          style: WebTokens.sans(14, color: WebTokens.ink),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: WebTokens.sans(14, color: WebTokens.muted),
            filled: true,
            fillColor: WebTokens.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    );
  }
}
