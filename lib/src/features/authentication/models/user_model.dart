import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String phoneNo;
  final String password;
  final String address;
  final GeoPoint location;

  const UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNo,
    required this.password,
    required this.address,
    required this.location,
  });

  toJson(){
    return {
      'Full Name' : fullName,
      'Email' : email,
      'Phone' : phoneNo,
      'Password' : password,
      'Address' : address,
      'Location' : location,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return UserModel(
      id : document.id,
      fullName : data['Full Name'],
      email: data['Email'],
      phoneNo: data['Phone'],
      password: data['Password'],
      address: data['Address'],
      location: data['Location'],
    );
  }
}