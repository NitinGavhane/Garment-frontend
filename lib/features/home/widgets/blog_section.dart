import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/blog_api_service.dart';
import 'section_header.dart';

class BlogSection extends StatefulWidget {
  const BlogSection({super.key});

  @override
  State<BlogSection> createState() => _BlogSectionState();
}

class _BlogSectionState extends State<BlogSection> {
  List<Map<String, dynamic>> _posts = [];
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final data = await BlogApiService.listPosts();
      if (mounted) {
        setState(() {
          _posts = data.cast<Map<String, dynamic>>();
          _isLoaded = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoaded = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.sectionPadding,
        horizontal: 24,
      ),
      color: AppColors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          int crossAxisCount;
          if (width > 900) {
            crossAxisCount = 3;
          } else if (width > 600) {
            crossAxisCount = 2;
          } else {
            crossAxisCount = 1;
          }

          return Column(
            children: [
              SectionHeader(
                title: 'OUR BLOG',
                hasDashes: true,
              ),
              const SizedBox(height: 40),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.85,
                ),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return _BlogCard(post: post);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const _BlogCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: post['image_url'] as String? ?? '',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 200,
                    color: AppColors.surface,
                    child: Center(
                      child: Icon(Icons.image, size: 48, color: Colors.grey[300]),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 200,
                    color: AppColors.surface,
                    child: Center(
                      child: Icon(Icons.image, size: 48, color: Colors.grey[300]),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.badgeNew,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      post['category'] as String? ?? '',
                      style: AppTextStyles.badge.copyWith(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['title'] as String? ?? '',
                  style: AppTextStyles.blogTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'By ${post['author'] as String? ?? ''}',
                  style: AppTextStyles.blogAuthor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
