import 'dart:convert';

import 'package:flutter/material.dart';
import './models/student.dart';
import 'package:http/http.dart' as http;

// https://hosteler-backend.onrender.com

class Profile extends StatefulWidget {
  final String roll_number;
  const Profile({required this.roll_number});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Student? studentData;
  final String studentbaseUrl =
      'https://hosteler-backend.onrender.com/base/student/';

  void getStudentDetails(String rollNumber) async {
    final String studentDetailsUrl = '$studentbaseUrl$rollNumber/';
    final Uri uri = Uri.parse(studentDetailsUrl); // Convert String URL to Uri
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print(response.body);
      if (response.body.isNotEmpty) {
        setState(() {
          studentData = Student.fromJson(response.body);
        });
      }
    } else {
      throw Exception('Failed to load student details');
    }
  }

  @override
  void initState() {
    getStudentDetails(widget.roll_number);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (studentData == null || studentData!.photo == null) {
    // Handle the case where studentData or studentData!.photo is null
    // You can show a loading indicator, an error message, or a placeholder image
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Center(
        child: CircularProgressIndicator(), // Show loading indicator
      ),
    );
  }
    String imageUrl = studentData!.photo; // Your full image URL
    String cleanUrl = '';
// Check if the URL starts with 'http'
    if (imageUrl.startsWith('http')) {
      // Use imageUrl as is
      cleanUrl = imageUrl;
    } else {
      // Remove the unwanted prefix
      int startIndex = imageUrl.indexOf('http');
      if (startIndex != -1) {
        cleanUrl = imageUrl.substring(startIndex);
      } else {
        // Handle the case where 'http' is not found
        // You can show an error message or use a default image URL
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Center(
        child: studentData == null
            ? CircularProgressIndicator()
            : Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(
                        cleanUrl,
                        // studentData!.photo,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Text(
                    //   'Room No: ${studentData!.room}',
                    //   style: TextStyle(
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    SizedBox(height: 10),
                    Text(
                      'Name: ${studentData!.first_name}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Roll: ${studentData!.roll_number}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text('Email'),
                      subtitle: Text(studentData!.email_address),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Contact'),
                      subtitle: Text(studentData!.contact_number),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Address'),
                      subtitle: Text(studentData!.address),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
