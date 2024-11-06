import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/utils/constants.dart';

class OrderList with ChangeNotifier {
  final List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    _items.clear();

    final response =
        await http.get(Uri.parse('${Constants.ORDER_BASE_URL}.json'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((OrderId, orderData) {
      _items.add(
        Order(
          id: OrderId,
          date: DateTime.parse(orderData['date']),
          total: orderData['total'],
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              productId: item['productId'],
              name: item['title'],
              quantity: item['quantity'],
              price: item['price'],
            );
          }).toList(),
        ),
      );
    });
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      Uri.parse('${Constants.ORDER_BASE_URL}.json'),
      body: jsonEncode(
        {
          'total': cart.totalAmount,
          'date': DateTime.now().toIso8601String(),
          'products': cart.items.values
              .map((cartItem) => {
                    'id': cartItem.id,
                    'productId': cartItem.productId,
                    'title': cartItem.name,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList(),
        },
      ),
    );
    final id = jsonDecode(response.body)['name'];
    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount.toString(),
        products: cart.items.values.toList(),
        date: date,
      ),
    );
    notifyListeners();
  }
}
