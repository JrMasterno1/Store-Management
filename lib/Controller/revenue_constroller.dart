
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
  Future readData(String uid, snapshot) async {
    List list = snapshot.data.docs;
    this.uid = uid;
    int index = list.indexWhere((element){
      return element.id == uid;
    });
    DocumentSnapshot document = list[index];
    List lates = getLatestMonths();
    lates.forEach((element) {
      int i = _revenues.indexWhere((item) => item.month == element);
      if(i == -1){
        _revenues.add(Sale(month: element, revenue: double.tryParse(document.get(element.toString()).toString())!));
      }
      else {
        _revenues[i].revenue = double.tryParse(document.get(element.toString()).toString())!;
      }
    });
  }
  Future saveData(double price) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference collection = db.collection('store');
    QuerySnapshot snapshot = await collection.get();
    List<QueryDocumentSnapshot> list = snapshot.docs;
    int index = list.indexWhere((element){
      print("${element.id} == ${uid}");
      return element.id == uid;
    });
    print(index);
    DocumentSnapshot document = list[index];
    final id = document.id;
    // get current revenue
    int currentIndexRevenue = _revenues.indexWhere((element)
    {
      return element.month.toString() == DateTime.now().month.toString();
    });
    final currentRevenue = _revenues[currentIndexRevenue];
    currentRevenue.revenue += price;
    collection.doc(id).update({DateTime.now().month.toString() : currentRevenue.revenue});
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