
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:price_management/Models/product.dart';

class StorageController {
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
    print(pros[0]);
    this.uid = uid;

    pros.forEach((element) {
      if(element.data().length != 0){
        print(element.data().length);
        Product p = Product.fromJson(element.data());
        int i = _products.indexWhere((cur) => cur.productName == p.productName);
        if(i == -1){
          _products.add(p);
        }
      }
    });
    // String prods = document!.get('products');
    // if(prods.isNotEmpty){
    //   List proMap = jsonDecode(prods);
    //   proMap.forEach((element) {
    //
    //   });
    // }
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
    CollectionReference collection = db.collection('store').doc(uid).collection('products');
    QuerySnapshot snapshot = await collection.get();
    List<QueryDocumentSnapshot> list = snapshot.docs;

    int index = list.indexWhere((element){
      Map<String, dynamic> json = element.get()
    });
    DocumentSnapshot document = list[index];
    final id = document.id;
    collection.doc(id).update({'products' : json });
  }
  void clearData(){
    _products.clear();
  }
}