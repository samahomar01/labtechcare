import 'package:flutter/material.dart';

class TicketHistoryPage extends StatelessWidget {
  final List<Map<String, String>> history;

  TicketHistoryPage({required this.history});

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
      backgroundColor: Color.fromARGB(255, 36, 117, 154), // لون خلفية الصفحة
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ticket History',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(Icons.circle,
                            color: Colors.black87, size: 16),
                        title: Text(
                          history[index]['status']!,
                          style: TextStyle(color: Colors.black87),
                        ),
                        subtitle: Text(
                          history[index]['date']!,
                          style: TextStyle(color: Colors.black54),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
