import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../verification_form/verification_form_widget.dart'; 

class Verification extends StatefulWidget {
    final String uid;
    const Verification({required this.uid});

    @override
    _VerificationState createState() =>
        _VerificationState();
}

class _VerificationState extends State<Verification> {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    var user_verify_status = false;
    var request_to_verify = false;

    @override
    void initState() {
        super.initState();
        getUserVerificationStatus(widget.uid);
    }

    Future<void> getUserVerificationStatus(String userUid) async {
        try {
            // Define a reference to the 'users' collection
            CollectionReference<Map<String, dynamic>> usersCollection = FirebaseFirestore.instance.collection('users');
            // Retrieve a specific document from the collection using its userUid
            DocumentSnapshot<Map<String, dynamic>> userSnapshot = await usersCollection.doc(userUid).get();

            if (userSnapshot.exists) {
            // If the document exists, retrieve the verification status and request verification status
            // else  if that value is null, it defaults to false. It's a concise way of handling null values in Dart.
            bool verificationStatus = userSnapshot.get('verification') ?? false;
            bool requestVerification = userSnapshot.get('request_to_verify') ?? false;
            // Update the state variables using setState

            setState(() {
                user_verify_status = verificationStatus;
                request_to_verify = requestVerification;
            });
            } else {
                    // If the document does not exist, set user_verify_status to false
                setState(() {
                    user_verify_status = false;
                });
            }
        } catch (e) {
                // Handle any errors that might occur during the retrieval of verification status
            print('Error getting user verification status: $e');
            setState(() {
                user_verify_status = false;
            });
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            iconTheme:IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: true,
            title: Text(
                'User Verification',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Outfit',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 20.0,
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
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 20.0, 0.0, 20.0),
                    child: Text(
                        'User Verification',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 20.0,

                        ),
                    ),
                    ),

                    // Verification Status Messages
                    if (user_verify_status == true)
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10.0, 12.0, 16.0, 16.0),
                        child: Text(
                        'Your account has been verified by admin. Thank you and enjoy using the apps.',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Outfit',
                            color: FlutterFlowTheme.of(context).customColor1,
                        ),
                        ),
                    )
                    else if (user_verify_status == false && request_to_verify == false)
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10.0, 12.0, 16.0, 16.0),
                        child: Text(
                        'Your account is not verified. Get your account verified to enjoy more features and get bonus points.',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Outfit',
                            color: FlutterFlowTheme.of(context).customColor1,
                        ),
                        ),
                    )
                    else if (user_verify_status == false && request_to_verify == true)
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10.0, 12.0, 16.0, 16.0),
                        child: Text(
                        'You have already submitted for verification. Please wait for admin approval.',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Outfit',
                            color: FlutterFlowTheme.of(context).customColor1,
                        ),
                        ),
                    ),

                    // Button Section
                    if (user_verify_status == true)
                    Row() // Renders an empty Row (no button).
                    
                    else if (user_verify_status == false && request_to_verify == false)
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                        child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                            Expanded(
                            child: FFButtonWidget(
                                onPressed: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) =>
                                        VerificationFormWidget(uid: widget.uid),
                                    ),
                                );
                                },
                                text: 'Get Verified now',
                                options: FFButtonOptions(
                                // width: 130.0,
                                width: double.infinity,
                                height: 45.0,
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primaryText,
                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    fontSize: 20.0,

                                ),
                                elevation: 2.0,
                                borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                                ),
                            ),
                            ),
                        ],
                        ),
                    )
                    else if (user_verify_status == false && request_to_verify == true)
                    Row() // Renders an empty Row (no button).
                ],
                    ),
                ),
            ),

        );
    }
}