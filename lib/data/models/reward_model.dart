import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Reward {
  String? name;
  List? image = [];
  String? point;
  String? text_status;
  dynamic timestamp;
  String? quantity;
  String? description;
  String? uid;
  bool? status;

  Reward({
    @required this.name,
    @required this.image, 
    @required this.timestamp,
    @required this.point,
    @required this.text_status,
    @required this.quantity,
    @required this.description,
    @required this.uid,
    @required this.status,
  });

  factory Reward.fromJson(Map<String, dynamic> doc) {
    return Reward(
      name: doc['name'],
      timestamp: doc['timestamp'],
      point: doc['point'],
      text_status: doc['text_status'],
      quantity: doc['quantity'],
      description: doc['description'],
      uid: doc['uid'],
      status: doc['status'],
      image: doc['image'] != null
            ? List.generate(doc['image'].length, (index) {
                return doc['image'][index];
              })
            : []
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'timestamp': timestamp,
        'point': point,
        'text_status': text_status,
        'quantity': quantity,
        'description': description,
        'uid': uid,
        'status': status,
      };

  factory Reward.fromDocument(DocumentSnapshot doc) {
    return Reward(
      name: doc['name'],
      timestamp: doc['timestamp'],
      point: doc['point'],
      text_status: doc['text_status'],
      quantity: doc['quantity'],
      description: doc['description'],
      uid: doc['uid'],
      status: doc['status'],
      image: doc['image'] != null
            ? List.generate(doc['image'].length, (index) {
                return doc['image'][index];
              })
            : []
    );
  }
}
