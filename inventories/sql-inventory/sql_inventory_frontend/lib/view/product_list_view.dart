import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sql_inventory_frontend/utils/constants.dart';
import 'package:sql_inventory_frontend/view/add_product_view.dart';
import 'package:sql_inventory_frontend/view/update_product_view.dart';
import 'package:sql_inventory_frontend/view_model/product_list_view_model.dart';
import 'package:http/http.dart' as http;

class ProductListView extends StatefulWidget {
  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   final productListProvider =
  //       Provider.of<ProductListViewModel>(context, listen: false);
  //   productListProvider.fetchProducts();
  // }

  @override
  Widget build(BuildContext context) {
    final productListProvider =
        Provider.of<ProductListViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Inventory'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProductScreen()));
              },
              icon: Icon(Icons.add)),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: FutureBuilder(
        future: productListProvider.fetchProducts(),
        builder: (context, AsyncSnapshot snapshot) {
          print(!snapshot.hasData);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<ProductListViewModel>(
                builder: (context, value, child) {
              return DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: value.products.map((product) {
                  return DataRow(
                    onLongPress: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UpdateProductScreen(product: product))),
                    cells: [
                      DataCell(Text(product.name)),
                      DataCell(Text('\$${product.price.toString()}')),
                      DataCell(Text(product.quantity.toString())),
                      DataCell(
                        GestureDetector(
                            onTap: () async {
                              final response = await http.delete(
                                Uri.parse(
                                    '${base_backend_url}products/${product.id}'),
                              );

                              if (response.statusCode == 200) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        '${product.name} item deleted successfully.')));
                                value.fetchProducts();
                              } else {
                                // Handle error
                                print('Error: ${response.statusCode}');
                              }
                            },
                            child: const Icon(Icons.delete)),
                      ),
                    ],
                  );
                }).toList(),
              );
            });
          }
        },
      ),
    );
  }
}
