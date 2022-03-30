import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:price_management/Views/register_form.dart';
import 'package:price_management/shared/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../StorageProvider.dart';
import 'Dashboard.dart';

class LoginScreen extends StatefulWidget {
  FirebaseAuthentication auth;
  LoginScreen({Key? key, required this.auth}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _message = '';
  bool _isLogin = true;
  final TextEditingController txtUsername = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Text(
            'Login',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
                color: Color(0xFF2661FA)),
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: TextFormField(
            controller: txtUsername,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                hintText: 'Email', icon: Icon(Icons.verified_user)),
            validator: (text) => text!.isEmpty ? 'User name is required' : '',
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: TextFormField(
            controller: txtPassword,
            keyboardType: TextInputType.emailAddress,
            obscureText: true,
            decoration: const InputDecoration(
                hintText: 'Password', icon: Icon(Icons.enhanced_encryption)),
            validator: (text) => text!.isEmpty ? 'User name is required' : '',
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: const Text(
            "Forgot your password?",
            style: TextStyle(
                fontSize: 12,
                color: Color(0XFF2661FA)
            ),
          ),
        ),
        SizedBox(height: size.height*0.05,),
        Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: ElevatedButton(
            onPressed: () {
              String userId = '';
              widget.auth.login(txtUsername.text, txtPassword.text).then((value){
                if(value!= null){
                    setState(() {
                      userId = value;
                      saveUserIDAndPassword(txtUsername.text, txtPassword.text);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StorageProvider(child: Dashboard(uid: userId, auth: widget.auth,))));
                    });
                }
                else {
                  setState(() {
                    _message = "Incorrect email/password";
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
                "LOGIN",
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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterScreen(auth: widget.auth,)))
            },
            child: const Text(
              "Don't Have an Account? Sign up",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2661FA)
              ),
            ),
          ),
        )
      ],
    ));
  }
  Future saveUserIDAndPassword(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", username);
    await prefs.setString("password", password);
  }
}
