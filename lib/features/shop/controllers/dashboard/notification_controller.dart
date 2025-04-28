import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/notification_model.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  var notifications = <NotificationModel>[].obs;
  var unreadCount = 0.obs;

  Future<void> fetchNotifications() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Notifications')
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

  void addNotification(String title, String message) {
    final newNotification = NotificationModel(
      id: DateTime.now().toString(),
      title: title,
      message: message,
      isRead: false,
      timestamp: Timestamp.now(),
    );

    notifications.insert(0, newNotification);
    updateUnreadCount();
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    updateUnreadCount();
  }

  void updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }
}
