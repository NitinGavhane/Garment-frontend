# TODO - Order Return & Replace Feature

## Plan (approved)
- Add return/replace request models
- Extend `Order` to include requests
- Add Return/Replace actions to Order Detail UI (only when order status is Delivered)
- (Optional) show request badges in order list
- Update mock data for testing

## Steps to complete
- [ ] Inspect remaining order-related files (order list/card, tracking timeline) for UI patterns
- [x] Implement new model: `order_return_replace_request.dart`
- [x] Extend `Order` model to hold requests + add helper for eligibility
- [ ] Implement UI actions in `OrderDetailScreen` (buttons + modal/bottom sheet + form)
- [ ] (If applicable) update order list/card UI to show request badge
- [x] Update `mock_data.dart` with sample return/replace request
- [ ] Run `flutter analyze`
- [ ] Run app / hot restart and verify flows

