
class Sale {
  late final int month;
  late double revenue;
  Sale({required this.month,required this.revenue});
  Sale.fromJson(Map<String, dynamic> json): this.month = json['month'], this.revenue = json['revenue'];



}