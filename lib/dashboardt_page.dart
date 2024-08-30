import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ticket_details_page.dart';
import 'technician_reply_page.dart';
import 'notifications_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TicketCard.dart'; // تأكد من استيراد الملف الصحيح
import 'login_page.dart'; // استيراد صفحة تسجيل الدخول
import 'AddReviewPage.dart'; // استيراد صفحة إضافة المراجعات

class TechnicianDashboardPage extends StatefulWidget {
  @override
  _TechnicianDashboardPageState createState() => _TechnicianDashboardPageState();
}

class _TechnicianDashboardPageState extends State<TechnicianDashboardPage> {
  List<dynamic> tickets = [];
  int? userId;
  int unreadNotificationsCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id');
    });
    if (userId != null) {
      _fetchTickets();
      _fetchUnreadNotificationsCount();
    }
  }

  Future<void> _fetchTickets() async {
    if (userId != null) {
      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2/myprojectt/get_ticket_assignments.php'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, int>{
            'user_id': userId!,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success']) {
            setState(() {
              tickets = data['tickets'];
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to fetch tickets: ${data['message']}')),
              );
            });
          }
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Server error: ${response.statusCode}')),
            );
          });
        }
      } catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        });
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ID not found')),
        );
      });
    }
  }

  Future<void> _fetchUnreadNotificationsCount() async {
    if (userId != null) {
      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2/myprojectt/get_unread_notifications_count.php'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, int>{
            'user_id': userId!,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success']) {
            setState(() {
              unreadNotificationsCount = data['count'];
            });
          } else {
            print('Failed to fetch notifications count');
          }
        } else {
          print('Failed to fetch notifications count');
        }
      } catch (e) {
        print(e);
        print('Failed to fetch notifications count');
      }
    }
  }

  Future<void> _updateNotificationsStatus() async {
    if (userId != null) {
      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2/myprojectt/update_notifications_status.php'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, int>{
            'user_id': userId!,
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
        print(e);
        print('Failed to update notifications status');
      }
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
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
                  'LabTechCare',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ],
            ),
          ),
          backgroundColor: Color(0xFF0288D1), // لون أزرق فاتح
        ),
      ),
      backgroundColor: Color(0xFFE1F5FE), // لون خلفية فاتح
      body: Column(
        children: [
          Container(
            color: Color(0xFF0288D1), // لون أزرق فاتح
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home, color: Colors.white), // أيقونة الهوم
                  onPressed: () {
                    // إضافة الإجراء المناسب هنا
                  },
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications, color: Color(0xFFFFD54F)), // لون أصفر
                      onPressed: () async {
                        if (userId != null) {
                          await _updateNotificationsStatus(); // تحديث حالة الإشعارات
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NotificationsPage(userId: userId!)),
                          );
                          if (result == true) {
                            _fetchUnreadNotificationsCount(); // إعادة تحميل عدد الإشعارات غير المقروءة
                            _fetchTickets(); // إعادة تحميل التذاكر عند العودة إلى الصفحة الرئيسية
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('User ID not found')),
                          );
                        }
                      },
                    ),
                    if (unreadNotificationsCount > 0)
                      Positioned(
                        right: 11,
                        top: 11,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            '$unreadNotificationsCount',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.star, color: Colors.white), // أيقونة النجمة
                  onPressed: () {
                    if (userId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddReviewPage(userId: userId!),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User ID not found')),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.white), // لون أيقونة تسجيل الخروج
                  onPressed: _logout, // تسجيل الخروج عند الضغط على الزر
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Previous Tickets',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF01579B), // لون أزرق داكن
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: tickets.isEmpty
                        ? Center(child: Text('No tickets found', style: TextStyle(color: Color(0xFF01579B)))) // لون النص أزرق داكن
                        : ListView.builder(
                            itemCount: tickets.length,
                            itemBuilder: (context, index) {
                              final ticket = tickets[index];
                              return Card(
                                color: Color(0xFF0288D1), // لون أزرق فاتح
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date: ${ticket['date']?.toString() ?? ''}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        'Ticket Number: ${ticket['ticket_id']?.toString() ?? ''}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        'Status: ${ticket['status']?.toString() ?? ''}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        'Issue: ${ticket['issue']?.toString() ?? ''}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  trailing: PopupMenuButton<String>(
                                    onSelected: (String result) async {
                                      if (result == 'view_details') {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TicketDetailsPage(reportId: ticket['ticket_id']),
                                          ),
                                        );
                                      } else if (result == 'reply') {
                                        final replyResult = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TechnicianReplyPage(
                                              reportId: ticket['ticket_id'],
                                              userDescription: ticket['issue'],
                                              userId: userId!,
                                            ),
                                          ),
                                        );

                                        if (replyResult == true) {
                                          _fetchTickets(); // إعادة تحميل التذاكر بعد الرد بنجاح
                                          _fetchUnreadNotificationsCount(); // إعادة تحميل عدد الإشعارات غير المقروءة
                                        }
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'view_details',
                                        child: Text('View Details'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'reply',
                                        child: Text('Reply'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
