import 'package:flutter/material.dart';

class MoreDetailsPage extends StatelessWidget {
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'More Details',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Card(
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
                        'App Usage',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'LabTechCare is designed to help you manage and maintain the devices in your lab efficiently. Here are some of the key features:',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green, size: 30),
                        title: Text('Track device issues and maintenance schedules'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green, size: 30),
                        title: Text('Receive real-time notifications for urgent tasks'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green, size: 30),
                        title: Text('Easy-to-use interface for logging and resolving issues'),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Benefits',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Using LabTechCare offers numerous benefits including:',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.star, color: Colors.blue, size: 30),
                        title: Text('Improved efficiency in managing lab devices'),
                      ),
                      ListTile(
                        leading: Icon(Icons.star, color: Colors.blue, size: 30),
                        title: Text('Reduction in device downtime and maintenance costs'),
                      ),
                      ListTile(
                        leading: Icon(Icons.star, color: Colors.blue, size: 30),
                        title: Text('Better organization and record-keeping of maintenance activities'),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/saa.png', // تأكد من تطابق المسار مع صورة الشعار
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'LabTechCare - Your Partner in Lab Management',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
