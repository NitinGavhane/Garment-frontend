import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/category.dart' as models;
import '../../../providers/category_provider.dart';
import '../../product/screens/product_list_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CategoryProvider>();
      if (provider.categories.isEmpty) {
        provider.fetchCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final categories = categoryProvider.categories;

    if (categoryProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Categories')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (categoryProvider.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Categories')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: AppColors.textHint),
              const SizedBox(height: 16),
              Text('Failed to load categories',
                  style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textHint)),
              const SizedBox(height: 8),
              Text(categoryProvider.error!,
                  style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => categoryProvider.fetchCategories(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final men = categories.where((c) => c.gender == 'men').toList();
    final women = categories.where((c) => c.gender == 'women').toList();
    final kids = categories.where((c) => c.gender == 'kids').toList();
    final unisex = categories.where((c) => c.gender == 'unisex').toList();
    final other = categories.where((c) => c.gender.isEmpty).toList();

    final sections = <_GenderSection>[];
    if (women.isNotEmpty) sections.add(_GenderSection('WOMEN', women, AppColors.categoryWomen));
    if (men.isNotEmpty) sections.add(_GenderSection('MEN', men, AppColors.categoryMen));
    if (kids.isNotEmpty) sections.add(_GenderSection('KIDS', kids, AppColors.categoryKids));
    if (unisex.isNotEmpty) sections.add(_GenderSection('UNISEX', unisex, AppColors.categoryAccessories));
    if (other.isNotEmpty) sections.add(_GenderSection('OTHER', other, AppColors.textHint));

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final section = sections[index];
          return _CategorySectionCard(
            section: section,
            onCategoryTap: (cat) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductListScreen(category: cat),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GenderSection {
  final String title;
  final List<models.Category> categories;
  final Color color;
  _GenderSection(this.title, this.categories, this.color);
}

class _CategorySectionCard extends StatelessWidget {
  final _GenderSection section;
  final void Function(models.Category)? onCategoryTap;

  const _CategorySectionCard({required this.section, this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: section.color.withValues(alpha: 0.08),
          child: Text(
            section.title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: section.color,
              letterSpacing: 1,
            ),
          ),
        ),
        ...section.categories.map((cat) => ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: section.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(cat.icon, color: section.color, size: 20),
          ),
          title: Text(cat.name,
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.chevron_right, size: 20,
              color: AppColors.textHint),
          onTap: () => onCategoryTap?.call(cat),
        )),
      ],
    );
  }
}
