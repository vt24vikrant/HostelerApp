import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import './models/leave.dart';
import 'package:http/http.dart' as http;

class LeavePage extends StatelessWidget {
  final String roll_number;
  LeavePage({required this.roll_number});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Leave",
          style: TextStyle(fontSize: 20.0),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Color.fromARGB(255, 23, 228, 194),
      body: LeaveMainPage(
        roll_number: roll_number,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLeaveDialog(context, roll_number);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showAddLeaveDialog(BuildContext context, String roll_number) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddLeaveDialog(roll_number: roll_number);
      },
    );
  }
}

class LeaveMainPage extends StatefulWidget {
  final String roll_number;

  LeaveMainPage({required this.roll_number});
  @override
  State<LeaveMainPage> createState() => _LeaveMainPageState();
}

class _LeaveMainPageState extends State<LeaveMainPage> {
  List<Leave>? leaveRequests;
  bool isLoaded = false;

  final String baseUrl =
      'https://hosteler-backend.onrender.com/base/attendance/leave/myleave/'; // Replace with your actual backend URL

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    leaveRequests = await getLeave(); // Use 'await' here

    if (leaveRequests != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  Future<List<Leave>> getLeave() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl${widget.roll_number}'));
      print(response.statusCode);


      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Leave> fetchedLeaveRequests = data.map((leaveData) {
          return Leave.fromMap(leaveData);
        }).toList();

        return fetchedLeaveRequests;
      } else {
        throw Exception('Failed to load leave requests');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load leave requests');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (leaveRequests!.isEmpty) {
      return Center(
        child: Text('No leave requests available.'),
      );
    } else {
      return ListView.builder(
        itemCount: leaveRequests!.length,
        itemBuilder: (context, index) {
          return LeaveItem(leave: leaveRequests![index]);
        },
      );
    }
  }
}

class LeaveItem extends StatelessWidget {
  final Leave leave;

  LeaveItem({required this.leave});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (leave.status) {
      case 'APPROVED':
        statusColor = Colors.green;
        break;
      case 'REJECTED':
        statusColor = Colors.red;
        break;
      case 'PENDING':
        statusColor = Colors.yellow;
        break;
      default:
        statusColor = Colors.grey;
        break;
    }

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          'Leave ID: ${leave.leave_id}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leave From: ${leave.leave_from}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            Text(
              'Leave To: ${leave.leave_to}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            Text(
              'Location: ${leave.leave_location}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            Text(
              'Reason: ${leave.reason_for_leave}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            Text(
              'Rebate: ${leave.rebate_associated}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            Text(
              'Created Time:${DateFormat('yyyy-MM-dd').format(DateTime.parse(leave.created_at))}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
            Text(
              'Updated Time: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(leave.updated_at))}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Text(
            leave.status,
            style: TextStyle(color: Colors.white),
          ),
        ),
        onTap: () {
          // Handle tapping on a leave request item
          // You can navigate to a detail page here if needed
        },
      ),
    );
  }
}

class AddLeaveDialog extends StatelessWidget {
  final String roll_number;
  AddLeaveDialog({required this.roll_number});
  TextEditingController _leaveFromController = TextEditingController();
  TextEditingController _leaveToController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();

    Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      controller.text = formattedDate;
    }
  }
  @override
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Leave Request'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _leaveFromController,
            decoration: InputDecoration(
              labelText: 'Leave From',
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  _selectDate(context, _leaveFromController);
                },
              ),
            ),
            // Handle input
          ),
          TextFormField(
            controller: _leaveToController,
            decoration: InputDecoration(
              labelText: 'Leave To',
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  _selectDate(context, _leaveToController);
                },
              ),
            ),
            // Handle input
          ),
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(labelText: 'Location'),
            // Handle input
          ),
          TextFormField(
            controller: _reasonController,
            decoration: InputDecoration(labelText: 'Reason'),
            // Handle input
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            _addLeaveRequest(context,
                roll_number); // Call the method to add the leave request
          },
          child: Text('Add Request'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  Future<void> _addLeaveRequest(
      BuildContext context, String roll_number) async {
    // Retrieve the values from the form fields and construct the request body
    String leaveFrom = _leaveFromController
        .text; // Retrieve the value from the Leave From field
    String leaveTo =
        _leaveToController.text; // Retrieve the value from the Leave To field
    String location =
        _locationController.text; // Retrieve the value from the Location field
    String reason =
        _reasonController.text; // Retrieve the value from the Reason field

    final Map<String, dynamic> requestBody = {
      'student': roll_number,
      'leave_from': leaveFrom,
      'leave_to': leaveTo,
      'leave_location': location,
      'reason_for_leave': reason,
      // 'rebate_associated':0.0,
    };

    try {
      final response = await http.post(
        Uri.parse(
            'https://hosteler-backend.onrender.com/base/attendance/leave/create/'),
        headers: <String, String>{
          'Content-Type':
              'application/json; charset=UTF-8', // Set the content type to JSON
        },
        body: jsonEncode(requestBody), // Encode your data as JSON
      );

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Leave Request Submitted Successfully')),
        );
        // Successful leave request addition, update your UI if needed
        // For example, you can refresh the list of leave requests.
        // Call a function to refresh the leave requests here.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to Add Leave Request. Please Try Again!')),
        );
        // Handle API error
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }

    Navigator.of(context).pop(); // Close the dialog
  }
}
