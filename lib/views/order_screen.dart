import 'package:flutter/material.dart';
import 'package:shop/widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      body: Container(
        child: Text('Tela Simples'),
      ),
      drawer: AppDrawer(),
    );
  }
}
