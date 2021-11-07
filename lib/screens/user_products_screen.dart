import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName,
                    arguments: {'edit': false});
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: productData.items.length,
            itemBuilder: (_, index) => Column(
                  children: [
                    UserProductItem(
                        id: productData.items[index].id,
                        title: productData.items[index].title,
                        imageUrl: productData.items[index].imageUrl),
                    Divider()
                  ],
                )),
      ),
    );
  }
}
