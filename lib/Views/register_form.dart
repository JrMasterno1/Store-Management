import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:price_management/Views/Dashboard.dart';
import 'package:price_management/shared/firebase_auth.dart';

import '../StorageProvider.dart';

class RegisterScreen extends StatefulWidget {
  final FirebaseAuthentication auth;
  const RegisterScreen({Key? key, required this.auth}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController txtUsername = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  String _message = '';
  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
                'Register',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  color: Colors.blue
                ),
              ),
          ),
          SizedBox(height: size.height*0.03,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: TextFormField(
              controller: txtUsername,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Username',
                icon: Icon(Icons.verified_user),
              ),
              validator: (text) => text!.isEmpty ? 'User name is required' : '',
            ),
          ),
          SizedBox(height: size.height*0.03,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: TextFormField(
              controller: txtPassword,
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                icon: Icon(Icons.enhanced_encryption),
              ),
              validator: (text) => text!.isEmpty ? 'Password is required' : '',
            ),
          ),
          SizedBox(height: size.height*0.05,),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                String userId = '';
                widget.auth.createUser(txtUsername.text, txtPassword.text).then((value){
                  if(value == null){
                    setState(() {
                      _message = 'Registration Error';
                    });
                  }
                  else {
                    setState(() {
                      userId = value;
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StorageProvider(child: Dashboard(uid: userId,auth: widget.auth,))));
                    });
                  }
                });
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0))),

                  padding: MaterialStateProperty.all(const EdgeInsets.all(0))
              ),
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                width: size.width * 0.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80.0),
                    gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 136, 34),
                          Color.fromARGB(255, 255, 177, 41)
                        ]
                    )
                ),
                padding: const EdgeInsets.all(0),
                child: const Text(
                  "REGISTER",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Text(
              _message,
              style: const TextStyle(
                  color: Colors.red
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: GestureDetector(
              onTap: () => {
                Navigator.pop(context)
              },
              child: const Text(
                "Already have an Account? Log in",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2661FA)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
