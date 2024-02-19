import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'package:getwidget/getwidget.dart';
import 'reviewList.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:alphacar/ui/widgets/textField_widget3.dart';
import 'package:getwidget/getwidget.dart';
import '../../../data/models/shared_pref.dart';
import 'dart:convert';
import '../../../data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';


class WriteReview extends StatefulWidget {
  final String? eventID;

  const WriteReview({Key? key, required this.eventID}) : super(key: key);

  @override
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
    final titleController = TextEditingController();
    TextEditingController textarea = TextEditingController();
    
    var ratings;
    late var name;

    SharedPref sharedPref = SharedPref();
    var user;
    String? userPic = "";
    String? firstName = "";
    String? lastName = "";
    String? userId = "";
    late Users currentUser;
    late SharedPreferences sharedPreferences;
   var hostUID;

    Future<void> hostID()async{
      try {
        // Assuming you have a reference to your Firestore instance
        var firestore = FirebaseFirestore.instance;

        // Replace 'job' with the actual name of your job collection
        var jobRef = firestore.collection('job').doc(widget.eventID);

        // Get the document snapshot for the specified jobUID
        var jobDoc = await jobRef.get();

        // Check if the document exists and contains the 'organizer_uid' field
        if (jobDoc.exists) {
          var organizerUID = jobDoc['organizer_uid'] as String?;
          setState(() {
            hostUID = organizerUID;
          });

        } else {
          // Document doesn't exist

        }
      } catch (e) {
        print('Error getting organizer UID: $e');
        return null; // Handle the error according to your needs
      }
    }

    void initialGetSaved() async{
        sharedPreferences = await SharedPreferences.getInstance();
        
        setState(() {
            print(sharedPreferences.getString('current_user_image'));
            print(sharedPreferences.getString('current_user_name'));
            print(sharedPreferences.getString('current_user_uid'));
            userPic = sharedPreferences.getString('current_user_image');
            firstName = sharedPreferences.getString('current_user_name');
            userId = sharedPreferences.getString('current_user_uid');
        });
    }

    Future<int?> getUserPoint(var userUid) async {
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userUid)
            .get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
          // Assuming the points field is an integer in your Firestore document
          int? userPoints = userData['points'];
          print('User Points: $userPoints');
          return userPoints;
        } else {
          print('User not found in Firestore');
          return null;
        }
      } catch (error) {
        print('Error getting user points: $error');
        return null;
      }
    }

    Future<void> updateUserPoint() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user_uid = prefs.getString("current_user_uid");

      try {
        // Get the current user points
        int? currentPoints = await getUserPoint(user_uid);
        int? currentHostPoints = await getUserPoint(hostUID);

        if (currentPoints != null) {
          // Update user points by 1000
          int updatedPoints = currentPoints + 100;

          // Update points in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user_uid)
              .update({'points': updatedPoints});

          print('User Points Updated: $updatedPoints');
          sendNotification();
        } else {
          print('Cannot update user points. User not found in Firestore.');
        }

        if (currentHostPoints != null) {
          // Update user points by 1000
          int updatedHostPoints = (currentHostPoints + (10 * ratings)).toInt();

          // Update points in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(hostUID)
              .update({'points': updatedHostPoints});

          print('User Points Updated: $updatedHostPoints');
          sendNotification2();
        } else {
          print('Cannot update user points. User not found in Firestore.');
        }
      } catch (error) {
        print('Error updating user points: $error');
      }
    }

    sendNotification2() async {
      var point = 50;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference notificationRef = await firestore
        .collection('users')
        .doc(hostUID)
        .collection('notification')
        .add({
          'title': "Job Reviews",
          'content': "Congratulation, One of your job have been purchase. $point point reward have been credit to your account",
          'timestamp': FieldValue.serverTimestamp(),
          'uid': "", // Leave it empty for now
          'send_to': "user",
          'created_by': "",
          //'read': false,
        });

    // Get the auto-generated uid from the notificationRef
    String notificationUid = notificationRef.id;

    // Update the notification document with the correct uid
    await notificationRef.update({'uid': notificationUid});
  }

  sendNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_uid = prefs.getString("current_user_uid");

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference notificationRef = await firestore
        .collection('users')
        .doc(user_uid)
        .collection('notification')
        .add({
          'title': "Job Reviews",
          'content': "Thanks for writing review, 100 points have been credited to your account as a reward",
          'timestamp': FieldValue.serverTimestamp(),
          'uid': "", // Leave it empty for now
          'send_to': "user",
          'created_by': "",
          //'read': false,
        });

    // Get the auto-generated uid from the notificationRef
    String notificationUid = notificationRef.id;

    // Update the notification document with the correct uid
    await notificationRef.update({'uid': notificationUid});
  }
    

    @override
    void initState() {
        super.initState();
        initialGetSaved();
        hostID();

    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            appBar: AppBar(
                backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                iconTheme:
                    IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
                automaticallyImplyLeading: true,
                title: Text(
                    'Event Detail',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        ),
                ),
                actions: [],
                centerTitle: false,
                elevation: 0.0,
            ),
            body: Center(
                child: Padding(
                padding: EdgeInsets.all(20),
                child: ListView(
                    children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Text(
                            'Write your review',
                            style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Outfit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .customColor1,
                                              ),
                        )),
                    Center(
                        child: RatingBar.builder(
                            unratedColor: Colors.grey,
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            updateOnDrag: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                                Ionicons.star,
                                color: Colors.yellow,
                                ),
                            onRatingUpdate: (rating) {
                            ratings = rating;
                            }),
                    ),
                    SizedBox(
                        height: 20,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(0),
                        child: TextFormField(
                          controller: titleController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Comment Title',
                            hintText: 'Enter the comment title',
                            hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                            labelStyle: TextStyle( // Add this block for label text style
                              color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    FlutterFlowTheme.of(context).primaryBackground,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primaryText,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            filled: true,
                            fillColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                20.0, 24.0, 20.0, 24.0),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter comment title';
                            }
                            return null;
                          },
                        ),
                    ),
                    
                    SizedBox(
                        height: 20,
                    ),

                    TextFormField(
                      controller: textarea,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Review Description',
                        hintText: 'Enter description',
                        hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                        labelStyle: TextStyle( // Add this block for label text style
                            color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                          ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primaryBackground,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primaryText,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                      maxLines: 10,
                      minLines: 5,
                      validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                    ),

                    SizedBox(
                        height: 20,
                    ),

                     Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                                if (ratings == null) {
                                    Alert(
                                      context: context,
                                      type: AlertType.warning,
                                      title: "Fail to submit review.",
                                      desc: "Please add a rating.",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "Close",
                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ).show();
                                } else if (titleController.text == '') {
                                  Alert(
                                    context: context,
                                    type: AlertType.warning,
                                    title: "Fail to submit review.",
                                    desc: "Please add a review.",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Close",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ).show();
                                } else {
                                FirebaseFirestore.instance
                                    .collection("job")
                                    .doc(widget.eventID)
                                    .collection('reviews')
                                    .add({
                                        "title": titleController.text,
                                        "rating": ratings,
                                        "content": textarea.text,
                                        "userID": userId,
                                        "userImage": userPic,
                                        "timestamp": Timestamp.now(),
                                        "name": firstName,
                                        "lastName": lastName,
                                    });
                                    await updateUserPoint();
                                    await Alert(
                                      context: context,
                                      type: AlertType.success,
                                      title: "Success to submit review.",
                                      desc: "100 points have been credited to your account for leaving a review",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "Close",
                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ).show();
                                    Navigator.pop(context);
                                }
                            },
                            text: 'Submit Review',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 55.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primaryText,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    fontSize: 4.0,
                                  ),
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                    ],
                ),
                ),
            ),
        );
    }

}