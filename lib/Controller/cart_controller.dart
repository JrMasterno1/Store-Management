
import 'package:price_management/Models/cart.dart';
import 'package:price_management/Models/product.dart';

class CartController {
  final _items = <CartItem> [];
  List<CartItem> get items => _items;
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
  }
  void deleteCart(int index){
    _items.remove(_items[index]);
  }
}