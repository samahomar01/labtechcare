import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ticket_details_page.dart';
import 'Ticket_Cards.dart';
import 'AssignTechnicianPage.dart'; // تعديل الاستيراد الصحيح لصفحة تعيين الفني
import 'notifications_page.dart'; // استيراد صفحة الإشعارات
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart'; // استيراد صفحة تسجيل الدخول
import 'dashboards_page.dart'; // تأكد من استيراد الصفحة المناسبة

class AddReviewPage extends StatefulWidget {
  final int userId;

  AddReviewPage({required this.userId});

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/myprojectt/add_review.php'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': widget.userId,
          'comment': _commentController.text,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review submitted successfully!')),
        );
        Navigator.pop(context, true); // العودة إلى الصفحة السابقة
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit review: ${data['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white), // السهم الأبيض
                onPressed: () {
                  Navigator.pop(context); // العودة إلى الصفحة السابقة
                },
              ),
              SizedBox(width: 10),
              Text(
                'Add Review',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xFF0288D1), // لون أزرق فاتح
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Please add your review:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Your Review',
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Review cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                child: _isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Submit Review'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0288D1)), // تعيين لون خلفية الزر
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // تعيين لون النص
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 15.0)), // تعيين الحشو
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>( // تعيين شكل الزر
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
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
