import 'package:flutter/material.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/cart_page.dart';
import 'package:shop_app/views/products_overview_page.dart';
import 'package:shop_app/views/products_detail_page.dart';
import 'package:shop_app/utils/app_routes.dart';
import 'package:shop_app/models/product_list.dart';
import 'package:provider/provider.dart';

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
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.purple,
          hintColor: Colors.redAccent,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Lato',
        ),
        home: const ProductsOverviewPage(),
        routes: {
          AppRoutes.PRODUCT_DETAIL: (context) => const ProductDetailPage(),
          AppRoutes.CART: (context) => const CartPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
