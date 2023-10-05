// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Student {
  final String id;
  final String first_name;
  final String roll_number;
  // final String room;
  final String address;
  final String email_address;
  final String contact_number;
  final String photo;
  Student({
    required this.id,
    required this.first_name,
    required this.roll_number,
    // required this.room,
    required this.address,
    required this.email_address,
    required this.contact_number,
    required this.photo,
  });

  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': first_name,
      'roll_number': roll_number,
      // 'room': room,
      'address': address,
      'email': email_address,
      'contact': contact_number,
      'photo': photo,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? '',
      first_name: map['first_name'] ?? '',
      roll_number: map['roll_number'] ?? '',
      // room: map['room'] ?? '',
      address: map['address'] ?? '',
      email_address: map['email_address'] ?? '',
      contact_number: map['contact_number'] ?? '',
      photo: map['photo'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) => Student.fromMap(json.decode(source));
}
