import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sql_inventory_frontend/view/product_list_view.dart';
import 'package:sql_inventory_frontend/view_model/product_list_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductListViewModel()),
      ],
      child: MaterialApp(
        title: 'Product Inventory App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ProductListView(),
      ),
    );
  }
}
