import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  late final bool isRead;
  final Timestamp timestamp;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.timestamp,
  });

  factory NotificationModel.fromSnapshot(DocumentSnapshot doc) {
    return NotificationModel(
      id: doc.id,
      title: doc['title'],
      message: doc['message'],
      isRead: doc['isRead'],
      timestamp: doc['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'isRead': isRead,
      'timestamp': timestamp,
    };
  }
}
