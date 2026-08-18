import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/widgets/policy_scaffold.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const List<PolicySection> _sections = [
    PolicySection(
      heading: '1. Who We Are',
      paragraph:
          'DRISTI DHIMAHI VYAPAAR PRIVATE LIMITED operates Drishti Fashions to market, sell, and retail apparel and fashion wear. When we collect and manage your personal data, we act as a Data Controller, ensuring it is handled securely and responsibly.',
    ),
    PolicySection(
      heading: '2. Personal Information We Gather',
      paragraph:
          'To provide you with a seamless shopping experience, register your account, process payments, and send updates, we collect various types of information:',
      bullets: [
        'Information You Give Us: Details provided during account creation, order placement, customer support queries, or promotional interactions.',
        'Information We May Collect: Technical data such as your IP address, browser type, device details, location information, and interaction history via cookies and SDKs.',
        'Information from Third Parties: Updated delivery and address details from our logistics partners to ensure smooth fulfilment.',
        'Demographic & Identity Data: Name, email address, phone number, shipping address, country, date of birth, and profile picture.',
        'Financial Details: Transaction amounts, bank details (only for a refund of an order if you ask for the same), card types, and payment identifiers.',
      ],
    ),
    PolicySection(
      heading: '3. How We Use Your Information',
      paragraph: 'Your information helps us operate, improve, and personalise your experience. Key purposes include:',
      bullets: [
        'Processing orders, handling secure payments, and coordinating doorstep deliveries.',
        'Troubleshooting platform errors, analysing site performance, and improving usability.',
        'Offering personalised product recommendations and tailored advertisements.',
        'Communicating with you regarding order updates, customer support, and promotional offers.',
      ],
    ),
    PolicySection(
      heading: '4. Cookies and Tracking Technologies',
      paragraph:
          'We use cookies, pixel tags, log files, and third-party SDKs (such as analytics and payment gateways like Cashfree) to make our Platform function smoothly.',
      bullets: [
        'Strictly Necessary Cookies: Required for basic site navigation, security, and account logins. Disabling these may impact platform functionality.',
        'Functional & Performance Cookies: Help remember your preferences (like region or font size) and analyse traffic to improve our services.',
        'Note on Do Not Track: Our systems do not currently respond to browser "Do Not Track" signals.',
      ],
    ),
    PolicySection(
      heading: '5. Data Sharing & Disclosure',
      paragraph:
          'We do not sell your personal data. However, we may share information with trusted third parties under strict contractual safeguards for:',
      bullets: [
        'Order Fulfilment & Logistics: Partnering with delivery couriers to ship your purchases.',
        'Secure Payment Processing: Facilitating secure financial transactions via verified payment gateways.',
        'Support & Analytics: Resolving queries quickly and analysing user behaviour to enhance our collections.',
        'Legal Compliance: Disclosing information when required by law enforcement, government authorities, or courts to prevent fraud or protect legal rights.',
      ],
    ),
    PolicySection(
      heading: '6. Data Security & Retention',
      paragraph:
          'Security: We implement robust physical, technical, and managerial safeguards to protect your data from unauthorised access, alteration, or deletion. Retention: We retain your personal data only as long as necessary to fulfil the purposes outlined in this policy of to comply with legal/regulatory obligations. Once obsolete, data is securely deleted or permanently de-identified.',
    ),
    PolicySection(
      heading: '7. Your Customer Rights',
      paragraph:
          'Under applicable privacy regulations, you have rights over your personal data, including the right to access, correct errors, or request the deletion of your account and associated data.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const PolicyScaffold(
      title: 'Privacy Policy',
      intro:
          'Welcome to Drishti Fashions. We value your trust and are committed to protecting your personal information. By accessing our Platform or sharing your information with us, you agree to be bound by this Privacy Policy and governed by the laws of India.',
      sections: _sections,
      contactHeading: 'Grievance Officer',
      contactIntro:
          'If your concern is not resolved satisfactorily through regular support channels, you may reach out to our designated Grievance Officer in accordance with the Information Technology Act.',
      contactDetails: [
        ContactDetail(label: 'Name', value: 'Mr. Prakash — Operations Head', icon: Iconsax.user),
        ContactDetail(label: 'Address', value: '212, Girish Ghosh Rd, Belur Bazar, Howrah-711202', icon: Iconsax.location),
        ContactDetail(label: 'Email', value: 'info@drishtifashions.com', icon: Iconsax.sms),
        ContactDetail(label: 'Phone', value: '+91 6290486090 (Mon-Sat, 10 AM to 7 PM)', icon: Iconsax.call),
      ],
      securityNotice:
          'Important Security Reminder: Drishti Fashions never asks for confidential information like OTPs, CVVs, PINs, or bank account details over phone calls or messages. Please stay vigilant against phishing scams and report any fraudulent calls to our Grievance Officer immediately.',
    );
  }
}