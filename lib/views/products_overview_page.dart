import 'package:flutter/material.dart';
import 'package:shop_app/components/product_grid.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha loja'), actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: FilterOptions.Favorite,
              child: Text('Somente favoritos'),
            ),
            const PopupMenuItem(
              value: FilterOptions.All,
              child: Text('Todos'),
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
      ]),
      body: ProductGrid(_showFavoriteOnly),
    );
  }
}
