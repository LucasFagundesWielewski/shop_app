import 'package:flutter/material.dart';
import 'package:shop_app/components/app_drawer.dart';
import 'package:shop_app/components/product_grid.dart';
import 'package:shop_app/models/cart.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product_list.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({super.key});

  @override
  _ProductsOverviewPageState createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false)
        .loadProducts()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minha loja',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (_) => [
              const PopupMenuItem<FilterOptions>(
                value: FilterOptions.Favorite,
                child: Text('Somente favoritos',
                    style: TextStyle(color: Colors.black)),
              ),
              const PopupMenuItem<FilterOptions>(
                value: FilterOptions.All,
                child: Text('Todos', style: TextStyle(color: Colors.black)),
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/cart');
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            builder: (ctx, cart, child) => Badge(
              label: Text(cart.itemCount.toString()),
              child: child!,
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavoriteOnly),
      drawer: const AppDrawer(),
    );
  }
}
