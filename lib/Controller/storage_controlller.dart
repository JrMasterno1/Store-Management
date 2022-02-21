
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:price_management/Models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageController {
  final _products = <Product>[];
  String path = '';


  Future readPref() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // String? content = pref.getString('products');
    // if(content != null){
    //   List myMap = jsonDecode(content);
    //   myMap.forEach((element) {
    //     Product p = Product.fromJson(element);
    //     _products.add(p);
    //   });
    // }

    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference collection = db.collection('store');
    QuerySnapshot snapshot = await collection.get();
    List<QueryDocumentSnapshot> list = snapshot.docs;
    DocumentSnapshot document = list[0];
    String prods = document.get('products');
    if(prods.isNotEmpty){
      List myMap = jsonDecode(prods);
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
    int index = _products.indexWhere((element) => element == p);
    _products.remove(_products[index]);
    saveData();
  }
  void editProduct(Product old, Product new_p){
    int index = _products.indexWhere((element) => element == old);
    _products[index] = new_p;
    saveData();
  }
  Future saveData() async {
    String json = '[';
    _products.forEach((element) {
      json += jsonEncode(element.toJson()) + ',';
    });
    json = json.substring(0, json.length - 1) + ']';
    print(json);

    // SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.setString('products', json);

    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference collection = db.collection('store');
    QuerySnapshot snapshot = await collection.get();
    List<QueryDocumentSnapshot> list = snapshot.docs;
    DocumentSnapshot document = list[0];
    final id = document.id;
    collection.doc(id).update({'products' : json });
  }
}