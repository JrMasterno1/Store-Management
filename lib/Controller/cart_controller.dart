
import 'package:price_management/Models/cart.dart';
import 'package:price_management/Models/product.dart';

class CartController {
  final _items = <CartItem> [];
  List<CartItem> get items => List.unmodifiable(_items);
  void addToCart(Product p, int num){
    final item = CartItem()
        ..product = p
        ..num = num;
    _items.add(item);
  }
  void deleteCart(CartItem cart){
    int index = _items.indexWhere((element) => element == cart);
    _items.remove(_items[index]);
  }
}