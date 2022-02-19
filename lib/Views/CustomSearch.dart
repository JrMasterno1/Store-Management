import 'package:flutter/material.dart';
import 'package:price_management/Models/product.dart';

import '../StorageProvider.dart';


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
    return Scrollbar(
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            title: Text(matchQuery[index].productName),
            subtitle: Text(matchQuery[index].price.toString()),
            onTap: (){
              Navigator.pop(context, matchQuery[index]);
              //_navigateEdit(context, matchQuery[index]);
            },
          );
        },
      ),
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
    return Scrollbar(
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (BuildContext context, int index){
          return Dismissible(
            key: ValueKey(matchQuery[index]),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (_){
              StorageProvider.of(context).deleteProduct(matchQuery[index]);
            },
            child: ListTile(
              title: Text(matchQuery[index].productName),
              subtitle: Text(matchQuery[index].price.toString()),
              onTap: (){
                Navigator.pop(context, matchQuery[index]);
                //_navigateEdit(context, matchQuery[index]);
              },
            ),
          );
        },
      ),
    );
  }

}