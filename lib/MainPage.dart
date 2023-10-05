import 'package:flutter/material.dart';
import 'package:hostler/LoginPage.dart';
import 'package:hostler/attendance.dart';
import 'package:hostler/my_profile.dart';
import 'package:hostler/complaintPage.dart';
import 'models/category.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'LeavePage.dart';
import 'my_profile.dart';
import './models/student.dart';
import 'dart:convert';

class MainPage extends StatelessWidget {
  final String roll_number;
  MainPage({required this.roll_number});

  
  final List<Category> options = const [
    Category(
      id: 'o2',
      title: 'ATTENDANCE',
      icon: 'images/attendance.png',
    ),
    Category(
      id: 'o3',
      title: 'COMPLAINT(s)',
      icon: 'images/complaints.png',
    ),
    Category(
      id: 'o4',
      title: 'LEAVE',
      icon: 'images/leave.png',
    ),
  ];

  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 23, 228, 194),
      appBar: AppBar(
        title: Text('Main Menu'),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'profile',
                  child: Text('My Profile'),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
            onSelected: (String value) async {
              // Add your code here to handle the selected option
              switch (value) {
                case 'profile':
                  
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(roll_number: roll_number),
                    ),
                  );
                  break;

                case 'logout':
                  print('Logout selected!');
                  await storage.delete(
                      key: 'jwt_token'); // Remove the JWT token from storage
                  Navigator.of(context).pushReplacement(
                    // Navigate back to the login screen
                    MaterialPageRoute(builder: (context) => myLoginPage()),
                  );
                  // Perform logout action
                  break;
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(25),
        itemCount: options.length,
        itemBuilder: (BuildContext context, int index) {
          Category catData = options[index];
          return GestureDetector(
            onTap: () async {
              try {
                final String? token = await storage.read(key: 'jwt_token');

                if (token != null) {
                  final Map<String, String> headers = {
                    'Authorization': 'Bearer $token',
                  };

                  switch (catData.id) {
                    case 'o2': // Attendance
                      // final response = await http.get(
                      //   Uri.parse('YOUR_ATTENDANCE_API_URL'),
                      //   headers: headers,
                      // );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AttendancePage(roll_number:roll_number)));
                      // Handle the response and navigate accordingly
                      break;

                    case 'o3': // Complaints
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ComplaintPage(roll_number:roll_number)));
                      // Handle the response and navigate accordingly
                      break;

                    case 'o4': // Leave
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LeavePage(roll_number:roll_number)));
                      // Handle the response and navigate accordingly
                      break;

                    default:
                      break;
                  }
                }
              } catch (e) {
                // Handle exceptions, e.g., network errors
                print('Error: $e');
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    if (catData.icon != null)
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(catData.icon),
                        ),
                      ),
                    Text(catData.title),
                  ],
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      catData.color.withOpacity(0.7),
                      catData.color,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
