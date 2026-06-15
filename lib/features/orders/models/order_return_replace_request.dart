enum ReturnReplaceType {
  returnRequest,
  replaceRequest,
}

enum ReturnReplaceStatus {
  submitted,
  approved,
  rejected,
  received,
  processed,
}


class OrderReturnReplaceRequestItem {
  final String orderItemId;
  final int quantity;

  const OrderReturnReplaceRequestItem({
    required this.orderItemId,
    required this.quantity,
  });
}

class OrderReturnReplaceRequest {
  final String id;
  final ReturnReplaceType type;
  final ReturnReplaceStatus status;
  final List<OrderReturnReplaceRequestItem> items;
  final String reason;
  final DateTime createdAt;

  const OrderReturnReplaceRequest({
    required this.id,
    required this.type,
    required this.status,
    required this.items,
    required this.reason,
    required this.createdAt,
  });

  String get label {
    switch (type) {
      case ReturnReplaceType.returnRequest:
        return 'Return';
      case ReturnReplaceType.replaceRequest:
        return 'Replace';
    }
  }

  String get statusLabel {
    switch (status) {
      case ReturnReplaceStatus.submitted:
        return 'Submitted';
      case ReturnReplaceStatus.approved:
        return 'Approved';
      case ReturnReplaceStatus.rejected:
        return 'Rejected';
      case ReturnReplaceStatus.received:
        return 'Received';
      case ReturnReplaceStatus.processed:
        return 'Processed';
    }
  }
}

