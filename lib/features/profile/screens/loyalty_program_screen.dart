import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/widgets/policy_scaffold.dart';

class LoyaltyProgramScreen extends StatelessWidget {
  const LoyaltyProgramScreen({super.key});

  static const List<PolicySection> _sections = [
    PolicySection(
      heading: '1. Program Membership & Eligibility',
      bullets: [
        'Eligibility: Membership to Drishti Rewards & Club is open to all registered users of Drishti Fashions who are legal residents of India and aged 18 years or older.',
        'Free Enrolment: Joining the program is completely free of charge upon creating a verified account on our Platform.',
        'Account Association: Membership is personal, non-transferable, and limited to one account per individual. Points and rewards cannot be pooled, transferred, or combined across multiple accounts.',
      ],
    ),
    PolicySection(
      heading: '2. Earning Drishti Fashions Points & Cashback',
      bullets: [
        'How to Earn: Members earn reward points or cashback on eligible purchases made on the Drishti Fashions store. The earning rate (e.g., points per rupee spent) is determined by your current membership tier and promotional events.',
        'Exclusions: Points are typically calculated on the final net transaction value (excluding shipping fees, platform convenience fees, taxes, and returned/cancelled items). Gift card purchases may be excluded from earning points unless specified otherwise.',
        'Crediting Timeline: Points earned on purchases are usually credited to your account after the return window (7 days post-delivery) closes successfully.',
      ],
    ),
    PolicySection(
      heading: '3. VIP Tiers (Including Drishti Fashions Platinum)',
      paragraph: 'Our program features multi-tier membership benefits designed to reward our most loyal shoppers.',
      bullets: [
        'Tier Progression: Your membership tier is determined by your cumulative spending or purchase frequency within a rolling 12-month period.',
        'Drishti Platinum Benefits: Members who attain the Platinum tier unlock premium perks, which may include:',
      ],
      subBullets: [
        'Free delivery on all eligible orders (exceeding ₹199).',
        'Early access to seasonal sales, flash drops, and new designer collections.',
        'Dedicated priority customer support.',
        'Tier Review: Tiers are valid for a specified duration (typically 1 year) and are subject to periodic evaluation based on account activity.',
      ],
    ),
    PolicySection(
      heading: '4. Redeeming & Using Points / Cashbacks',
      bullets: [
        'Redemption: Accumulated Drishti Points or cashbacks can be redeemed as a discount against future purchases on the Platform, subject to minimum cart value requirements or maximum redemption limits per order.',
        'Non-Encashable: Points, cashbacks, and rewards hold no cash value, and cannot be exchanged for cash, and are non-refundable.',
        'Expiration: Unless stated otherwise during promotional campaigns, Drishti Fashions Points remain valid for 12 months from the date of credit, after which unused points will automatically expire.',
      ],
    ),
    PolicySection(
      heading: '5. Program Modifications, Suspension & Termination',
      bullets: [
        'Right to Modify: Drishti Fashions reserves the right to modify, amend, sustain, or terminate the Drishti Rewards & Club program, its tiers, earning rates, or redemption rules at any time without prior individual notice.',
        'Abuse & Fraud: We reserve the right to disqualify any member, revoke points, or terminate membership immediately in cases of suspected fraud, policy abuse, creation of duplicate accounts, or violation of our general Terms & Conditions.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const PolicyScaffold(
      title: 'Drishti Rewards & Club',
      intro:
          'Welcome to Drishti Rewards & Club, the exclusive loyalty and rewards program offered by Drishti Fashions. By joining, earning points, or unlocking VIP tiers (such as Drishti Fashions Platinum), you agree to be bound by the following Terms and Conditions.',
      sections: _sections,
      contactHeading: 'Contact Us',
      contactIntro:
          'If you have any questions or require assistance regarding your Drishti Rewards membership, points balance, or tier status, please reach out to our support team:',
      contactDetails: [
        ContactDetail(label: 'Name', value: 'Mr. Prakash — Operations Head', icon: Iconsax.user),
        ContactDetail(label: 'Email', value: 'info@drishtifashions.com', icon: Iconsax.sms),
        ContactDetail(label: 'Phone', value: '+91 6290486090 (Mon-Sat, 10 AM to 7 PM)', icon: Iconsax.call),
      ],
    );
  }
}