import 'package:cloud_firestore/cloud_firestore.dart';

class CoverPhoto {
  final String? id;
  final String? imageUrl;
  final String? name;
  final String? city;
  final String? country;
  final String? description;
  final String? cost;
  final String? currency;
  final int? timestamp;

  CoverPhoto(
      {this.imageUrl,
      this.name,
      this.id,
      this.city,
      this.country,
      this.description,
      this.cost,
      this.timestamp,
      this.currency});

  Map<String, dynamic> toMap() {
    return {
      "imageUrl": imageUrl,
      "name": name,
      "city": city,
      "country": country,
      "description": description,
      "cost": cost,
      "timestamp": timestamp,
      "currency": currency,
      "id": id
    };
  }

  factory CoverPhoto.fromDocument(DocumentSnapshot doc) {
    return CoverPhoto(
        imageUrl: doc["imageUrl"],
        name: doc["name"],
        city: doc["city"],
        country: doc["country"],
        description: doc["description"],
        cost: doc["cost"],
        timestamp: doc["timestamp"],
        currency: doc["currency"],
        id: doc["id"]);
  }
}
