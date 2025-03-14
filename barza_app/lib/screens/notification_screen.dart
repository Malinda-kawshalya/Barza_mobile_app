import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'exchange_detail_screen.dart';
import 'chat_screen.dart';

class NotificationsScreen extends StatelessWidget {
  void handleNotificationTap(BuildContext context, Map<String, dynamic> notificationData) {
    if (notificationData['type'] == 'new_chat') {
      String chatId = notificationData['chatId'];
      String senderId = notificationData['senderId'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(chatId: chatId, otherUserId: senderId),
        ),
      );
    } else if (notificationData['type'] == 'exchange_request' ||
        notificationData['type'] == 'exchange_accepted' ||
        notificationData['type'] == 'exchange_declined') {
      String exchangeRequestId = notificationData['exchangeRequestId'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExchangeRequestDetailsScreen(
            exchangeRequestId: exchangeRequestId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text("Please login"));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Color(0xFF0C969C),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error loading notifications: ${snapshot.error}');
            print('Stack trace: ${snapshot.stackTrace}');
            return Center(child: Text("Error loading notifications"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No notifications"));
          }

          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              var notification = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              print('Building notification: ${snapshot.data!.docs[index].id}');
              bool read = notification['read'] ?? false;
              String message = notification['message'] ?? "No message";
              Timestamp? timestamp = notification['timestamp'];
              String formattedTime = timestamp != null
                  ? DateFormat.yMd().add_jm().format(timestamp.toDate())
                  : "No date";

              return ListTile(
                key: ValueKey(snapshot.data!.docs[index].id),
                leading: Icon(
                  _getNotificationIcon(notification['type']),
                  color: _getNotificationColor(notification['type']),
                ),
                title: Text(
                  message,
                  style: TextStyle(
                    fontWeight: read ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Text(formattedTime),
                tileColor: read ? Colors.grey[100] : null,
                onTap: () {
                  _markAsRead(snapshot.data!.docs[index].id);
                  handleNotificationTap(context, notification);
                },
              );
            },
          );
        },
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'exchange_request':
        return Icons.swap_horiz;
      case 'exchange_accepted':
        return Icons.check_circle_outline;
      case 'new_message':
        return Icons.message_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'exchange_request':
        return Colors.blue;
      case 'exchange_accepted':
        return Colors.green;
      case 'new_message':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _markAsRead(String notificationId) {
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .update({'read': true});
  }
}