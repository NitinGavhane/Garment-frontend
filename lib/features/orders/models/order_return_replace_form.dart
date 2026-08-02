import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/order_api_service.dart';
import '../../../models/order.dart';
import 'order_return_replace_request.dart';

class OrderReturnReplaceForm extends StatefulWidget {
  final Order order;
  final ReturnReplaceType type;


  const OrderReturnReplaceForm({
    super.key,
    required this.order,
    required this.type,
  });

  @override
State<OrderReturnReplaceForm> createState() => OrderReturnReplaceFormState();
}

class OrderReturnReplaceFormState extends State<OrderReturnReplaceForm> {


  late final List<_SelectableItem> _items;

  final _reasonController = TextEditingController();
  final List<String> _evidence = [];
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _items = widget.order.items
        .map(
          (e) => _SelectableItem(
            orderItem: e,
            selectedQty: 0,
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.type == ReturnReplaceType.returnRequest
              ? 'Return request'
              : 'Replace request',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        const Text('Select item(s) and quantity'),
        const SizedBox(height: 8),
        ..._items.map((si) {
          final item = si.orderItem;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.title,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 6),
                  Text(
                    'Size: ${item.size} • Color: ${item.color}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: si.selectedQty <= 0
                            ? null
                            : () => setState(() => si.selectedQty--),
                      ),
                      Text(
                        '${si.selectedQty}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: si.selectedQty >= item.quantity
                            ? null
                            : () =>
                                setState(() => si.selectedQty++),
                      ),
                      const Spacer(),
                      Text(
                        'Max ${item.quantity}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        const Text('Reason'),
        const SizedBox(height: 8),
        TextField(
          controller: _reasonController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Describe the issue (e.g., damaged/defective/wrong size)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Photos (optional)'),
        const SizedBox(height: 8),
        if (_evidence.isNotEmpty) ...[
          SizedBox(
            height: 76,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _evidence.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      _evidence[i],
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () => setState(() => _evidence.removeAt(i)),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        OutlinedButton.icon(
          onPressed: _uploading ? null : _pickAndUpload,
          icon: _uploading
              ? const SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add_a_photo_outlined, size: 18),
          label: Text(_uploading ? 'Uploading…' : 'Add photo'),
        ),
      ],
    );
  }

  Future<void> _pickAndUpload() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    setState(() => _uploading = true);
    try {
      final url = await OrderApiService.uploadReturnEvidence(
        fileBytes: bytes,
        fileName: picked.name,
        contentType: picked.mimeType ?? 'image/jpeg',
      );
      if (!mounted) return;
      setState(() => _evidence.add(url));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not upload that photo. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  bool get _hasSelection =>
      _items.any((e) => e.selectedQty > 0);

  String? validate() {
    if (!_hasSelection) return 'Select at least one item.';
    if (_reasonController.text.trim().isEmpty) {
      return 'Reason is required.';
    }
    return null;
  }

  OrderReturnReplaceRequest buildRequest() {
    final selected = _items
        .where((e) => e.selectedQty > 0)
        .map(
          (e) => OrderReturnReplaceRequestItem(
            orderItemId: e.orderItem.id,
            quantity: e.selectedQty,
          ),
        )
        .toList();

    return OrderReturnReplaceRequest(
      id: 'rr_${DateTime.now().millisecondsSinceEpoch}',
      type: widget.type,
      status: ReturnReplaceStatus.submitted,
      items: selected,
      reason: _reasonController.text.trim(),
      evidence: List.of(_evidence),
      createdAt: DateTime.now(),
    );
  }
}

class _SelectableItem {
  final OrderItem orderItem;
  int selectedQty;

  _SelectableItem({
    required this.orderItem,
    required this.selectedQty,
  });
}

