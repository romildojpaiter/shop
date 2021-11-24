import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context)?.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              print('teste');
            },
            child: Text('+'),
          )
        ],
      ),
    );
  }
}
