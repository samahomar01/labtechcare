import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MoreDetailsPage extends StatefulWidget {
  @override
  _MoreDetailsPageState createState() => _MoreDetailsPageState();
}

class _MoreDetailsPageState extends State<MoreDetailsPage> {
  List<dynamic> reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/myprojectt/get_reviews.php'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            reviews = data['reviews'];
          });
        } else {
          print('Failed to load reviews: ${data['message']}');
        }
      } else {
        print('Failed to load reviews: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading reviews: $e');
    }
  }

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
              SizedBox(height: 20),
              Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              reviews.isEmpty
                  ? Center(child: Text('No reviews found', style: TextStyle(color: Colors.white)))
                  : Column(
                      children: reviews.map((review) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.white,
                          child: ListTile(
                            title: Text(review['comment']),
                            subtitle: Text('By: ${review['user_name']} on ${review['created_at']}'),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}