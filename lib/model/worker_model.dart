import 'package:cloud_firestore/cloud_firestore.dart';

class WorkerModel {
  String? wid;
  String? email;
  String? name;
  String? address;
  List<String>? roles;
  String? provider_image; 

  WorkerModel({this.wid, this.email, this.name, this.address,  this.roles, this.provider_image});

  // receiving data from server
  factory WorkerModel.fromMap(map) {
    return WorkerModel(
      wid: map['wid'],
      email: map['email'],
      name: map['name'],
      address: map['address'],
      roles: List<String>.from(map['roles'] ?? []),
      provider_image: map['provider_image'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'wid': wid,
      'email': email,
      'name': name,
      'address': address,
      'roles': roles,
      'provider_image':provider_image,
    };
  }
}