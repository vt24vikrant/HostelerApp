import 'package:flutter/material.dart';
import 'package:hostler/LoginPAge.dart';
import './LoginPAge.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostler',
      home: MyHomePage(),
      theme: ThemeData(
        accentColor: Color.fromARGB(255, 34, 241, 241),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        color: Color.fromARGB(255, 39, 238, 191),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 100),
              height: 150.0,
              width: 150.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/logo-white.png'),
                  fit: BoxFit.fill,
                ),
                shape: BoxShape.circle,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      primary: Color.fromARGB(255, 31, 31, 31),
                    ),
                    child:
                        Text('Log-In', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => myLoginPage()));
                    },
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.symmetric(
                //     horizontal: 20,
                //   ),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       elevation: 10,
                //       primary: Color.fromARGB(255, 31, 31, 31),
                //     ),
                //     child: Text('Sign-Up'),
                //     onPressed: null,
                //   ),
                // ),
              ],
            ),
          ],
        ));
  }
}
