import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String emailId;
  final String mobile;
  final String country;
  final String state;
  final String district;
  final String avatar;

  User({
    required this.id,
    required this.name,
    required this.emailId,
    required this.mobile,
    required this.country,
    required this.state,
    required this.district,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      emailId: json['emailId'],
      mobile: json['mobile'],
      country: json['country'],
      state: json['state'],
      district: json['district'],
      avatar: json['avatar'],
    );
  }
}
