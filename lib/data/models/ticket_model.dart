import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Ticket {
    String? description;
    int? quantity;
    String? ticket_type;
    dynamic timestamp;
    String? title;
    String? uid;
    String? value;

    Ticket({
        @required this.description,
        @required this.quantity,
        @required this.ticket_type,
        @required this.timestamp,
        @required this.title,
        @required this.uid,
        @required this.value,
    });

    factory Ticket.fromJson(Map<String, dynamic> doc) {
        return Ticket(
            description: doc['description'],
            quantity: doc['quantity'],
            ticket_type: doc['ticket_type'],
            timestamp: doc['timestamp'],
            title: doc['title'],
            uid: doc['uid'],
            value: doc['value'],
        );
    }

    Map<String, dynamic> toJson() => {
        'description': description,
        'quantity': quantity,
        'ticket_type': ticket_type,
        'timestamp': timestamp,
        'title': title,
        'uid': uid,
        'value': value,
    };

    factory Ticket.fromDocument(DocumentSnapshot doc) {
        return Ticket(
            description: doc['description'],
            quantity: doc['quantity'],
            ticket_type: doc['ticket_type'],
            timestamp: doc['timestamp'],
            title: doc['title'],
            uid: doc['uid'],
            value: doc['value'],
        );
    }
}
