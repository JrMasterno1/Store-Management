
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:price_management/Models/sales.dart';

class RevenueController {
  final _revenues = <Sale>[];
  String uid = '';
  static final RevenueController _instance = RevenueController._internal();
  RevenueController._internal();
  factory RevenueController(){
    return _instance;
  }
  List get revenues => List.unmodifiable(_revenues);
  Future readData(String uid, CollectionReference collection) async {
    this.uid = uid;
    QuerySnapshot snapshot = await collection.get();
    List list = snapshot.docs;
    Map<String, dynamic> months = list[0].data();
    months.forEach((key, value) {
      int i = _revenues.indexWhere((item) => item.month == int.tryParse(key));
      if(i == -1){
        _revenues.add(Sale(month: int.tryParse(key)!,revenue: value.toDouble()));
      }
      else {
        revenues[i].revenue = value.toDouble();
      }
    });
  }
  Future saveData(double price) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference collection = db.collection('store');
    DocumentReference qds =  collection.doc(uid);
    DocumentSnapshot document = await qds.get();
    qds.update({DateTime.now().month.toString(): document.get(DateTime.now().month.toString()) + price});
  }
  List getLatestMonths(){
    int currentMonth = DateTime.now().month;
    List months = [];
    while (months.length < 12){
      if(currentMonth + 1 > 12){
        currentMonth = 0;
      }
      months.add(currentMonth + 1);
      currentMonth++;
    }
    return months;
  }
}