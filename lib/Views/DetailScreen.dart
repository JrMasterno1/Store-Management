
import 'package:flutter/material.dart';
import 'package:price_management/Models/product.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  const DetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int nums = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chọn số lượng sản phẩm'),
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
                    style: const TextStyle(fontSize: 20)
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
                          style: const TextStyle(fontSize: 20)
                      )
                    ]
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: (){
                  if(nums > 0){
                    setState(() {
                      nums--;
                    });
                  }
                }, icon: Icon(Icons.remove)),
                Text('$nums', style: const TextStyle(fontSize: 18),),
                IconButton(onPressed: (){
                  setState(() {
                    nums++;
                  });
                }, icon: Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              Navigator.pop(context, nums);
            }, child: const Text('Thêm vào giỏ hàng'))
          ],
        )));
  }
}
