import 'package:flutter/material.dart';
import 'package:price_management/Models/cart.dart';
import 'package:price_management/Models/product.dart';
import 'package:price_management/StorageProvider.dart';
import 'package:price_management/Views/CustomSearch.dart';

import 'DetailScreen.dart';

class Shopping extends StatefulWidget {
  const Shopping({Key? key}) : super(key: key);

  @override
  _ShoppingState createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {
  @override
  Widget build(BuildContext context) {
    return CartProvider(
      child: FutureBuilder(
          future: CartProvider.of(context).readPref(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Mua hàng'),
                  actions: [
                    IconButton(
                        onPressed: () async {
                          final p = await showSearch(
                              context: context,
                              delegate: CustomSearchDelegate(
                                  items: StorageProvider.of(context).products));
                          if (p != null) {
                            _navigateAddToCart(context, p).then((value) {
                              if (value != null) {
                                setState(() {
                                  CartProvider.of(context).addToCart(p, value);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Đã thêm vào giỏ hàng')));
                              }
                            });
                          }
                        },
                        icon: const Icon(Icons.search))
                  ],
                ),
                body: _buildBody(context),
                bottomNavigationBar: Container(
                  padding: const EdgeInsets.all(20),
                  height: 174,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, -15),
                            blurRadius: 20,
                            color: const Color(0xffdadada).withOpacity(0.15))
                      ]),
                  child: Column(
                    children: [
                      Text.rich(TextSpan(
                          text: "Tổng số tiền: ",
                          style: TextStyle(fontSize: 20),
                          children: <InlineSpan>[
                            TextSpan(
                                text: calculateTotal(),
                                style: TextStyle(fontSize: 25))
                          ])),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                CartProvider.of(context).clearPref();
                                });
                              },
                              child: Text('Đã thanh toán'))
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }

  String calculateTotal() {
    double total = 0;
    CartProvider.of(context).items.forEach((item) {
      total += item.price;
    });
    return total.toString();
  }

  Future _navigateAddToCart(BuildContext context, Product product) async {
    final cart = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailScreen(product: product)));
    return cart;
  }

  Widget _buildBody(BuildContext context) {
    final items = CartProvider.of(context).items;
    return (items.isNotEmpty ? listView(items, context) : emptyView(context));
  }

  Widget emptyView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: const [
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Giỏ hàng trống",
              style: TextStyle(fontSize: 16),
            )
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: const Color(0xFFFE6F6),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        items[index].product!.productName,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(TextSpan(
                          text: "\$${items[index].product!.price}",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.orangeAccent),
                          children: [
                            WidgetSpan(
                                child: Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text('x${items[index].num}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black)),
                            ))
                          ]))
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.card_travel),
                ],
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                items.remove(items[index]);
                CartProvider.of(context).savePref();
              });
            },
          ),
        );
      },
    );
  }
}
