import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/api_client.dart';
import '../../../providers/auth_provider.dart';
import '../models/order_return_replace_form.dart';
import '../models/order_return_replace_request.dart';
import '../../../models/order.dart';

class OrderReturnReplaceSheet extends StatefulWidget {
  final Order order;
  final ReturnReplaceType type;

  const OrderReturnReplaceSheet({
    super.key,
    required this.order,
    required this.type,
  });

  @override
  State<OrderReturnReplaceSheet> createState() => _OrderReturnReplaceSheetState();
}

class _OrderReturnReplaceSheetState extends State<OrderReturnReplaceSheet> {
  final _formKey = GlobalKey<OrderReturnReplaceFormState>();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OrderReturnReplaceForm(
            key: _formKey,
            order: widget.order,
            type: widget.type,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_rounded),
              label: Text(_isSubmitting ? 'Submitting...' : 'Submit request'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final state = _formKey.currentState;
    final error = state?.validate();
    if (error != null && error.isNotEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final req = state!.buildRequest();
      final endpoint = widget.type == ReturnReplaceType.returnRequest
          ? '/api/v1/orders/${widget.order.id}/return'
          : '/api/v1/orders/${widget.order.id}/replace';

      await ApiClient.post(endpoint, body: {
        'reason': req.reason,
        if (req.items.isNotEmpty)
          'items': req.items.map((i) => {
            'order_item_id': i.orderItemId,
            'quantity': i.quantity,
          }).toList(),
      });

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${req.label} request submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit request. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
