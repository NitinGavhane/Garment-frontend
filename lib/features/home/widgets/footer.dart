import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Garment',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "India's leading fashion destination",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 20),
          _FooterLinksSection(
            title: 'SHOP',
            links: ['Women', 'Men', 'Kids', 'Home', 'Brands'],
          ),
          const SizedBox(height: 16),
          _FooterLinksSection(
            title: 'HELP',
            links: ['About Us', 'Shipping & Return Policy', 'Help Center', 'Terms & Conditions', 'Privacy Policy'],
          ),
          const SizedBox(height: 16),
          _FooterLinksSection(
            title: 'FOLLOW US',
            links: ['Instagram', 'Facebook', 'Twitter', 'YouTube'],
          ),
          const SizedBox(height: 16),
          Text(
            'For any help, call us at 1800-266-3333',
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.white54),
          ),
          Text(
            'Mon-Sat: 10 AM - 10 PM, Sun: 10 AM - 7 PM',
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.white38),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 12),
          Text(
            '© 2026 Garment Ltd. All Rights Reserved.',
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.white38),
          ),
        ],
      ),
    );
  }
}

class _FooterLinksSection extends StatelessWidget {
  final String title;
  final List<String> links;

  const _FooterLinksSection({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 20,
          runSpacing: 4,
          children: links.map((link) => Text(
            link,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white54),
          )).toList(),
        ),
      ],
    );
  }
}
