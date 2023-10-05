import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final Color color;
  final String icon;

  const Category({
    required this.id,
    required this.title,
    this.color = const Color.fromARGB(255, 241, 229, 229),
    required this.icon,
  });
}
