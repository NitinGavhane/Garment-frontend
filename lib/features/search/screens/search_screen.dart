import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/product_card.dart';
import '../../../models/product.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/category_provider.dart';
import '../../product/screens/product_detail_screen.dart';
import '../../product/screens/product_list_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Product> _results = [];
  bool _hasSearched = false;

  final _recentSearches = [
    'summer dress',
    'men t-shirt',
    'sneakers',
    'handbag',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final catProvider = context.read<CategoryProvider>();
      if (catProvider.categories.isEmpty) {
        catProvider.fetchCategories();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search(String query) {
    if (query.trim().isEmpty) return;
    setState(() => _hasSearched = true);
    context.read<ProductProvider>().fetchProducts(search: query).then((_) {
      if (mounted) {
        setState(() {
          _results = context.read<ProductProvider>().products;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search clothes, brands...',
            border: InputBorder.none,
            hintStyle: AppTextStyles.bodySmall,
          ),
          style: AppTextStyles.body,
          onSubmitted: _search,
          onChanged: (v) {
            if (v.isEmpty) {
              setState(() {
                _hasSearched = false;
                _results = [];
              });
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.search_normal, size: 20),
            onPressed: () => _search(_searchController.text),
          ),
        ],
      ),
      body: _hasSearched
          ? _results.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Iconsax.search_normal,
                          size: 64, color: AppColors.textHint),
                      const SizedBox(height: 16),
                      Text('No results found',
                          style: AppTextStyles.subtitle),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final product = _results[index];
                    return ProductCard(
                      product: product,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailScreen(product: product),
                        ),
                      ),
                    );
                  },
                )
          : Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Searches',
                      style: AppTextStyles.subtitle),
                  const SizedBox(height: AppDimensions.sm),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _recentSearches.map((s) => GestureDetector(
                      onTap: () {
                        _searchController.text = s;
                        _search(s);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(s,
                            style: AppTextStyles.bodySmall),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: AppDimensions.xl),
                  Text('Popular Categories',
                      style: AppTextStyles.subtitle),
                  const SizedBox(height: AppDimensions.sm),
                  ...categories.take(4).map((cat) {
                        final c = cat;
                        return ListTile(
                        leading: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: c.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(c.icon,
                              color: c.color, size: 20),
                        ),
                        title: Text(c.name,
                            style: AppTextStyles.body),
                        trailing: const Icon(Icons.chevron_right,
                            color: AppColors.textHint, size: 20),
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductListScreen(category: c),
                            ),
                          );
                        },
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
