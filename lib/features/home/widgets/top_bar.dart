import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/location_provider.dart';
import '../../../providers/product_provider.dart';

class TopBar extends StatelessWidget {
  final int cartCount;
  final ValueChanged<String>? onSearchSubmit;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onAddressTap;

  const TopBar({
    super.key,
    this.cartCount = 0,
    this.onSearchSubmit,
    this.onWishlistTap,
    this.onCartTap,
    this.onNotificationTap,
    this.onProfileTap,
    this.onAddressTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: Column(
        children: [
          _AddressBar(onTap: onAddressTap),
          _SearchHeader(
            cartCount: cartCount,
            onSearchSubmit: onSearchSubmit,
            onCartTap: onCartTap,
            onWishlistTap: onWishlistTap,
            onProfileTap: onProfileTap,
          ),
        ],
      ),
    );
  }
}

class _AddressBar extends StatelessWidget {
  final VoidCallback? onTap;

  const _AddressBar({this.onTap});

  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationProvider>();

    final locText = location.isLoading
        ? 'Detecting location...'
        : location.address.isNotEmpty
            ? location.address
            : 'Your location';
    return Container(
      color: AppColors.primaryDark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 14, color: AppColors.brandGoldLight),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              locText,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.brandGoldLight,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchHeader extends StatefulWidget {
  final int cartCount;
  final ValueChanged<String>? onSearchSubmit;
  final VoidCallback? onCartTap;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onProfileTap;

  const _SearchHeader({
    this.cartCount = 0,
    this.onSearchSubmit,
    this.onCartTap,
    this.onWishlistTap,
    this.onProfileTap,
  });

  @override
  State<_SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<_SearchHeader> {
  bool _isSearchActive = false;
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }
    final productProvider = context.read<ProductProvider>();
    final results = productProvider.searchProducts(query);
    final titles = results
        .map((p) => p.title)
        .where((t) => t.toLowerCase().contains(query))
        .toSet()
        .take(6)
        .toList();
    setState(() => _suggestions = titles);
  }

  void _activateSearch() {
    setState(() => _isSearchActive = true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  void _deactivateSearch() {
    setState(() {
      _isSearchActive = false;
      _suggestions = [];
      _searchController.clear();
    });
    _focusNode.unfocus();
  }

  void _submitSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      widget.onSearchSubmit?.call(query);
      _deactivateSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 4, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (!_isSearchActive) ...[
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/logo-icon.png',
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'DRISTHI FASHIONS',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brandGold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'Fashion That Reflects Your Personality',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 7,
                        fontWeight: FontWeight.w500,
                        color: AppColors.brandGold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: _isSearchActive
                    ? Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.brandGoldLight.withValues(alpha: 0.4)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.search, size: 14, color: AppColors.brandGoldLight),
                            const SizedBox(width: 4),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                focusNode: _focusNode,
                                cursorColor: AppColors.brandGoldLight,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppColors.white,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search Dristhi Fashions…',
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                  border: InputBorder.none,
                                  filled: false,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                textInputAction: TextInputAction.search,
                                onSubmitted: (_) {
                                  _submitSearch();
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: _deactivateSearch,
                              child: const Icon(Icons.close, size: 14, color: AppColors.brandGoldLight),
                            ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: _activateSearch,
                        child: Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: AppColors.brandGoldLight.withValues(alpha: 0.4)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const Icon(Icons.search, size: 14, color: AppColors.brandGoldLight),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Search Dristhi Fashions…',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 2),
              _IconBtn(Icons.favorite_outline, AppColors.brandGoldLight, widget.onWishlistTap),
              _CartBtn(cartCount: widget.cartCount, onTap: widget.onCartTap),
              _IconBtn(Icons.person_outline, AppColors.brandGoldLight, widget.onProfileTap),
            ],
          ),
          if (_isSearchActive && _suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.brandGoldLight.withValues(alpha: 0.3)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: _suggestions.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: AppColors.brandGoldLight.withValues(alpha: 0.15),
                  ),
                  itemBuilder: (context, index) {
                    final title = _suggestions[index];
                    return InkWell(
                      onTap: () {
                        _searchController.text = title;
                        _submitSearch();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.search, size: 14, color: AppColors.brandGoldLight),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                title,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: AppColors.brandGoldLight,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _IconBtn(this.icon, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

class _CartBtn extends StatelessWidget {
  final int cartCount;
  final VoidCallback? onTap;

  const _CartBtn({this.cartCount = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Stack(
          children: [
            const Icon(Icons.shopping_bag_outlined, size: 20, color: AppColors.brandGoldLight),
            if (cartCount > 0)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.festiveGold,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$cartCount',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
