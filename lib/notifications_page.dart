import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationsPage extends StatefulWidget {
  final int userId;

  NotificationsPage({required this.userId});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List notifications = [];

  @override
  void initState() {
    super.initState();
    updateNotificationsStatus();
    fetchNotifications();
  }

  Future<void> updateNotificationsStatus() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/myprojectt/update_notifications_status.php'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, int>{
          'user_id': widget.userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          print('Notifications updated successfully');
        } else {
          print('Failed to update notifications status: ${data['message']}');
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to update notifications status: $e');
    }
  }

  Future<void> fetchNotifications() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/myprojectt/get_notificationsph.php'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, int>{
        'user_id': widget.userId,
      }),
    );

    final responseBody = response.body;
    final statusCode = response.statusCode;
    print('Response Status Code: $statusCode'); // طباعة كود الحالة للاستجابة
    print('Response Body: $responseBody'); // طباعة استجابة الخادم

    if (statusCode == 200) {
      try {
        final data = jsonDecode(responseBody);
        print('Response Data: $data'); // طباعة البيانات المستلمة

        if (data is Map<String, dynamic> && data['success']) {
          setState(() {
            notifications = data['notifications'];
            print('Notifications: $notifications'); // طباعة الإشعارات بعد التحديث
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch notifications: ${data['message']}')),
          );
        }
      } catch (e) {
        print('JSON Decode Error: $e'); // طباعة خطأ التحليل
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to parse response')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server error: $statusCode')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // ضبط ارتفاع AppBar
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/images/saa.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Notifications',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ],
            ),
          ),
          backgroundColor: Color(0xFF0288D1), // لون أزرق فاتح
        ),
      ),
      body: notifications.isEmpty
          ? Center(child: Text('No notifications found'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                print('Notification: $notification'); // طباعة كل إشعار
                return NotificationCard(
                  ticketNumber: notification['ticket_id'].toString(),
                  description: notification['message'],
                  notificationDate: notification['created_at'],
                );
              },
            ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String ticketNumber;
  final String description;
  final String notificationDate;

  NotificationCard({
    required this.ticketNumber,
    required this.description,
    required this.notificationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ticket Number: $ticketNumber',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            Text(
              notificationDate,
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
        subtitle: Text(
          description,
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
