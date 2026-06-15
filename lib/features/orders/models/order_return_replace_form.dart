import 'package:flutter/material.dart';

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
      ],
    );
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

