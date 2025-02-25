import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sql_inventory_frontend/model/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:sql_inventory_frontend/utils/constants.dart';

class ProductListViewModel extends ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  dynamic headers = {"Accept": "*/*", "Access-Control-Allow-Origin": "*"};

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('${base_backend_url}products'),
        headers: headers);
    if (response.statusCode == 200) {
      // print(json.decode(response.body) as List);
      _products = (json.decode(response.body) as List).map((data) {
        return Product.fromJson(data);
      }).toList();
      notifyListeners();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
