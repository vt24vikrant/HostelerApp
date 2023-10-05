import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';// Import the http package

class AttendancePage extends StatefulWidget {
  final String roll_number;
  AttendancePage({required this.roll_number});
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String selectedDate = '';
  String attendanceStatus = 'Loading...'; // Initial status

  @override
  void initState() {
    super.initState();
    // Set the default value to the current date
    selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _fetchAttendanceData(selectedDate);
  }

  // Mock API endpoint, replace with your own backend URL
  final String baseUrl =
      'https://hosteler-backend.onrender.com/base/attendance/';

  void _showDatePicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        attendanceStatus = 'Loading...'; // Reset status to loading
      });

      // Fetch attendance data when date is selected
      _fetchAttendanceData(selectedDate);
    }
  }

void _fetchAttendanceData(String selectedDate) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl${widget.roll_number}/$selectedDate/'));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      // Parse the response as a List of dynamic
      final List<dynamic> dataList = json.decode(response.body);

      if (dataList.isNotEmpty) {
        // Access the 'status' field from the first item in the list
        final status = dataList[0]['status'];
        setState(() {
          attendanceStatus = status;
        });
      } else {
        setState(() {
          attendanceStatus = 'No data available';
        });
      }
    } else {
      setState(() {
        attendanceStatus = 'Data Unavailable';
      });
    }
  } catch (e) {
    setState(() {
      attendanceStatus = 'Error: $e';
    });
  }
}



  @override
  Widget build(BuildContext context) {
    DateTime time = DateFormat('yyyy-MM-dd').parse(selectedDate);
    String date = selectedDate;

    Color circleColor;
    switch (attendanceStatus) {
      case 'PRESENT':
        circleColor = Colors.green;
        break;
      case 'ABSENT':
        circleColor = Colors.red;
        break;
      case 'LEAVE':
        circleColor = Colors.yellow;
        break;
      default:
        circleColor = Colors.black;
        break;
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Attendance Page'),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Attendance',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Date: $date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: circleColor,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      attendanceStatus,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () {
                  _showDatePicker(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),
                child: Text(
                  'Select Date',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}