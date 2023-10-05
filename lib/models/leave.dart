import 'dart:convert';

import 'dart:ffi';

class Leave {
  final String student;
  final int leave_id;
  final String leave_from;
  final String leave_to;
  final String leave_location;
  final String reason_for_leave;
  final String status;
  final String rebate_associated;
  final String created_at;
  final String updated_at;

  Leave({
    required this.student,
    required this.leave_id,
    required this.leave_from,
    required this.leave_to,
    required this.leave_location,
    required this.reason_for_leave,
    required this.status,
    required this.rebate_associated,
    required this.created_at,
    required this.updated_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'student': student,
      'leave_id': leave_id,
      'leave_from': leave_from,
      'leave_to': leave_to,
      'location': leave_location,
      'reason': reason_for_leave,
      'status': status,
      'rebate' : rebate_associated,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  factory Leave.fromMap(Map<String, dynamic> map) {
    return Leave(
      student: map['student'] ?? '',
      leave_id: map['leave_id']?.toInt() ?? 0,
      leave_from: map['leave_from'] ?? '',
      leave_to: map['leave_to'] ?? '',
      leave_location: map['leave_location'] ?? '',
      reason_for_leave: map['reason_for_leave'] ?? '',
      status: map['status'] ?? '',
      rebate_associated: map['rebate_associated'] ?? '',
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Leave.fromJson(String source) => Leave.fromMap(json.decode(source));
}
