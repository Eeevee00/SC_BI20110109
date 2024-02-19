import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Jobs {
    dynamic start_date;
    dynamic end_date;
    String? start_time;
    String? end_time;
    String? description;
    List? image = [];
    Map<String, dynamic>? location;
    String? organizer_email;
    String? organizer_name;
    String? organizer_phone;
    String? organizer_uid;
    String? phone;
    String? title;
    String? uid;
    bool? status;
    String? job_type;
    String? organizer_image;
    String? salary;
    dynamic timestamp;

    Jobs({
        @required this.start_date,
        @required this.end_date,
        @required this.start_time,
        @required this.end_time,
        @required this.description,        
        @required this.image,
        @required this.location,
        @required this.organizer_email,
        @required this.organizer_name,
        @required this.organizer_phone,
        @required this.organizer_uid,
        @required this.phone,
        @required this.title,
        @required this.uid,
        @required this.status,
        this.job_type,
        this.organizer_image,
        this.salary,
        this.timestamp,
    });

    factory Jobs.fromJson(Map<String, dynamic> doc) {
        return Jobs(
            start_date: doc['start_date'],            
            end_date: doc['end_date'],
            start_time: doc['start_time'],
            end_time: doc['end_time'],
            description: doc['description'],
            location: doc['location'],
            organizer_email: doc['organizer_email'],
            organizer_name: doc['organizer_name'],
            organizer_phone: doc['organizer_phone'],
            organizer_uid: doc['organizer_uid'],
            phone: doc['phone'],
            title: doc['title'],
            uid: doc['uid'],
            status: doc['status'],
            image: doc['image'] != null
            ? List.generate(doc['image'].length, (index) {
                return doc['image'][index];
              })
            : [],
            job_type: doc['job_type'],
            organizer_image: doc['organizer_image'],
            salary: doc['salary'],
            timestamp: doc['timestamp'],
        );
    }

    Map<String, dynamic> toJson() => {
        'start_date': start_date,
        'end_date': end_date,
        'start_time': start_time,
        'end_time': end_time,
        'description': description,
        'location': location,
        'organizer_email': organizer_email,
        'organizer_name': organizer_name,
        'organizer_phone': organizer_phone,
        'organizer_uid': organizer_uid,
        'phone': phone,
        'title': title,
        'uid': uid,
        'image': image,
        'status': status,
        'job_type': job_type,
        'organizer_image': organizer_image,
        'salary': salary,
        'timestamp': timestamp,
    };

    factory Jobs.fromDocument(DocumentSnapshot doc) {
        return Jobs(

            start_date: doc['start_date'],            
            end_date: doc['end_date'],
            start_time: doc['start_time'],
            end_time: doc['end_time'],
            description: doc['description'],
            location: doc['location'],
            organizer_email: doc['organizer_email'],
            organizer_name: doc['organizer_name'],
            organizer_phone: doc['organizer_phone'],
            organizer_uid: doc['organizer_uid'],
            phone: doc['phone'],
            title: doc['title'],
            uid: doc['uid'],
            status: doc['status'],
            image: doc['image'] != null
            ? List.generate(doc['image'].length, (index) {
                return doc['image'][index];
              })
            : [],
            job_type: doc['job_type'],
            organizer_image: doc['organizer_image'],
            salary: doc['salary'],
            timestamp: doc['timestamp'],
        );
    }
}
