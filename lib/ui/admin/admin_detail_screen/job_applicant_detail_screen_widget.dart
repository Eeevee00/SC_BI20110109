import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_detail_screen_model.dart';
export 'admin_detail_screen_model.dart';
import '../../../data/models/user_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailScreenWidget extends StatefulWidget {
  final Users user;
  final String event_uid;
  const UserDetailScreenWidget({required this.user, required this.event_uid});

  @override
  _UserDetailScreenWidgetState createState() =>
      _UserDetailScreenWidgetState();
}

class _UserDetailScreenWidgetState extends State<UserDetailScreenWidget> {
  late AdminDetailScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String name = "";
  String email = "";
  String phone = "";
  String user_type = "";
  bool applicant_status = false;
  Map<String, dynamic>? userDetails;
  var hostUID;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminDetailScreenModel());
    loadUserDetails();
    getApplicantStatus();
    hostID();
  }

  Future<void> hostID()async{
      try {
        // Assuming you have a reference to your Firestore instance
        var firestore = FirebaseFirestore.instance;

        // Replace 'job' with the actual name of your job collection
        var jobRef = firestore.collection('job').doc(widget.event_uid);

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
      var user_uid = widget.user.uid;
      await Alert(
      context: context,
      type: AlertType.success,
                                      title: "Application approved",
                                      desc: "Successfully approve user application, 100 point have been credited to your account as a reward",
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
          int updatedHostPoints = (currentHostPoints + 100).toInt();

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

  Future<void> updateParticipantStatus() async {
    try {
      // Assuming you have a reference to your Firestore instance
      var firestore = FirebaseFirestore.instance;

      // Replace 'job' with the actual name of your job collection
      var jobRef = firestore.collection('job').doc(widget.event_uid);

      // Replace 'participant' with the actual name of your participants subcollection
      var participantRef = jobRef.collection('applicants');

      // Query for the participant document where 'uid' is equal to widget.user.uid
      var participantDocs = await participantRef.where('uid', isEqualTo: widget.user.uid).get();

      if (participantDocs.docs.isNotEmpty) {
        var participantDocRef = participantDocs.docs.first.reference;

        // Update participant status to true
        await participantDocRef.update({
          'status': true,
          'applicationStatus': true,
        });
        setState(() {
            applicant_status = true;
        });
        await updateUserPoint();
      } else {
        // Handle the case where the participant document is not found
        print('Participant document not found for uid: ${widget.user.uid}');
      }
    } catch (e) {
      print('Error updating participant status: $e');
      // Handle the error according to your needs
    }
  }

  Future<void> reject() async {
    try {
      // Assuming you have a reference to your Firestore instance
      var firestore = FirebaseFirestore.instance;

      // Replace 'job' with the actual name of your job collection
      var jobRef = firestore.collection('job').doc(widget.event_uid);

      // Replace 'participant' with the actual name of your participants subcollection
      var participantRef = jobRef.collection('applicants');

      // Query for the participant document where 'uid' is equal to widget.user.uid
      var participantDocs = await participantRef.where('uid', isEqualTo: widget.user.uid).get();

      if (participantDocs.docs.isNotEmpty) {
        var participantDocRef = participantDocs.docs.first.reference;

        // Update participant status to true
        await participantDocRef.update({
          'status': true,
          'applicationStatus': false,
        });
        setState(() {
            applicant_status = true;
        });
        await rejectNotification();
      } else {
        // Handle the case where the participant document is not found
        print('Participant document not found for uid: ${widget.user.uid}');
      }
    } catch (e) {
      print('Error updating participant status: $e');
      // Handle the error according to your needs
    }
  }

  sendNotification2() async {
      var point = 100;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference notificationRef = await firestore
        .collection('users')
        .doc(hostUID)
        .collection('notification')
        .add({
          'title': "Job Application",
          'content': "Congratulation, $point point reward have been credit to your account for accepting job applicant",
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

  rejectNotification()async{
    await Alert(
      context: context,
      type: AlertType.success,
                                      title: "Application rejected",
                                      desc: "Rejected user application",
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_uid = prefs.getString("current_user_uid");

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference notificationRef = await firestore
        .collection('users')
        .doc(widget.user.uid)
        .collection('notification')
        .add({
          'title': "Job Application",
          'content': "Your job application have been rejected, thanks for showing interest with the job.",
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
        .doc(widget.user.uid)
        .collection('notification')
        .add({
          'title': "Job Application",
          'content': "Your job application have been approve, 100 point as reward have been credit to your account",
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

  Future<void> getApplicantStatus() async {
    try {
      // Assuming you have a reference to your Firestore instance
      var firestore = FirebaseFirestore.instance;

      // Replace 'job' with the actual name of your job collection
      var jobRef = firestore.collection('job').doc(widget.event_uid);

      // Replace 'participant' with the actual name of your participants subcollection
      var participantRef = jobRef.collection('applicants');

      // Get the document snapshot for the specified userUID
      var participantDoc = await participantRef.where('uid', isEqualTo: widget.user.uid).get();

      // Check if any document exists
      if (participantDoc.docs.isNotEmpty) {
        // Get the first document
        var firstDoc = participantDoc.docs.first;

        // Check if the 'status' field exists in the document data
        var data = firstDoc.data() as Map<String, dynamic>;
        if (data.containsKey('status')) {
          var status = data['status'] as bool?;
          setState(() {
            applicant_status = status ?? false; // Set to false if status is null
          });
        } else {
          // 'status' field doesn't exist in the document
          setState(() {
            applicant_status = false;
          });
        }
      } else {
        // Document doesn't exist, participant not found
        setState(() {
          applicant_status = false;
        });
      }
    } catch (e) {
      print('Error getting participant status: $e');
      // Handle the error according to your needs
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Asynchronous function to get user details from Firestore
  Future<Map<String, dynamic>> getUserDetails(String uid) async {
    try {
      // Creating an instance of FirebaseFirestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Retrieving user document from the 'users' collection using the provided user ID
      DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();

      // Checking if the user document exists
      if (userDoc.exists) {
        // Creating a Map containing user details
        Map<String, dynamic> userDetails = {
          'name': userDoc['name'],
          'email': userDoc['email'],
          'phone': userDoc['phone'],
          'user_type': userDoc['user_type'],
        };

        // Returning the user details Map
        return userDetails;
      } else {
        // Returning an empty Map if the user document does not exist
        return {};
      }
    } catch (error) {
      // Handling errors and printing an error message
      print('Error getting user details: $error');

      // Returning an empty Map in case of an error
      return {};
    }
  }

  // Asynchronous function to load user details and update the state
  Future<void> loadUserDetails() async {
    try {
      // Using the getUserDetails function to retrieve user details for the current user
      Map<String, dynamic>? details = await getUserDetails(widget.user.uid!);

      // Updating the state with the retrieved user details
      setState(() {
        userDetails = details;
        name = userDetails!['name']!;
        email = userDetails!['email']!;
        phone = userDetails!['phone']!;
        user_type = userDetails!['user_type']!;
      });
    } catch (error) {
      // Handling errors and printing an error message
      print('Error loading user details: $error');
    }
  }

  image(pictures){
    var list = pictures;
    var stringList = list.join("");
    return stringList;
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Text(
            'Applicant Detail',
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
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(
                                width: 120.0,
                                height: 120.0,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.network(
                                  (image(widget.user.image!) != "Empty")
                                  ? image(widget.user.image!)
                                  : "https://s3.amazonaws.com/37assets/svn/765-default-avatar.png",
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: widget.user.verification == true
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Approve',
                                      style: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).customColor1,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    CircleAvatar(
                                      radius: 16.0,
                                      backgroundColor: FlutterFlowTheme.of(context).success,
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(), // Empty SizedBox when verification is false
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              'Name',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor1,
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          name,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Outfit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .customColor1,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              'User Type',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor1,
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          user_type == "seeker" ? "Seeker" : "Host" ,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Outfit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .customColor1,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              'Email',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor1,
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          email,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Outfit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .customColor1,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              'Phone',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor1,
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          phone,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Outfit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .customColor1,
                                              ),
                                        ),
                                      ],
                                    ),
                                    applicant_status == false ? 
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 30.0, 0.0, 16.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          updateParticipantStatus();
                                        },
                                        text: 'Approve',
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
                                    )
                                    :
                                    Row(),
                                    applicant_status == false ? 
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 16.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          reject();
                                        },
                                        text: 'Reject',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 55.0,
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context).error,
                                          textStyle: FlutterFlowTheme.of(context)
                                              .titleMedium
                                              .override(
                                                fontFamily: 'Outfit',
                                                color: FlutterFlowTheme.of(context)
                                                    .customColor1,
                                                fontSize: 4.0,
                                              ),
                                          elevation: 2.0,
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    )
                                    :
                                    Row(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}