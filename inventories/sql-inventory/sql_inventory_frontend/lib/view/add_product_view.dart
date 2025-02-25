import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sql_inventory_frontend/utils/constants.dart';
import 'package:sql_inventory_frontend/view_model/product_list_view_model.dart';

class AddProductScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final productListProvider =
        Provider.of<ProductListViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Price'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Quantity'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final newProduct = {
                  'name': nameController.text,
                  'price': double.parse(priceController.text),
                  'quantity': int.parse(quantityController.text),
                };

                final response = await http.post(
                  Uri.parse('${base_backend_url}products'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode(newProduct),
                );

                if (response.statusCode == 200) {
                  productListProvider.fetchProducts();
                  Navigator.pop(context);
                } else {
                  // Handle error
                  print('Error: ${response.statusCode}');
                }
              },
              child: Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
