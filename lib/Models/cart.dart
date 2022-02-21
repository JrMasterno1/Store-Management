
import 'dart:convert';

import 'package:price_management/Models/product.dart';

class CartItem {
  Product? product;
  late int num;
  CartItem({this.product,this.num = 0});
  double get price => product!.price*num;

  CartItem.fromJson(Map<String, dynamic> json) :
    this.product = Product.fromJson(json['product']) ,
    this.num = json['num'];

  Map<String, dynamic> toJson() {
    return {
      'product' : product!.toJson(),
      'num' : num
    };
  }
}


