import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.name,
    this.price,
    this.oldPrice,
    this.image,
    this.currency,
    this.url,
  });

  String? name;
  String? price;
  String? oldPrice;
  String? image;
  String? currency;
  String? url;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        name: json["name"],
        price: json["price"],
        oldPrice: json["oldPrice"],
        image: json["image"],
        currency: json["currency"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "oldPrice": oldPrice,
        "image": image,
        "currency": currency,
        "url": url,
      };
}
