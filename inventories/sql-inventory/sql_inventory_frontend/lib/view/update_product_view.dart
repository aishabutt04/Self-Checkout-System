import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sql_inventory_frontend/model/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:sql_inventory_frontend/utils/constants.dart';
import 'package:sql_inventory_frontend/view_model/product_list_view_model.dart';

class UpdateProductScreen extends StatefulWidget {
  final Product product;

  UpdateProductScreen({required this.product});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.product.name;
    priceController.text = widget.product.price.toString();
    quantityController.text = widget.product.quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    final productListProvider =
        Provider.of<ProductListViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Product ${widget.product.name}'),
        elevation: 0,
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
                final updatedProduct = {
                  'name': nameController.text,
                  'price': double.parse(priceController.text),
                  'quantity': int.parse(quantityController.text),
                };

                final response = await http.put(
                  Uri.parse('${base_backend_url}products/${widget.product.id}'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode(updatedProduct),
                );

                if (response.statusCode == 200) {
                  widget.product.name = nameController.text;
                  widget.product.price = double.parse(priceController.text);
                  widget.product.quantity = int.parse(quantityController.text);
                  productListProvider.fetchProducts();
                  Navigator.pop(context);
                } else {
                  // Handle error
                  print('Error: ${response.statusCode}');
                }
              },
              child: Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
