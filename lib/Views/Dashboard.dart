
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:price_management/StorageProvider.dart';
import 'package:price_management/Views/AddScreen.dart';
import 'package:price_management/Views/Shopping.dart';
import 'package:price_management/Views/login_form.dart';
import 'package:price_management/shared/firebase_auth.dart';

class Dashboard extends StatefulWidget {
  final String uid;
  final FirebaseAuthentication auth;
  const Dashboard({Key? key, required this.uid, required this.auth}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future loadData(BuildContext context) async {
    await StorageProvider.of(context).readPref(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadData(context),
        builder: (context, snapshot) {
      if(snapshot.hasError){
        return Text('Error');
      }
      return Scaffold(
          appBar: AppBar(
            title: const Text('Quản lý bán hàng'),
            actions: [
              IconButton(onPressed: (){

                widget.auth.logout().then((value){
                  // ignore: prefer_const_constructors
                  if(value){
                      StorageProvider.of(context).clearData();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => LoginScreen()));
                  }
                  else {
                    print("Logout error");
                  }
                });
              }, icon: const Icon(Icons.logout))
            ],
          ),
          body: snapshot.connectionState == ConnectionState.done ? GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            primary: false,
            children: [
              buildGestureDetector(context, 'Mua hàng'),
              buildGestureDetector(context, 'Thêm sản phẩm'),
            ],
          ): const Center(child: CircularProgressIndicator()),
      );
    });
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
