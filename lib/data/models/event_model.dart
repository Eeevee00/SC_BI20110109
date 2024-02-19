import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Event {
    //String? category;
    //dynamic deadline;
    String? description;
    dynamic end_date;
    dynamic end_time;
    List? image = [];
    Map<String, dynamic>? location;
    String? organizer_uid;
    String? organizer_name;
    String? organizer_email;
    String? organizer_image;
    dynamic start_date;
    dynamic start_time;
    bool? status;
    String? title;
    String? uid;
    String? phone;
    
    Event({
        //@required this.category,
       // @required this.deadline,
        @required this.description,
        @required this.end_date,
        @required this.end_time,
        @required this.image,
        @required this.location,
        @required this.organizer_uid,
        @required this.organizer_name,
        @required this.organizer_email,
        @required this.organizer_image,
        @required this.start_date,
        @required this.start_time,
        @required this.status,
        @required this.title,
        @required this.uid,
        @required this.phone,
    });

    factory Event.fromJson(Map<String, dynamic> doc) {
        return Event(
            //category: doc['category'],
            //deadline: doc['deadline'],
            description: doc['description'],
            end_date: doc['end_date'],
            end_time: doc['end_time'],
            location: doc['location'],
            organizer_uid: doc['organizer_uid'],
            organizer_name: doc['organizer_name'],
            organizer_email: doc['organizer_email'],
            organizer_image: doc['organizer_image'],
            start_date: doc['start_date'],
            start_time: doc['start_time'],
            title: doc['title'],
            uid: doc['uid'],
            phone: doc['phone'],
            status: doc['status'],
            image: doc['image'] != null
            ? List.generate(doc['image'].length, (index) {
                return doc['image'][index];
              })
            : []
        );
    }

    Map<String, dynamic> toJson() => {
        //'category': category,
        //'deadline': deadline,
        'description': description,
        'end_date': end_date,
        'end_time': end_time,
        'image': image,
        'location': location,
        'organizer_uid': organizer_uid,
        'organizer_name': organizer_name,
        'organizer_email': organizer_email,
        'organizer_image': organizer_image,
        'start_date': start_date,
        'start_time': start_time,
        'status': status,
        'title': title,
        'uid': uid,
        'phone': phone,
    };

    factory Event.fromDocument(DocumentSnapshot doc) {
        return Event(
            //category: doc['category'],
            //deadline: doc['deadline'],
            description: doc['description'],
            end_date: doc['end_date'],
            end_time: doc['end_time'],
            location: doc['location'],
            organizer_uid: doc['organizer_uid'],
            organizer_name: doc['organizer_name'],
            organizer_email: doc['organizer_email'],
            organizer_image: doc['organizer_image'],
            start_date: doc['start_date'],
            start_time: doc['start_time'],
            title: doc['title'],
            uid: doc['uid'],
            phone: doc['phone'],
            status: doc['status'],
            image: doc['image'] != null
            ? List.generate(doc['image'].length, (index) {
                return doc['image'][index];
              })
            : []
        );
    }
}
