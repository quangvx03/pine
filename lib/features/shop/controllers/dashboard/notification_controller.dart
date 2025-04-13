import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/notification_model.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  // List to hold notifications
  var notifications = <NotificationModel>[].obs;
  var unreadCount = 0.obs;

  // Fetch notifications from Firestore (example)
  Future<void> fetchNotifications() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')  // Assuming you store notifications in this collection
          .orderBy('timestamp', descending: true)
          .get();

      notifications.value = snapshot.docs
          .map((doc) => NotificationModel.fromSnapshot(doc))
          .toList();
      updateUnreadCount();
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  // Add a new notification (can be triggered by an external action)
  void addNotification(String title, String message) {
    final newNotification = NotificationModel(
      id: DateTime.now().toString(), // You can use a unique ID or Firestore document ID
      title: title,
      message: message,
      isRead: false,
      timestamp: Timestamp.now(),
    );

    notifications.insert(0, newNotification);  // Add to the front
    updateUnreadCount();
  }

  // Mark all notifications as read
  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    updateUnreadCount();
  }

  // Update the unread count
  void updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }
}
