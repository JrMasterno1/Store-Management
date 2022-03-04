
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:price_management/Models/product.dart';

class StorageController with ChangeNotifier {
  final _products = <Product>[];
  String uid = '';
  static final StorageController _instance = StorageController._internal();

  StorageController._internal();
  factory StorageController(){
    return _instance;
  }

  void readPref(String uid, List pros){
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // String? content = pref.getString('products');
    // if(content != null){
    //   List myMap = jsonDecode(content);
    //   myMap.forEach((element) {
    //     Product p = Product.fromJson(element);
    //     _products.add(p);
    //   });
    // }
    this.uid = uid;
    if(pros.isNotEmpty){
      pros.forEach((element) {
        if(element.data().length != 0){
          print(element.data());
          Product p = Product.fromJson(element.data());
          p.id = int.tryParse(element.id)!;
          _products.add(p);
          // int i = _products.indexWhere((cur) => cur.productName == p.productName);
          // if(i == -1){
          // }
        }
      });
    }
    // String prods = document!.get('products');
    // if(prods.isNotEmpty){
    //   List proMap = jsonDecode(prods);
    //   proMap.forEach((element) {
    //
    //   });
    // }
  }
  List<Product> get products => List.unmodifiable(_products);
  void addNewProduct(String name, double price) {
    final pro = Product()
        ..productName = name
        ..price = price;
    if(_products.isEmpty){
      pro.id = 0;
    }
    else {
        pro.id = (_products[products.length - 1].id) + 1;
    }
    _products.add(pro);
    saveData(pro.id, pro);
  }
  Future deleteProduct(Product p) async {
    int index = _products.indexWhere((element) => element == p);
    _products.remove(_products[index]);
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference collection = db.collection('store').doc(uid).collection('products');
    await collection.doc(p.id.toString()).delete();
    notifyListeners();
  }
  void editProduct(Product old, Product new_p){
    int index = _products.indexWhere((element) => element == old);
    _products[index] = new_p;
    saveData(new_p.id, new_p);
  }
  Future saveData(int proID, Product p) async {
    // String json = '[';
    // _products.forEach((element) {
    //   json += jsonEncode(element.toJson()) + ',';
    // });
    // json = json.substring(0, json.length - 1) + ']';
    // print(json);

    // SharedPreferences pref = await SharedPreferences.getInstance();
    // pref.setString('products', json);
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference collection = db.collection('store').doc(uid).collection('products');
    await collection.doc(proID.toString()).set(p.toJson());
    notifyListeners();
  }
  void clearData(){
    _products.clear();
    notifyListeners();
  }
}