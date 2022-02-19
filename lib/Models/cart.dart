
import 'package:price_management/Models/product.dart';

class CartItem {
  Product? product;
  int num;
  CartItem({this.product,this.num = 0});
  double get price => product!.price*num;
}


