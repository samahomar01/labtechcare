import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_page.dart'; 

class IssueTicketPage extends StatefulWidget {
  @override
  _IssueTicketPageState createState() => _IssueTicketPageState();
}

class _IssueTicketPageState extends State<IssueTicketPage> {
  final TextEditingController _detailsController = TextEditingController();
  final String _state = 'open'; 

  Future<void> _submitIssue() async {
    final details = _detailsController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (details.isEmpty || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter all required details')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/myprojectt/report_issue.php'), // استخدم 10.0.2.2 للمحاكي
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userId,
          'state': _state,
          'issue': details,
        }),
      );

      print('Request body: ${jsonEncode(<String, dynamic>{
        'user_id': userId,
        'state': _state,
        'issue': details,
      })}'); // طباعة البيانات المرسلة
      print('Response body: ${response.body}'); // طباعة الاستجابة لتتبعها

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Issue reported successfully!')),
          );
          _detailsController.clear(); // مسح الحقول بعد الإرسال الناجح
          Navigator.pop(context, true); // تمرير true عند النجاح
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Report failed: ${data['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print(e); // طباعة أي خطأ يحدث
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // تعيين ارتفاع الـ AppBar
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0), // زيادة المسافة من الأعلى
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white), // تغيير لون السهم إلى الأبيض
                  onPressed: () {
                    Navigator.pop(context, false); // تمرير false عند الإلغاء
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Report a Problem',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Details',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _detailsController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _submitIssue, // قم بإضافة منطق الإرسال هنا
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Submit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false); // تمرير false عند الإلغاء
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 130, 126, 126),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
