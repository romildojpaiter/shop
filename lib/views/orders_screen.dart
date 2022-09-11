import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_widget.dart';

class OrdersScreen extends StatelessWidget {
  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<Orders>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).loadOrders(),
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Text('Ocorreu um erro');
          } else {
            return Consumer<Orders>(
              builder: (ctx, orders, child) {
                print(orders);
                return RefreshIndicator(
                  onRefresh: () => _refreshOrders(context),
                  child: orders.items.length > 0
                      ? ListView.builder(
                          itemCount: orders.itemsCount,
                          itemBuilder: (context, index) =>
                              OrderWidget(order: orders.items[index]),
                        )
                      : Center(
                          child: const Text(
                              'Você ainda não realizou nenhum pedido.')),
                );
              },
            );
          }
        },
      ),
    );
  }
}
