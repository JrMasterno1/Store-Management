import 'package:flutter/material.dart';
import 'package:price_management/Models/product.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  const DetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chỉnh sửa sản phẩm'),
        ),
        body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                text: 'Tên sản phẩm: ',
                children: <InlineSpan>[
                  TextSpan(
                    text: widget.product.productName,
                    style: const TextStyle(fontSize: 16)
                  )
                ]
              )
            ),
            Text.rich(
                TextSpan(
                    text: 'Giá sản phẩm: ',
                    children: <InlineSpan>[
                      TextSpan(
                          text: widget.product.price.toString(),
                          style: const TextStyle(fontSize: 16)
                      )
                    ]
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: (){}, icon: Icon(Icons.remove)),
                IconButton(onPressed: (){}, icon: Icon(Icons.add)),
              ],
            )
          ],
        )));
  }
}
