import 'dart:convert';

class Attendance
{
  final String date;
  final String status;


  Attendance(
    {
      required this.date, 
      required this.status,
    }
  );
}