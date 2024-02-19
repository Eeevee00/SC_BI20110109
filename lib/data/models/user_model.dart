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
  bool? is_approved; //added
  bool? is_rejected; //added
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
    this.is_approved,//added
    this.is_rejected,//added
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
        is_approved: doc['is_approved'],
        is_rejected: doc['is_rejected'],
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
    'is_approved': is_approved,
    'is_rejected': is_rejected,
    'points': points,
    'total_point': total_point,
    'bio': bio,
    'hashtag': hashtag,
    'tier': tier,
    'location': location,
  };
  // factory Users.fromDocument(DocumentSnapshot doc) {
  //   return Users(
  //       name: doc['name'],
  //       uid: doc['uid'],
  //       user_type: doc['user_type'],
  //       status: doc['status'],
  //       phone: doc['phone'],
  //       email: doc['email'],
  //       request_to_verify: doc['request_to_verify'],
  //       verification: doc['verification'],
  //       image: doc['image'] != null
  //           ? List.generate(doc['image'].length, (index) {
  //               return doc['image'][index];
  //             })
  //           : [],
  //       proof_for_verification_1: doc['proof_for_verification_1'] != null
  //           ? List.generate(doc['proof_for_verification_1'].length, (index) {
  //               return doc['proof_for_verification_1'][index];
  //             })
  //           : [],
  //       proof_for_verification_2: doc['proof_for_verification_2'] != null
  //           ? List.generate(doc['proof_for_verification_2'].length, (index) {
  //               return doc['proof_for_verification_2'][index];
  //             })
  //           : [],
  //       points: doc['points'],
  //       total_point: doc['total_point'],
  //       bio: doc['bio'],
  //       hashtag: doc['hashtag'],
  //       tier: doc['tier'],
  //       location: doc['location'],
  //   );
  // }

  factory Users.fromDocument(DocumentSnapshot doc) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  return Users(
    name: data['name'],
    uid: data['uid'],
    user_type: data['user_type'],
    status: data['status'],
    phone: data['phone'],
    email: data['email'],
    request_to_verify: data['request_to_verify'],
    verification: data['verification'],
    is_approved: data['is_approved'],
    is_rejected: data['is_rejected'],
    // image: data['image'] != null ? List<String>.from(data['image']) : [],
    // proof_for_verification_1: data['proof_for_verification_1'] != null
    //     ? List<String>.from(data['proof_for_verification_1'])
    //     : [],
    // proof_for_verification_2: data['proof_for_verification_2'] != null
    //     ? List<String>.from(data['proof_for_verification_2'])
    //     : [],
    image: _convertToList(data['image']),
    proof_for_verification_1: _convertToList(data['proof_for_verification_1']),
    proof_for_verification_2: _convertToList(data['proof_for_verification_2']),

    points: data['points'],
    total_point: data['total_point'],
    bio: data['bio'] ?? "", // Handle null bio
    hashtag: data['hashtag'] != null ? List<String>.from(data['hashtag']) : [],
    tier: data['tier'] ?? "", // Handle null tier
    location: data['location'] != null ? Map<String, dynamic>.from(data['location']) : {},
  );
}

}

List<String> _convertToList(dynamic value) {
  if (value is String) {
    // Handle the case where value is a string
    return [value];
  } else if (value is List<dynamic>) {
    // Handle the case where value is already a list
    return List<String>.from(value.cast<String>());
  } else {
    // Handle other cases or return an empty list if needed
    return [];
  }
}
