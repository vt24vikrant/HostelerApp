import 'dart:convert';

class Complaint {
  final String student;
  final int complaint_id;
  final String category;
  final String location;
  final String description;
  final String status;
  final String remarks;
  final String created_at;
  final String updated_at;

  Complaint({
    required this.student,
    required this.complaint_id,
    required this.category,
    required this.location,
    required this.description,
    required this.status,
    required this.remarks,
    required this.created_at,
    required this.updated_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'student': student,
      'complaint_id': complaint_id,
      'category': category,
      'location': location,
      'description': description,
      'status': status,
      'remarks': remarks,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  factory Complaint.fromMap(Map<String, dynamic> map) {
    return Complaint(
      student: map['student'] ?? '',
      complaint_id: map['complaint_id'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? '',
      remarks: map['remarks'] ?? '',
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Complaint.fromJson(String source) =>
      Complaint.fromMap(json.decode(source));
}
