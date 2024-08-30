import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashboardt_page.dart'; // استيراد صفحة لوحة التحكم للفني

class TechnicianReplyPage extends StatefulWidget {
  final int reportId;
  final String userDescription;
  final int userId;

  TechnicianReplyPage({required this.reportId, required this.userDescription, required this.userId});

  @override
  _TechnicianReplyPageState createState() => _TechnicianReplyPageState();
}

class _TechnicianReplyPageState extends State<TechnicianReplyPage> {
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController solutionController = TextEditingController();
  final TextEditingController relatedEquipmentController = TextEditingController();

  Future<void> _submitReply(String status) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/myprojectt/save_reply.php'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'ticket_id': widget.reportId,
          'diagnosis': diagnosisController.text,
          'solution': solutionController.text,
          'status': status,
          'equipment': relatedEquipmentController.text,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reply submitted successfully!')),
        );
        Navigator.pop(context, true); // إرجاع النتيجة عند الرد بنجاح
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit reply: ${data['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
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
              'Technician Reply',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ],
        ),
        backgroundColor: Color(0xFF0288D1), // لون أزرق فاتح
      ),
      backgroundColor: Color(0xFFE1F5FE), // لون خلفية فاتح
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ticket Number: ${widget.reportId}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF01579B), // لون أزرق داكن
                ),
              ),
              SizedBox(height: 10),
              Text(
                'User Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF01579B), // لون أزرق داكن
                ),
              ),
              Text(
                widget.userDescription,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: relatedEquipmentController,
                decoration: InputDecoration(
                  labelText: 'Related Equipment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: diagnosisController,
                decoration: InputDecoration(
                  labelText: 'Diagnosis',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: solutionController,
                decoration: InputDecoration(
                  labelText: 'Solution',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // التحقق من أن الحقول ليست فارغة
                      if (diagnosisController.text.isEmpty || solutionController.text.isEmpty || relatedEquipmentController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill in all fields before submitting.')),
                        );
                      } else {
                        _submitReply('solved');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text('Solved'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // التحقق من أن الحقول ليست فارغة
                      if (diagnosisController.text.isEmpty || solutionController.text.isEmpty || relatedEquipmentController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill in all fields before submitting.')),
                        );
                      } else {
                        _submitReply('pending');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text('Pending'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
