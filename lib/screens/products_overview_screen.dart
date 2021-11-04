import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOpition { Favorite, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorie = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOpition selected) {
              print(selected);
              setState(() {
                if (selected == FilterOpition.Favorite) {
                  _showOnlyFavorie = true;
                } else {
                  _showOnlyFavorie = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favorite"),
                value: FilterOpition.Favorite,
              ),
              PopupMenuItem(child: Text("Show All"), value: FilterOpition.All),
            ],
          ),
          Consumer<Cart>(
            builder: (context, value, child) => Badge(
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
                value: value.itemCount.toString()),
          )
        ],
      ),
      body: ProductsGrid(_showOnlyFavorie),
      drawer: AppDrawer(),
    );
  }
}
