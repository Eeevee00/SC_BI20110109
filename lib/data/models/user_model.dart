import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Users {
  String? name;
  String? email;
  String? uid;
  List? image = [];
  String? user_type;
  String? phone;
  bool? status;
  bool? request_to_verify;
  bool? verification;
  List? proof_for_verification_1 = [];
  List? proof_for_verification_2 = [];
  int? points;
  int? total_point;
  String? bio;
  List? hashtag = [];
  String? tier;
  Map<String, dynamic>? location;
  
  Users({
    @required this.name,
    @required this.uid,
    @required this.image, 
    this.proof_for_verification_1, 
    this.proof_for_verification_2, 
    this.user_type,
    this.phone,  
    this.status, 
    this.email, 
    this.request_to_verify, 
    this.verification, 
    this.points,
    this.total_point,
    this.bio,
    this.hashtag,
    this.tier,
    this.location,
  });

  factory Users.fromJson(Map<String, dynamic> doc) {
    return Users(
        name: doc['name'],
        uid: doc['uid'],
        user_type: doc['user_type'],
        status: doc['status'],
        phone: doc['phone'],
        email: doc['email'],
        request_to_verify: doc['request_to_verify'],
        verification: doc['verification'],
        image: doc['image'] != null
            ? List.generate(doc['image'].length, (index) {
                return doc['image'][index];
              })
            : [],
        proof_for_verification_1: doc['proof_for_verification_1'] != null
            ? List.generate(doc['proof_for_verification_1'].length, (index) {
                return doc['proof_for_verification_1'][index];
              })
            : [],
        proof_for_verification_2: doc['proof_for_verification_2'] != null
            ? List.generate(doc['proof_for_verification_2'].length, (index) {
                return doc['proof_for_verification_2'][index];
              })
            : [],
        points: doc['points'],
        total_point: doc['total_point'],
        bio: doc['bio'],
        hashtag: doc['hashtag'],
        tier: doc['tier'],
        location: doc['location'],
    );
  }



  Map<String, dynamic> toJson() => {
    'name': name,
    'uid': uid,
    'image': image,
    'proof_for_verification_1': proof_for_verification_1,
    'proof_for_verification_2': proof_for_verification_2,
    'user_type': user_type,
    'status': status,
    'phone': phone,
    'email': email,
    'request_to_verify': request_to_verify,
    'verification': verification,
    'points': points,
    'total_point': total_point,
    'bio': bio,
    'hashtag': hashtag,
    'tier': tier,
    'location': location,
  };
  factory Users.fromDocument(DocumentSnapshot doc) {
    return Users(
        name: doc['name'],
        uid: doc['uid'],
        user_type: doc['user_type'],
        status: doc['status'],
        phone: doc['phone'],
        email: doc['email'],
        request_to_verify: doc['request_to_verify'],
        verification: doc['verification'],
        image: doc['image'] != null
            ? List.generate(doc['image'].length, (index) {
                return doc['image'][index];
              })
            : [],
        proof_for_verification_1: doc['proof_for_verification_1'] != null
            ? List.generate(doc['proof_for_verification_1'].length, (index) {
                return doc['proof_for_verification_1'][index];
              })
            : [],
        proof_for_verification_2: doc['proof_for_verification_2'] != null
            ? List.generate(doc['proof_for_verification_2'].length, (index) {
                return doc['proof_for_verification_2'][index];
              })
            : [],
        points: doc['points'],
        total_point: doc['total_point'],
        bio: doc['bio'],
        hashtag: doc['hashtag'],
        tier: doc['tier'],
        location: doc['location'],
    );
  }
}
