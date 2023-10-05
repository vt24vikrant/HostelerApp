import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hostler/models/complaint.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ComplaintPage extends StatelessWidget {
  final String roll_number;
  ComplaintPage({required this.roll_number});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Complaints",
          style: TextStyle(fontSize: 20.0),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Color.fromARGB(255, 23, 228, 194),
      body: ComplaintMainPage(
        roll_number: roll_number,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddComplaintDialog(context, roll_number);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showAddComplaintDialog(BuildContext context, String roll_number) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddComplaintDialog(
            roll_number: roll_number); // Pass the roll_number
      },
    );
  }
}

class ComplaintMainPage extends StatefulWidget {
  final String roll_number;

  ComplaintMainPage({required this.roll_number});
  @override
  State<ComplaintMainPage> createState() => _ComplaintMainPageState();
}

class _ComplaintMainPageState extends State<ComplaintMainPage> {
  List<Complaint>? complaints;
  bool isLoaded = false;

  final String baseUrl =
      'https://hosteler-backend.onrender.com/base/complaint/mycomplaint/';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    complaints = await getComplaints(); // Use 'await' here

    if (complaints != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  Future<List<Complaint>> getComplaints() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl${widget.roll_number}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Complaint> fetchedComplaints = data.map((complaintData) {
          return Complaint.fromMap(complaintData);
        }).toList();

        return fetchedComplaints;
      } else {
        throw Exception('Failed to load complaints');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load complaints');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (complaints!.isEmpty) {
      return Center(
        child: Text('No complaints available.'),
      );
    } else {
      return ListView.builder(
        itemCount: complaints!.length,
        itemBuilder: (context, index) {
          return ComplaintItem(complaint: complaints![index]);
        },
      );
    }
  }
}

class ComplaintItem extends StatelessWidget {
  final Complaint complaint;

  ComplaintItem({required this.complaint});

  @override
  Widget build(BuildContext context) {
    Widget statusIcon;

    switch (complaint.status) {
      case 'RESOLVED':
        statusIcon = Icon(Icons.check_circle, color: Colors.green);
        break;
      case 'UNDER PROGRESS':
        statusIcon = Icon(Icons.check_circle, color: Colors.yellow);
        break;
      case 'PENDING':
        statusIcon = Row(
          children: [
            Icon(
              Icons.circle,
              color: Colors.yellow,
              size: 15,
            ),
          ],
        );
        break;
      default:
        statusIcon = SizedBox.shrink();
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
          'Complaint ID: ${complaint.complaint_id}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location: ${complaint.location}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Type: ${complaint.category}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Description: ${complaint.description}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Created At: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(complaint.created_at))}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Last Updated: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(complaint.updated_at))}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                statusIcon,
                SizedBox(width: 8),
                Text(
                  complaint.status,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}

class AddComplaintDialog extends StatefulWidget {
  final String roll_number;
  AddComplaintDialog({required this.roll_number});
  @override
  State<AddComplaintDialog> createState() =>
      _AddComplaintDialogState(roll_number: roll_number);
}

class _AddComplaintDialogState extends State<AddComplaintDialog> {
  final String roll_number;

  TextEditingController _locationController = TextEditingController();

  TextEditingController _descriptionController = TextEditingController();

  String _selectedType = 'ELECTRICAL';
  // Default value
  List<String> _complaintTypes = [
    'ELECTRICAL',
    'PLUMBING',
    'CARPENTRY',
    'SANITATION',
    'OTHERS', // Added 'Others' option
  ];

  _AddComplaintDialogState({required this.roll_number});

  @override
  void initState() {
    super.initState();
    // Initialize rollNumber here
  }

  Future<void> _addComplaint(BuildContext context, String roll_number) async {
    String location = _locationController.text;
    String description = _descriptionController.text;

    if (_selectedType.isEmpty || location.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Each Field is Mandatory')),
      );
      return;
    }

    try {
      final Map<String, dynamic> requestBody = {
        'student': roll_number,
        'category': _selectedType,
        'location': location,
        'description': description,
      };

      final response = await http.post(
        Uri.parse(
            'https://hosteler-backend.onrender.com/base/complaint/create/'),
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
          SnackBar(content: Text('Complaint Submitted Successfully')),
        );
        // Successful complaint addition, update your UI if needed
        // For example, you can refresh the list of complaints.
        // Call a function to refresh the complaints here.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Add Complaint. Please Try Again!')),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Complaint'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: _selectedType,
            items: _complaintTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                // Update the selected type when the dropdown value changes
                _selectedType = newValue;
              }
            },
          ),
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(labelText: 'Location'),
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            _addComplaint(
                context, roll_number); // Call the method to add the complaint
          },
          child: Text('Add Complaint'),
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
}
