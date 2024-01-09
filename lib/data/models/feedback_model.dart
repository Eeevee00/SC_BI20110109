import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Feedbacks {
  String? content;
  String? sender_email;
  String? sender_name;
  String? sender_uid;
  String? uid;
  String? subject;
  dynamic timestamp;

  Feedbacks({
    @required this.content,
    @required this.sender_email,
    @required this.sender_name,
    @required this.sender_uid,
    @required this.uid,
    @required this.subject,
    @required this.timestamp,
  });

  factory Feedbacks.fromJson(Map<String, dynamic> doc) {
    return Feedbacks(
      content: doc['content'],
      sender_email: doc['sender_email'],
      sender_name: doc['sender_name'],
      sender_uid: doc['sender_uid'],
      uid: doc['uid'],
      subject: doc['subject'],
      timestamp: doc['timestamp'],
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content,
        'sender_email': sender_email,
        'sender_name': sender_name,
        'sender_uid': sender_uid,
        'uid': uid,
        'subject': subject,
        'timestamp': timestamp,
      };

  factory Feedbacks.fromDocument(DocumentSnapshot doc) {
    return Feedbacks(
      content: doc['content'],
      sender_email: doc['sender_email'],
      sender_name: doc['sender_name'],
      sender_uid: doc['sender_uid'],
      uid: doc['uid'],
      subject: doc['subject'],
      timestamp: doc['timestamp'],
    );
  }
}
