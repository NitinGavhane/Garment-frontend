import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/product_card.dart';
import '../../../core/widgets/animations.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../providers/product_provider.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  final Category? category;
  final String? searchQuery;
  final String? title;
  final double? maxPrice;
  final String? initialGender;

  const ProductListScreen({
    super.key,
    this.category,
    this.searchQuery,
    this.title,
    this.maxPrice,
    this.initialGender,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  static const double _kMaxPrice = 50000;
  String? _selectedSize;
  String? _selectedColor;
  late double _maxPrice;
  String _sortBy = 'Popular';

  List<Product> get _products {
    final productProvider = context.read<ProductProvider>();
    var filtered = widget.category != null
        ? productProvider.products
        : widget.searchQuery != null
            ? productProvider.searchProducts(widget.searchQuery!)
            : productProvider.products;

    if (_selectedSize != null) {
      filtered = filtered
          .where((p) => p.sizes.contains(_selectedSize))
          .toList();
    }

    if (_selectedColor != null) {
      filtered = filtered
          .where((p) => p.colors.contains(_selectedColor))
          .toList();
    }

    filtered = filtered.where((p) => p.price <= _maxPrice).toList();

    switch (_sortBy) {
      case 'Price: Low to High':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Newest':
        filtered.sort((a, b) => b.isNew ? 1 : -1);
        break;
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _maxPrice = widget.maxPrice ?? _kMaxPrice;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts(
        category: widget.category?.id,
        search: widget.searchQuery,
        gender: widget.initialGender,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? widget.category?.name ?? 'Products',
          style: AppTextStyles.title,
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.sort, size: 20),
            onPressed: () => _showSortSheet(context),
          ),
          IconButton(
            icon: const Icon(Iconsax.setting_4, size: 20),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: context.watch<ProductProvider>().isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_products.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md,
                      vertical: AppDimensions.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_products.length} products found',
                          style: AppTextStyles.bodySmall,
                        ),
                        Text(
                          'Sort: $_sortBy',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: _products.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Iconsax.box,
                                  size: 64, color: AppColors.textHint),
                              const SizedBox(height: 16),
                              Text(
                                'No products found',
                                style: AppTextStyles.subtitle,
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(AppDimensions.md),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.58,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            return StaggeredEntrance(
                              index: index,
                              child: ProductCard(
                                product: product,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailScreen(product: product),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  void _showSortSheet(BuildContext context) {
    final sorts = ['Popular', 'Newest', 'Rating', 'Price: Low to High', 'Price: High to Low'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sort by', style: AppTextStyles.title),
            const SizedBox(height: AppDimensions.md),
            ...sorts.map((s) => RadioListTile<String>(
                  value: s,
                  groupValue: _sortBy,
                  onChanged: (v) {
                    setState(() => _sortBy = v!);
                    Navigator.pop(ctx);
                  },
                  title: Text(s, style: AppTextStyles.body),
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                )),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: AppTextStyles.title),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedSize = null;
                        _selectedColor = null;
                        _maxPrice = widget.maxPrice ?? _kMaxPrice;
                      });
                      Navigator.pop(ctx);
                    },
                    child: Text('Clear All',
                        style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.secondary)),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.md),
              Text('Size', style: AppTextStyles.subtitle),
              const SizedBox(height: AppDimensions.sm),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL'].map((s) => FilterChip(
                  label: Text(s),
                  selected: _selectedSize == s,
                  onSelected: (v) {
                    setSheetState(() => _selectedSize = v ? s : null);
                    setState(() => _selectedSize = v ? s : null);
                  },
                )).toList(),
              ),
              const SizedBox(height: AppDimensions.md),
              Text('Max Price: ₹${_maxPrice.toStringAsFixed(0)}',
                  style: AppTextStyles.subtitle),
              Slider(
                value: _maxPrice,
                min: 0,
                max: _kMaxPrice,
                activeColor: AppColors.primary,
                onChanged: (v) {
                  setSheetState(() => _maxPrice = v);
                  setState(() => _maxPrice = v);
                },
              ),
              const SizedBox(height: AppDimensions.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.md),
            ],
          ),
        ),
      ),
    );
  }
}
