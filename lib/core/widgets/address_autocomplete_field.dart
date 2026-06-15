import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../services/place_autocomplete_service.dart';

class AddressAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final Function(PlaceSuggestion)? onSelected;

  const AddressAutocompleteField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText = '',
    this.prefixIcon,
    this.validator,
    this.onSelected,
  });

  @override
  State<AddressAutocompleteField> createState() => _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  Timer? _debounce;
  List<PlaceSuggestion> _suggestions = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    _debounce?.cancel();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _hideDropdown();
    }
  }

  void _onTextChanged() {
    _debounce?.cancel();
    final text = widget.controller.text;
    if (text.length < 3) {
      _hideDropdown();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () => _fetchSuggestions(text));
  }

  Future<void> _fetchSuggestions(String query) async {
    setState(() => _loading = true);
    final results = await PlaceAutocompleteService.suggest(query);
    if (!mounted) return;
    setState(() {
      _suggestions = results;
      _loading = false;
    });
    if (results.isNotEmpty) {
      _showOverlay();
    } else {
      _hideDropdown();
    }
  }

  void _showOverlay() {
    _removeOverlay();
    if (!_focusNode.hasFocus) return;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: widget.controller.text.isNotEmpty ? MediaQuery.of(context).size.width - 32 : 0,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 50),
          child: _buildDropdown(),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _hideDropdown() {
    _removeOverlay();
  }

  void _selectSuggestion(PlaceSuggestion suggestion) {
    widget.controller.text = suggestion.street.isNotEmpty ? suggestion.street : suggestion.displayName;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.controller.text.length),
    );
    widget.onSelected?.call(suggestion);
    _hideDropdown();
    _focusNode.unfocus();
  }

  Widget _buildDropdown() {
    if (_suggestions.isEmpty && !_loading) return const SizedBox.shrink();
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      shadowColor: Colors.black26,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 240),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: _loading
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                    SizedBox(width: 12),
                    Text('Searching...', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                  ],
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.divider.withValues(alpha: 0.5)),
                itemBuilder: (context, index) {
                  final s = _suggestions[index];
                  return InkWell(
                    onTap: () => _selectSuggestion(s),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (s.street.isNotEmpty)
                            Text(
                              s.street,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 2),
                          Text(
                            [s.city, s.state, s.pincode].where((e) => e.isNotEmpty).join(', '),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        validator: widget.validator,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: _loading
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : null,
          counterText: '',
        ),
      ),
    );
  }
}
