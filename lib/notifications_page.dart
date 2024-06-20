import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // تعيين ارتفاع الـ AppBar
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0), // إضافة المسافة من الأعلى
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white), // تغيير لون السهم إلى الأبيض
                  onPressed: () {
                    Navigator.pop(context); // تعيد المستخدم إلى الصفحة السابقة
                  },
                ),
                ClipOval(
                  child: Image.asset(
                    'assets/images/saa.png', // تأكد من تطابق المسار مع صورة الشعار
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'LabTechCare',
                  style: TextStyle(color: Colors.white, fontSize: 22), // لون النص الأبيض وحجم النص
                ),
              ],
            ),
          ),
          backgroundColor: Color.fromARGB(255, 36, 117, 154), // لون خلفية شريط العنوان
        ),
      ),
      backgroundColor: Color.fromARGB(255, 251, 251, 251), // لون خلفية الصفحة
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'New Notifications',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 0, 0, 0.867),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  NotificationCard(
                    ticketNumber: '12345',
                    description: 'New ticket has been assigned to device number 8 in Lab number 1.',
                    notificationDate: '2024-05-20',
                    date: '2 hours ago',
                  ),
                  NotificationCard(
                    ticketNumber: '12346',
                    description: 'The maintenance of device number 8 in Lab number 1 has been successfully completed.',
                    notificationDate: '2024-05-21',
                    date: '1 hour ago',
                  ),
                  // أضف المزيد من البطاقات هنا
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String ticketNumber;
  final String description;
  final String notificationDate;
  final String date;

  NotificationCard({
    required this.ticketNumber,
    required this.description,
    required this.notificationDate,
    required this.date,
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                date,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.black87),
          onSelected: (value) {
            // أضف منطق القائمة هنا
            switch (value) {
              case 'remove':
                // منطق إزالة الإشعار
                break;
              case 'turn_off':
                // منطق إيقاف الإشعارات
                break;
              case 'turn_on':
                // منطق تشغيل الإشعارات
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'remove',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Remove this notification'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'turn_off',
                child: Row(
                  children: [
                    Icon(Icons.notifications_off, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Turn off notification'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'turn_on',
                child: Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Turn on notification'),
                  ],
                ),
              ),
            ];
          },
        ),
      ),
    );
  }
}
