import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.PRODUCT_FORM,
                    arguments: product,
                  );
                },
              ),
              IconButton(
                color: Theme.of(context).errorColor,
                icon: Icon(Icons.delete),
                onPressed: () {
                    Provider.of<Products>(context, listen: false).deleteProduct(product.id);
                }
              )
            ],
          )),
    );
  }
}
