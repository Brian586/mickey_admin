import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? postId;
  final String? userId;
  final String? imageUrl;
  final String? name;
  final String? type;
  final String? address;
  final String? locality;
  final String? description;
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;
  final int? timestamp;
  final String? price;
  final String? currency;
  final String? payPeriod;
  final String? ownerUrl;
  final String? email;
  final String? phone;
  final String? username;

  Post({
    this.postId,
    this.userId,
    this.longitude,
    this.latitude,
    this.description,
    this.imageUrl,
    this.address,
    this.name,
    this.country,
    this.timestamp,
    this.city,
    this.locality,
    this.payPeriod,
    this.price,
    this.currency,
    this.type,
    this.email,
    this.ownerUrl,
    this.phone,
    this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      "postId": postId,
      "ownerId": userId,
      "timestamp": timestamp,
      "username": username,
      "description": description,
      "url": imageUrl,
      "name": name,
      "type": type,
      "locality": locality,
      "currency": currency,
      "payPeriod": payPeriod,
      "price": price,
      "city": city,
      "country": country,
      "latitude": latitude,
      "longitude": longitude,
      "ownerUrl": ownerUrl,
      "phone": phone,
      "address": address,
      "email": email,
    };
  }

  factory Post.fromDocument(DocumentSnapshot documentSnapshot) {
    return Post(
      postId: documentSnapshot["postId"],
      imageUrl: documentSnapshot["url"],
      description: documentSnapshot["description"],
      name: documentSnapshot["name"],
      city: documentSnapshot["city"],
      country: documentSnapshot["country"],
      locality: documentSnapshot["locality"],
      payPeriod: documentSnapshot["payPeriod"],
      price: documentSnapshot["price"],
      currency: documentSnapshot["currency"],
      type: documentSnapshot["type"],
      address: documentSnapshot["address"],
      latitude: documentSnapshot["latitude"],
      longitude: documentSnapshot["longitude"],
      username: documentSnapshot["username"],
      phone: documentSnapshot["phone"],
      ownerUrl: documentSnapshot["ownerUrl"],
      userId: documentSnapshot["ownerId"],
      email: documentSnapshot["email"],
      timestamp: documentSnapshot["timestamp"],
    );
  }
}
