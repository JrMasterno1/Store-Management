
import 'package:flutter/material.dart';
import 'package:price_management/StorageProvider.dart';
import 'package:price_management/Views/AddScreen.dart';
import 'package:price_management/Views/Shopping.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StorageProvider(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý bán hàng'),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          primary: false,
          children: [
            buildGestureDetector(context, 'Mua hàng'),
            buildGestureDetector(context, 'Thêm sản phẩm'),
          ],
        ),
      ),
    );
  }

  GestureDetector buildGestureDetector(BuildContext context,String text) {
    return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (text == 'Thêm sản phẩm') ?
                  const Icon(Icons.add_circle, size: 50, color: Colors.white,) : const Icon(Icons.shopping_cart, size: 50, color: Colors.white,),
                  const SizedBox(height: 20,),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              )),
            ),
          ),
          onTap: (){
            if(text == 'Thêm sản phẩm') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AddScreen()));
            }
            else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CartProvider(child: const Shopping())));
            }
          },
        );
  }
}
