import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/order_list.dart';
import 'package:shop_app/models/product_list.dart';
import 'package:shop_app/utils/app_routes.dart';
import 'package:shop_app/views/auth_page.dart';
import 'package:shop_app/views/orders_page.dart';
import 'package:shop_app/views/product_form_page.dart';
import 'package:shop_app/views/products_overview_page.dart';
import 'package:shop_app/views/products_detail_page.dart';
import 'package:shop_app/models/cart_page.dart';
import 'package:shop_app/views/products_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          hintColor: Colors.redAccent,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Lato',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.purple,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),
            elevation: 0,
            centerTitle: true,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.purple,
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          chipTheme: const ChipThemeData(
            backgroundColor: Colors.purple,
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        routes: {
          AppRoutes.AUTH: (context) => const AuthPage(),
          AppRoutes.HOME: (context) => const ProductsOverviewPage(),
          AppRoutes.PRODUCT_DETAIL: (context) => const ProductDetailPage(),
          AppRoutes.CART: (context) => const CartPage(),
          AppRoutes.ORDERS: (context) => const OrdersPage(),
          AppRoutes.PRODUCTS: (context) => const ProductsPage(),
          AppRoutes.PRODUCT_FORM: (context) => const ProductFormPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
