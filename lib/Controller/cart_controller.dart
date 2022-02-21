
import 'dart:convert';

import 'package:price_management/Models/cart.dart';
import 'package:price_management/Models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController {
  final _items = <CartItem> [];
  List<CartItem> get items => _items;
  late SharedPreferences pref;
  static final CartController _instance = CartController._internal();
  CartController._internal();
  factory CartController(){
    return _instance;
  }
  Future readPref() async {
    pref = await SharedPreferences.getInstance();
    String? content = pref.getString('carts');
     if(content != null) {
       List myMap = jsonDecode(content);
       myMap.forEach((element) {
         CartItem c = CartItem.fromJson(element);
         int index = _items.indexWhere((element) => element.product!.productName == c.product!.productName);
         if(index == -1){
           _items.add(c);
         }
       });
     }
  }
  Future savePref() async {
    String json = '[';
    _items.forEach((element) {
      json += jsonEncode(element.toJson()) + ',';
    });
    json = json.substring(0, json.length - 1) + ']';

    pref.setString('carts', json);
  }
  Future clearPref() async {
    pref.clear();
    _items.clear();
  }
  void addToCart(Product p, int num){
    for(var i in _items){
      if(i.product!.productName == p.productName){
        i.num += num;
        return;
      }
    }
    final item = CartItem()
        ..product = p
        ..num = num;
    _items.add(item);
    savePref().then((value) => print("Saved pref"));
  }
  void deleteCart(int index){
    _items.remove(_items[index]);
  }
}