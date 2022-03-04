import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:price_management/Controller/storage_controlller.dart';
import 'package:price_management/Models/product.dart';
import 'package:price_management/StorageProvider.dart';
import 'package:price_management/Views/CustomSearch.dart';
import 'package:price_management/Views/EditScreen.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatelessWidget {
  AddScreen({Key? key}) : super(key: key);

//   @override
//   _AddScreenState createState() => _AddScreenState();
// }
//
// class _AddScreenState extends State<AddScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: StorageProvider.of(context),
      child: Consumer<StorageController>(
        builder: (context, myModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Bán hàng'),
              actions: [
                IconButton(
                    onPressed: () async {
                      final p = await showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(items: myModel.products));
                      if (p != null) {
                        _navigateEdit(context, p).then((value) {
                          if (value != null) {
                              myModel.editProduct(p, value);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Đã chỉnh sửa thành công')));
                          }
                        });
                      }
                    },
                    icon: const Icon(Icons.search))
              ],
            ),
            body: buildBody(myModel, context),
          );
        }
      ),
    );
  }

  Center buildBody(StorageController controller, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Tên sản phẩm'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(hintText: 'Giá'),
            ),
            ElevatedButton(
                onPressed: () {
                  String proName = nameController.text;
                  double proPrice = double.tryParse(priceController.text)!;
                  nameController.clear();
                  priceController.clear();
                    controller.addNewProduct(proName, proPrice);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã thêm sản phẩm')));
                },
                child: const Text('Thêm sản phẩm'))
          ],
        ),
      ),
    );
  }

  Future _navigateEdit(BuildContext context, Product product) async {
    final new_p = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditScreen(product: product)));
    return new_p;
  }
}
