
import 'package:flutter/material.dart';
import 'package:price_management/Controller/cart_controller.dart';
import 'package:price_management/Models/cart.dart';
import 'package:price_management/StorageProvider.dart';
import 'package:provider/provider.dart';

class Shopping extends StatefulWidget {
  const Shopping({Key? key}) : super(key: key);

  @override
  _ShoppingState createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {
  @override
  Widget build(BuildContext context) {
    return CartProvider(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mua hàng'),
        ),
        body: _buildBody(context),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(20),
          height: 174,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow:[
              BoxShadow(
                offset: const Offset(0,-15),
                blurRadius: 20,
                color: const Color(0xffdadada).withOpacity(0.15)
              )
            ]
          ),
          child: Text('Tổng số tiền', style: TextStyle(fontSize: 20),),
        ),
      ),
    );
  }
  Widget _buildBody(BuildContext context){
    final items = CartProvider.of(context).items;
    return (items.isNotEmpty ? listView(items,context) : emptyView(context));
  }
  Widget emptyView(BuildContext context){
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            const Icon(Icons.shopping_cart_outlined,size: 100,),
            SizedBox(height: 10,),
            Text(
              "Giỏ hàng trống",
              style: TextStyle(
                  fontSize: 16
              ),)
          ],
        ),
      ),
    );
  }

  ListView listView(List<CartItem> items, BuildContext context) {
    return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Dismissible(
          key: ValueKey(items[index]),
          direction: DismissDirection.endToStart,
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFE6F6),
              borderRadius: BorderRadius.circular(15)
            ),
            child: Column(
              children: [
                Text(items[index].product!.productName),
                const SizedBox(height: 10,),
                Text.rich(
                  TextSpan(
                    text: "\$${items[index].product!.price}",
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.orangeAccent)
                  )
                )
              ],
            )
          ),
          child: Row(
            children: const [
              Spacer(),
              Icon(Icons.card_travel),
            ],
          ),
          onDismissed: (direction){

          },
        ),
      );
    },
  );
  }
}
