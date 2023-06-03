import 'package:cloud_firestore/cloud_firestore.dart';

class RatingItem {
  final String? username;
  final String? email;
  final String? review;
  final int? rating;
  final int? timestamp;

  RatingItem(
      {this.username, this.email, this.review, this.rating, this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "email": email,
      "review": review,
      "rating": rating,
      "timestamp": timestamp,
    };
  }

  factory RatingItem.fromDocument(DocumentSnapshot doc) {
    return RatingItem(
        username: doc["username"],
        email: doc["email"],
        review: doc["review"],
        rating: doc["rating"],
        timestamp: doc["timestamp"]);
  }
}

List<RatingItem> ratingItems = [
  RatingItem(
      username: "Brian Namutali",
      email: "briannamutali586@gmail.com",
      review: "This is the best travel agent across Africa!",
      rating: 5,
      timestamp: 1627511340786),
  RatingItem(
      username: "Derrick Kirui",
      email: "derrickkirui123@gmail.com",
      review:
          "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
      rating: 3,
      timestamp: 1627511357530),
  RatingItem(
      username: "Emmanuel Bett",
      email: "emmanuelbett@gmail.com",
      review:
          "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content.",
      rating: 4,
      timestamp: 1629674478544),
];
