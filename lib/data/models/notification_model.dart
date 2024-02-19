import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Notifications {
  String? content;
  dynamic created_by;
  dynamic timestamp;
  dynamic title;
  dynamic uid;

  Notifications({
    @required this.content,
    @required this.created_by,
    @required this.timestamp,
    @required this.title,
    @required this.uid,
  });

  factory Notifications.fromJson(Map<String, dynamic> doc) {
    return Notifications(
      content: doc['content'],
      created_by: doc['created_by'],
      timestamp: doc['timestamp'],
      title: doc['title'],
      uid: doc['uid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content,
        'created_by': created_by,
        'timestamp': timestamp,
        'title': title,
        'uid': uid,
      };

  factory Notifications.fromDocument(DocumentSnapshot doc) {
    return Notifications(
      content: doc['content'],
      created_by: doc['created_by'],
      timestamp: doc['timestamp'],
      title: doc['title'],
      uid: doc['uid'],
    );
  }
}
