import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Claim {
    String? claim_by_name;
    String? claim_by_uid;
    String? point_required;
    bool? status;
    dynamic timestamp;
    String? title;
    String? uid;
    List? user_image = [];
    String? reward_uid;
    String? status_text;

    Claim({
        @required this.claim_by_name,
        @required this.claim_by_uid,
        @required this.point_required,
        @required this.status,
        @required this.timestamp,
        @required this.title,
        @required this.uid,
        this.user_image,
        this.reward_uid,
        this.status_text,
    });

    factory Claim.fromJson(Map<String, dynamic> doc) {
        return Claim(
            claim_by_name: doc['claim_by_name'],
            claim_by_uid: doc['claim_by_uid'],
            point_required: doc['point_required'],
            status: doc['status'],
            timestamp: doc['timestamp'],
            title: doc['title'],
            uid: doc['uid'],
            user_image: doc['user_image'],
            reward_uid: doc['reward_uid'],
            status_text: doc['status_text'],
        );
    }

    Map<String, dynamic> toJson() => {
        'claim_by_name': claim_by_name,
        'claim_by_uid': claim_by_uid,
        'point_required': point_required,
        'status': status,
        'timestamp': timestamp,
        'title': title,
        'uid': uid,
        'user_image': user_image,
        'reward_uid': reward_uid,
        'status_text': status_text,
    };

    // factory Claim.fromDocument(DocumentSnapshot doc) {
    //     return Claim(
    //         claim_by_name: doc['claim_by_name'],
    //         claim_by_uid: doc['claim_by_uid'],
    //         point_required: doc['point_required'],
    //         status: doc['status'],
    //         timestamp: doc['timestamp'],
    //         title: doc['title'],
    //         uid: doc['uid'],
    //         user_image: doc['user_image'],
    //         reward_uid: doc['reward_uid'],
    //         status_text: doc['status_text'],
    //     );
    // }

        factory Claim.fromDocument(DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Claim(
            claim_by_name: data['claim_by_name'],
            claim_by_uid: data['claim_by_uid'],
            point_required: data['point_required'],
            status: data['status'],
            timestamp: data['timestamp'],
            title: data['title'],
            uid: data['uid'],
            user_image: data['user_image'],
            reward_uid: data['reward_uid'],
            status_text: data['status_text'],
        );
    }
}
