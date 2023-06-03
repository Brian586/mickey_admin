import 'package:cloud_firestore/cloud_firestore.dart';

class Safari {
  final String? safariID;
  final String? name;
  final String? city;
  final String? country;
  final String? description;
  final String? cost;
  final int? days;
  final int? nights;
  final String? currency;
  final String? imageUrl;
  final int? timestamp;

  Safari(
      {this.safariID,
      this.name,
      this.city,
      this.country,
      this.description,
      this.cost,
      this.days,
      this.nights,
      this.currency,
      this.imageUrl,
      this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      "safariID": safariID,
      "name": name,
      "city": city,
      "country": country,
      "description": description,
      "cost": cost,
      "days": days,
      "nights": nights,
      "currency": currency,
      "imageUrl": imageUrl,
      "timestamp": timestamp,
    };
  }

  factory Safari.fromDocument(DocumentSnapshot doc) {
    return Safari(
        safariID: doc["safariID"],
        name: doc["name"],
        city: doc["city"],
        country: doc["country"],
        description: doc["description"],
        cost: doc["cost"],
        days: doc["days"],
        nights: doc["nights"],
        currency: doc["currency"],
        imageUrl: doc["imageUrl"],
        timestamp: doc["timestamp"]);
  }
}
