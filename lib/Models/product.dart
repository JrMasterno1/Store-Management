class Product {
  String productName;
  double price;
  late int id;
  Product.fromJson(Map<String, dynamic> json): this.productName = json['productName'], this.price = json['price'];
  Product({this.productName = '', this.price = 0, this.id = 0});
  Map<String, dynamic> toJson(){
    return {
      'productName': productName,
      'price': price
    };
  }
}