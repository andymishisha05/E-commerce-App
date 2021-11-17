import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '\orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Order"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text("there an error "),
                );
              } else {
                return Consumer<Orders>(
                  builder: (context, ordersData, child) {
                    return ListView.builder(
                        itemCount: ordersData.orders.length,
                        itemBuilder: (ctx, i) =>
                            OrderItem(ordersData.orders[i]));
                  },
                );
              }
            }
          },
        ));
  }
}
