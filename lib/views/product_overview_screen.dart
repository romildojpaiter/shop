import 'package:flutter/material.dart';
import 'package:shop/widgets/product_grid.dart';

enum FavoriteOptions { Favorite, All }

class ProductOverviewScreen extends StatefulWidget {
  ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  //
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minha Loja',
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FavoriteOptions selectedValue) {
              setState(() {
                if (FavoriteOptions.Favorite == selectedValue) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente Favoritos'),
                value: FavoriteOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FavoriteOptions.All,
              ),
            ],
          ),
        ],
      ),
      body: ProductGrid(
        showFavoriteOnly: _showFavoriteOnly,
      ),
    );
  }
}
