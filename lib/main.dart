import 'package:flutter/material.dart';
import 'package:price_management/StorageProvider.dart';
import 'package:price_management/Views/AddScreen.dart';
import 'package:price_management/Views/Dashboard.dart';
import 'package:price_management/Views/login_form.dart';
import 'package:price_management/shared/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  late FirebaseAuthentication auth;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            auth = FirebaseAuthentication();
            return StorageProvider(
              child: MaterialApp(
                  title: 'Flutter Demo',
                  theme: ThemeData(
                    // This is the theme of your application.
                    //
                    // Try running your application with "flutter run". You'll see the
                    // application has a blue toolbar. Then, without quitting the app, try
                    // changing the primarySwatch below to Colors.green and then invoke
                    // "hot reload" (press "r" in the console where you ran "flutter run",
                    // or simply save your changes to "hot reload" in a Flutter IDE).
                    // Notice that the counter didn't reset back to zero; the application
                    // is not restarted.
                    primarySwatch: Colors.blue,
                  ),
                  home: FutureBuilder(
                    future: SharedPreferences.getInstance(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return CircularProgressIndicator();
                      }
                      var prefs = snapshot.data;
                      print(prefs.getString("username"));
                      if(prefs.getString("username") != null){
                        return FutureBuilder(
                          future: auth.login(prefs.getString("username")!, prefs.getString("password")!),
                          builder: (context, snapshot){
                            if(snapshot.connectionState == ConnectionState.done){
                              return StorageProvider(child: Dashboard(uid: snapshot.data.toString(), auth: auth,));
                            }
                            return CircularProgressIndicator();
                          },
                        );
                      }
                    return LoginScreen(auth: auth);
                    }
                  ) //StorageProvider(child: const Dashboard()),
              ),
            );
          }
          return CircularProgressIndicator();
        }
    );
  }
}

