import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:price_management/Models/product.dart';
import 'package:price_management/StorageProvider.dart';
import 'package:price_management/Views/CustomSearch.dart';
import 'package:price_management/Views/EditScreen.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final controller = StorageProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bán hàng'),
        actions: [
          IconButton(onPressed: () async {
            final p = await showSearch(context: context, delegate: CustomSearchDelegate(items: controller.products));
            if(p != null){
              _navigateEdit(context, p).then((value){
                if(value != null){
                  setState(() {
                    controller.editProduct(p, value);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã chỉnh sửa thành công')));
                }
              });
            }
          }, icon: const Icon(Icons.search))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Tên sản phẩm'
                ),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                hintText: 'Giá'
                ),
              ),
              ElevatedButton(onPressed: (){
                String proName = nameController.text;
                double proPrice = double.tryParse(priceController.text)!;
                setState(() {
                  nameController.clear();
                  priceController.clear();
                  controller.addNewProduct(proName, proPrice);
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã thêm sản phẩm')));
              }, child: const Text('Thêm sản phẩm'))
            ],
          ),
        ),
      ),
    );
  }
  Future<List<Product>> readFile() async {
    String myString = await DefaultAssetBundle.of(context).loadString('assets/prolists.json');
    List myMap = jsonDecode(myString);
    List<Product> prods = [];
    myMap.forEach((dynamic element) {
      Product p = Product.fromJson(element);
      prods.add(p);
    });
    return prods;
  }
  Future _navigateEdit(BuildContext context, Product product) async {
    final new_p = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditScreen(product: product))
    );
    return new_p;
  }
}
