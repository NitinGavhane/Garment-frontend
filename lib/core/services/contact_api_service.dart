import 'api_client.dart';

/// Contact enquiries and newsletter signups.
///
/// Both are stored server-side and read from the Admin app — the store's domain
/// has no mailbox, so email is not a delivery route.
class ContactApiService {
  static Future<String> sendMessage({
    required String fullName,
    required String email,
    String? subject,
    required String message,
  }) async {
    final res = await ApiClient.post('/api/v1/contact', body: {
      'full_name': fullName,
      'email': email,
      if (subject != null && subject.isNotEmpty) 'subject': subject,
      'message': message,
    });
    return res['message'] as String? ?? 'Thanks — we have received your message.';
  }

  static Future<String> subscribe(String email) async {
    final res = await ApiClient.post('/api/v1/newsletter', body: {'email': email});
    return res['message'] as String? ?? 'Thanks for subscribing.';
  }
}
