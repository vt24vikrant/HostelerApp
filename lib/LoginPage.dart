import 'package:flutter/material.dart';
import 'package:hostler/MainPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class myLoginPage extends StatefulWidget {
  @override
  _myLoginPageState createState() => _myLoginPageState();
}

class _myLoginPageState extends State<myLoginPage> {
  final storage = FlutterSecureStorage();
  String username = "";
  String password = "";

  Future<String?> login(String username, String password) async {
    final Map<String, String> data = {
      'roll_number': username,
      'password': password,
    };

    final String jsonData = json.encode(data);

    final response = await http.post(
      Uri.parse('https://hosteler-backend.onrender.com/base/student/login/'),
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
      },
      body: jsonData,
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final token = response.body;
      await storage.write(key: 'jwt_token', value: token);
      return token;
    } else {
      throw Exception('Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(backgroundColor: Color.fromARGB(255, 23, 228, 194)),
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 23, 228, 194),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(
                  fontSize: 35,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Form(
                  child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter Username',
                      prefixIcon: Icon(Icons.account_circle),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        username = value;
                      });
                    },
                    validator: (value) {
                      return value!.isEmpty ? 'Please Enter Username' : null;
                    },
                  )
                ],
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Form(
                  child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter Password',
                      prefixIcon: Icon(Icons.key),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        password = value;
                      });
                    },
                    obscureText: true,
                    validator: (value) {
                      return value!.isEmpty ? 'Please Enter password' : null;
                    },
                  )
                ],
              )),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                  ),
                  onPressed: () async {
                    try {
                      final token = await login(username,
                          password); // Replace with actual username and password
                      if (token != null) {
                        // Login successful, navigate to MainPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainPage( roll_number:username),),
                        );
                      } else {
                        // Handle login failure
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invalid Credentials')),
                        );
                      }
                    } catch (e) {
                      // Handle exceptions, e.g., network errors
                      print('Error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('An error occurred. Please try again.')),
                      );
                    }
                  },
                  child: Text('Login'),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: InkWell(
                onTap: () {},
                child: Text('Forgot Password?'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
