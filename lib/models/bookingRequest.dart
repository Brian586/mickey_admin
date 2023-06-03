import 'package:cloud_firestore/cloud_firestore.dart';

class BookingRequest {
  final String? requestID;
  final String? name;
  final String? phone;
  final String? email;
  final String? message;
  final int? adultsNo;
  final int? childrenNo;
  final int? startDate;
  final int? endDate;
  final Map<String, dynamic>? post;

  BookingRequest(
      {this.name,
      this.requestID,
      this.phone,
      this.email,
      this.message,
      this.adultsNo,
      this.childrenNo,
      this.startDate,
      this.post,
      this.endDate});

  Map<String, dynamic> toMap() {
    return {
      "requestID": requestID,
      "name": name,
      "phone": phone,
      "email": email,
      "message": message,
      "adultsNo": adultsNo,
      "childrenNo": childrenNo,
      "startDate": startDate,
      "endDate": endDate,
      "post": post,
    };
  }

  factory BookingRequest.fromDocument(DocumentSnapshot doc) {
    return BookingRequest(
        requestID: doc["requestID"],
        name: doc["name"],
        phone: doc["phone"],
        email: doc["email"],
        message: doc["message"],
        adultsNo: doc["adultsNo"],
        childrenNo: doc["childrenNo"],
        startDate: doc["startDate"],
        endDate: doc["endDate"],
        post: doc["post"]);
  }
}
