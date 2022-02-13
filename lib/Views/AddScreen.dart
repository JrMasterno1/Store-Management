import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:price_management/Models/product.dart';
import 'package:price_management/StorageProvider.dart';
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
        title: Text('Ban hang'),
        actions: [
          IconButton(onPressed: () async {
            final index = await showSearch(context: context, delegate: CustomSearchDelegate(items: controller.products));
            if(index != null){
              _navigateEdit(context, controller.products[index]).then((value){
                if(value != null){
                  setState(() {
                    controller.editProduct(index, value);
                  });
                }
              });
            }
          }, icon: const Icon(Icons.search))
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Ten san pham'
                ),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                hintText: 'Gia'
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
              }, child: const Text('Them san pham'))
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
class CustomSearchDelegate extends SearchDelegate{
  late final items;
  CustomSearchDelegate({this.items});
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(onPressed: (){query = '';}, icon: const Icon(Icons.clear))
    ];
  }
  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: (){
          close(context, null);
        },
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    List<Product> matchQuery = [];
    for(var p in items){
      if(p.productName.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(p);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (BuildContext context, int index){
        return ListTile(
          title: Text(matchQuery[index].productName),
          subtitle: Text(matchQuery[index].price.toString()),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> matchQuery = [];
    for(var p in items){
      if(p.productName.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(p);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (BuildContext context, int index){
        return ListTile(
          title: Text(matchQuery[index].productName),
          subtitle: Text(matchQuery[index].price.toString()),
          onTap: (){
            Navigator.pop(context, index);
            //_navigateEdit(context, matchQuery[index]);
          },
        );
      },
    );
  }
  
}
