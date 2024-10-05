import 'package:shop_app/models/cart_item.dart';

class Order {
  final String id;
  final String total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
  });
}
