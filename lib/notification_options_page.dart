import 'package:flutter/material.dart';

class NotificationOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Options'),
                backgroundColor: Color.fromARGB(255, 36, 117, 154), 
      ),
      backgroundColor: Color.fromARGB(255, 36, 117, 154), // لون خلفية الصفحة
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Options',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            OptionItem(
              icon: Icons.delete,
              text: 'Remove this notification',
              onTap: () {
                // قم بإضافة منطق إزالة الإشعار هنا
              },
            ),
            OptionItem(
              icon: Icons.notifications_off,
              text: 'Turn off notification',
              onTap: () {
                // قم بإضافة منطق إيقاف الإشعارات هنا
              },
            ),
            OptionItem(
              icon: Icons.notifications,
              text: 'Turn on notification',
              onTap: () {
                // قم بإضافة منطق تشغيل الإشعارات هنا
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  OptionItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: onTap,
      ),
    );
  }
}
