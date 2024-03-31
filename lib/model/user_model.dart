import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? address;
  List<String>? roles;
  String? user_image;

  UserModel({this.uid, this.email, this.firstName, this.secondName, this.address, this.roles, this.user_image});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      address: map['address'],
      roles: List<String>.from(map['roles'] ?? []),
      user_image: map['user_image']
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'address': address,
      'roles': roles,
      'user_image':user_image,
    };
  }
}
