import 'package:flutter/material.dart';
import 'package:price_management/Models/product.dart';

class EditScreen extends StatefulWidget {
  Product product;
  EditScreen({Key? key, required this.product}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final nameController = TextEditingController(text: product.productName);
    final priceController = TextEditingController(text: product.price.toString());
    return Scaffold(
      appBar: AppBar(title: Text('Chỉnh sửa sản phẩm'),),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                controller: nameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                controller: priceController,
              ),
            ),
            ElevatedButton(onPressed: (){
              Product p = Product(productName: nameController.text, price: double.tryParse(priceController.text)!);
              setState(() {
              widget.product = p;
              });
              Navigator.pop(context, p);
            }, child: Text('Chỉnh sửa'))
          ],
        ),
      ),
    );
  }
}


