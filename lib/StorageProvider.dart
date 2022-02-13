
import 'package:flutter/material.dart';
import 'package:price_management/Controller/storage_controlller.dart';

class StorageProvider extends InheritedWidget{
  final _controller = StorageController();
  StorageProvider({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child){
   _controller.readPref();
  }
  static StorageController of(BuildContext context){
    final StorageProvider result = context.dependOnInheritedWidgetOfExactType<StorageProvider>()!;
    assert(result != null, 'No StorageProvider found in context');
    return result._controller;
  }


  @override
  bool updateShouldNotify(StorageProvider oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }

}