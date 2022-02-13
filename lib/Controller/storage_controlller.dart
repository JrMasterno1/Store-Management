
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:price_management/Models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageController {
  final _products = <Product>[];
  String path = '';
  Future readPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? content = pref.getString('products');
    if(content != null){
      List myMap = jsonDecode(content);
      myMap.forEach((element) {
        Product p = Product.fromJson(element);
        _products.add(p);
      });
    }
  }
  List<Product> get products => List.unmodifiable(_products);
  void addNewProduct(String name, double price){
    final pro = Product()
        ..productName = name
        ..price = price;
    _products.add(pro);
    saveData();
  }
  void deleteProduct(Product p){
    _products.remove(p);
    saveData();
  }
  void editProduct(int index, Product p){
    _products[index] = p;
    saveData();
  }
  Future saveData() async {
    String json = '[';
    _products.forEach((element) {
      json += jsonEncode(element.toJson()) + ',';
    });
    json = json.substring(0, json.length - 1) + ']';
    print(json);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('products', json);
  }
}