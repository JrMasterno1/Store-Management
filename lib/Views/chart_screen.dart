
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:price_management/Controller/revenue_constroller.dart';
import 'package:price_management/Models/sales.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatelessWidget {
  String uid;
  ChartScreen({Key? key, required this.uid}) : super(key: key);
//
//   @override
//   _ChartScreenState createState() => _ChartScreenState();
// }
//
// class _ChartScreenState extends State<ChartScreen> {

  @override
  Widget build(BuildContext context) {
    final controller = RevenueController();
    final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection('store').doc(uid).collection('months').snapshots();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tổng doanh thu'),
        ),
        body: StreamBuilder(
          stream: _stream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasError){
              return Text('Error');
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            return SfCartesianChart(
              title: ChartTitle(text: 'Doanh thu theo tháng gần nhất'),
              series: <ChartSeries>[
                LineSeries(dataSource: controller.revenues, xValueMapper: (sale, _) => sale.month, yValueMapper: (sale, _) => sale.revenue, enableTooltip: true),
              ],
              primaryXAxis: NumericAxis(
                edgeLabelPlacement: EdgeLabelPlacement.shift,
              ),
                primaryYAxis: NumericAxis(
                    numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0))
            );
          }
        ),
      ),
    );
  }
}
