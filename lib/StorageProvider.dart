
import 'package:flutter/material.dart';
import 'package:price_management/Controller/cart_controller.dart';
import 'package:price_management/Controller/storage_controlller.dart';

class CartProvider extends InheritedWidget{
  final _controller = CartController();
  CartProvider({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);
  static CartController of(BuildContext context){
    if(context.dependOnInheritedWidgetOfExactType<CartProvider>() == null){
      print("This context is null");
    }
    final CartProvider result = context.dependOnInheritedWidgetOfExactType<CartProvider>()!;
    assert(result != null, 'No CartProvider found in context');
    return result._controller;
  }


  @override
  bool updateShouldNotify(CartProvider oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }

}
class StorageProvider extends InheritedWidget{
  final _controller = StorageController();
  StorageProvider({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);
  static StorageController of(BuildContext context){
    final StorageProvider result = context.dependOnInheritedWidgetOfExactType<StorageProvider>()!;
    assert(result != null, 'No StorageProvider found in context');
    return result._controller;
  }


  @override
  bool updateShouldNotify(StorageProvider oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }

}

