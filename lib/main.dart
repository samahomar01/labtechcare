import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'login_page.dart';
import 'moreDetailsPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(LabTechCareApp());
}

class LabTechCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartupScreen(),
    );
  }
}

class StartupScreen extends StatefulWidget {
  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 36, 117, 154), 
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/saa.png', // تأكد من تطابق المسار
                  width: 200, // زيادة عرض الصورة
                  height: 200, // زيادة ارتفاع الصورة
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'LabTechCare',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(221, 255, 255, 255),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[100], // لون خلفية الأزرار
                  foregroundColor: Color.fromARGB(221, 0, 0, 0), // لون النص للأزرار
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text('Sign Up'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[100], // لون خلفية الأزرار
                  foregroundColor: Colors.black87, // لون النص للأزرار
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text('Log in'),
              ),
              SizedBox(height: 40),
              Text(
                'Computer Lab Maintenance',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(241, 255, 255, 255),
                ),
              ),
              SizedBox(height: 20), // مسافة إضافية بين النص والرابط
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MoreDetailsPage()),
                  );
                },
                child: Text(
                  'More Details',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 255, 255, 255), // لون النص للرابط
                    decoration: TextDecoration.underline, // لإضافة خط تحت النص
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
