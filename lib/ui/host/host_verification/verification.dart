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
    var user_verifiy = false;
    var request_to_verify = false;

    @override
    void initState() {
        super.initState();
        getUserVerificationStatus(widget.uid);
    }

    Future<void> getUserVerificationStatus(String userUid) async {
        try {
            CollectionReference<Map<String, dynamic>> usersCollection =
                FirebaseFirestore.instance.collection('users');

            DocumentSnapshot<Map<String, dynamic>> userSnapshot =
                await usersCollection.doc(userUid).get();

            if (userSnapshot.exists) {
            bool verificationStatus = userSnapshot.get('verification') ?? false;
            bool requestVerification = userSnapshot.get('request_to_verify') ?? false;
            setState(() {
                user_verifiy = verificationStatus;
                request_to_verify = requestVerification;
            });
            } else {
                setState(() {
                    user_verifiy = false;
                });
            }
        } catch (e) {
            print('Error getting user verification status: $e');
            setState(() {
                user_verifiy = false;
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
            iconTheme:
                IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
            automaticallyImplyLeading: true,
            title: Text(
                'User Verification',
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
            child: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(16.0, 50.0, 0.0, 16.0),
                        child: Text(
                            'User Verification',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).primaryText,
                                ),
                        ),
                    ),
                    user_verifiy == true ? 
                    Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 16.0),
                        child: Text(
                            'Your account have been verified by admin. Thank you and enjoy using the apps.',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).customColor1,
                                ),
                        ),
                    )
                    :
                    Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 16.0),
                        child: Text(
                            'Your account is not verified. Get your account verified to enjoy more feature and get bonus point.',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).customColor1,
                                ),
                        ),
                    ),
                    user_verifiy == true? 
                    Row()
                    :
                    request_to_verify == false? 
                    Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                            Expanded(
                                child: FFButtonWidget(
                                onPressed: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                        builder: (context) => VerificationFormWidget(uid: widget.uid),
                                        ),
                                    );
                                },
                                text: 'Get Verified now',
                                options: FFButtonOptions(
                                    width: 130.0,
                                    height: 40.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
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
                    :
                    Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 16.0),
                        child: Text(
                            'You already submit for verification, please wait for admin to approve',
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).customColor1,
                                ),
                        ),
                    )
                ],
                ),
            ),
            ),
        );
    }
}