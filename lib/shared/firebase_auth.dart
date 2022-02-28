
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String?> createUser(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password:
      password);
      if(credential.user != null){
        FirebaseFirestore db = FirebaseFirestore.instance;
        CollectionReference collection = db.collection('store');
        await collection.doc(credential.user!.uid).collection("products").add({});
        await collection.doc(credential.user!.uid).collection("months").add({
          "1" : 0,
          "2" : 0,
          "3" : 0,
          "4" : 0,
          "5" : 0,
          "6" : 0,
          "7" : 0,
          "8" : 0,
          "9" : 0,
          "10" : 0,
          "11" : 0,
          "12" : 0});
        await collection.doc(credential.user!.uid).set({
          "products": "",
          "1" : 0,
          "2" : 0,
          "3" : 0,
          "4" : 0,
          "5" : 0,
          "6" : 0,
          "7" : 0,
          "8" : 0,
          "9" : 0,
          "10" : 0,
          "11" : 0,
          "12" : 0,});
      }
      return credential.user!.uid;
    } on FirebaseAuthException {
      return null;
    }
  }
  Future<String?> login(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password:
      password);
      return credential.user!.uid;
    } on FirebaseAuthException {
      return null;
    }
  }
  Future<bool> logout() async {
    try {
      _firebaseAuth.signOut();
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }
}