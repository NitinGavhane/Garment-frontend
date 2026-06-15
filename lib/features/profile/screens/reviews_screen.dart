import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/review_api_service.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    setState(() => _isLoading = true);
    try {
      final data = await ReviewApiService.getProductReviews('');
      _reviews = data.cast<Map<String, dynamic>>();
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Reviews', style: AppTextStyles.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reviews.isEmpty
              ? Center(
                  child: Text('No reviews yet', style: AppTextStyles.bodySmall),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  itemCount: _reviews.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final review = _reviews[index];
                    final rating = review['rating'] as int? ?? 5;
                    final date = review['created_at'] as String? ?? '';
                    final formatted = date.isNotEmpty
                        ? DateFormat('MMM dd, yyyy').format(DateTime.parse(date))
                        : '';

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  review['user_name'] as String? ?? 'You',
                                  style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                              if (formatted.isNotEmpty)
                                Text(formatted, style: AppTextStyles.caption.copyWith(fontSize: 10)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: List.generate(5, (i) => Icon(
                              Icons.star,
                              size: 16,
                              color: i < rating ? AppColors.rating : AppColors.border,
                            )),
                          ),
                          if (review['comment'] != null) ...[
                            const SizedBox(height: 4),
                            Text(review['comment'] as String, style: AppTextStyles.caption),
                          ],
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
