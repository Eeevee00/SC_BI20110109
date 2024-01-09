import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Contacts {
    String? name;
    String? chatID;
    String? id;
    String? pictureURL;
    bool? isRead;

    Contacts({
        @required this.name, 
        @required this.chatID, 
        @required this.id, 
        @required this.pictureURL, 
        @required this.isRead, 
    });

    factory Contacts.fromJson(Map<String, dynamic> doc) {
        return Contacts(
            name: doc['userName'],
            chatID: doc['chatID'],
            id: doc['id'],
            pictureURL: doc['pictureURL'],
            isRead: doc['isRead'],
        );
    }

    Map<String, dynamic> toJson() => {
        'userName': name,
        'chatID': chatID,
        'id': id,
        'pictureURL': pictureURL,
        'isRead': isRead,
    };

    factory Contacts.fromDocument(DocumentSnapshot doc) {
        return Contacts(
            name: doc['userName'],
            chatID: doc['chatID'],
            id: doc['id'],
            pictureURL: doc['pictureURL'],
            isRead: doc['isRead'],
        );
    }

}