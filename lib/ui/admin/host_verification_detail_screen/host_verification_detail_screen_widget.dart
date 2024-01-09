import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'host_verification_detail_screen_model.dart';
export 'host_verification_detail_screen_model.dart';
import '../../../data/models/user_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../add_admin_screen/edit_user_screen.dart';

class HostVerificationDetailScreenWidget extends StatefulWidget {
  final Users user;
  const HostVerificationDetailScreenWidget({required this.user});

  @override
  _HostVerificationDetailScreenWidgetState createState() =>
      _HostVerificationDetailScreenWidgetState();
}

class _HostVerificationDetailScreenWidgetState extends State<HostVerificationDetailScreenWidget> {
  late HostVerificationDetailScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String name = "";
  String email = "";
  String phone = "";
  String user_type = "";
  var points = 0;
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HostVerificationDetailScreenModel());
    loadUserDetails();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> getUserDetails(String uid) async {
        try {
            FirebaseFirestore firestore = FirebaseFirestore.instance;
            DocumentSnapshot userDoc =
                await firestore.collection('users').doc(uid).get();

            if (userDoc.exists) {
            Map<String, dynamic> userDetails = {
                'name': userDoc['name'],
                'email': userDoc['email'],
                'phone': userDoc['phone'],
                'user_type': userDoc['user_type'],
                'points': userDoc['points'],
            };
            return userDetails;
            } else {
            return {};
            }
        } catch (error) {
            print('Error getting user details: $error');
            return {};
        }
    }

  sendStatusNotificationApproval() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference notificationRef = await firestore
        .collection('users')
        .doc(widget.user.uid!)
        .collection('notification')
        .add({
          'title': "Verification Approve",
          'content': "1000 points have been credited to your account as a verification reward",
          'timestamp': FieldValue.serverTimestamp(),
          'uid': "", // Leave it empty for now
          'send_to': "user",
          'created_by': "",
          'read': false,
        });

    // Get the auto-generated uid from the notificationRef
    String notificationUid = notificationRef.id;

    // Update the notification document with the correct uid
    await notificationRef.update({'uid': notificationUid});
  }


  sendStatusNotificationRejected() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference notificationRef = await firestore
        .collection('users')
        .doc(widget.user.uid!)
        .collection('notification')
        .add({
          'title': "Verification Rejected",
          'content': "Verification rejected, please submit again.",
          'timestamp': FieldValue.serverTimestamp(),
          'uid': "", // Leave it empty for now
          'send_to': "user",
          'created_by': "",
          'read': false,
        });

    // Get the auto-generated uid from the notificationRef
    String notificationUid = notificationRef.id;

    // Update the notification document with the correct uid
    await notificationRef.update({'uid': notificationUid});
  }

  Future<void> loadUserDetails() async {
    Map<String, dynamic>? details = await getUserDetails(widget.user.uid!);
        setState(() {
            userDetails = details;
            name = userDetails!['name']!;
            email = userDetails!['email']!;
            phone = userDetails!['phone']!;
            user_type = userDetails!['user_type']!;
            points = userDetails!['points']!;
        });
    }

  image(pictures){
    var list = pictures;
    var stringList = list.join("");
    return stringList;
  }

  Future<void> updateStatus(String approval) async {
    try {
      if(approval == "approve"){
        await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({
            'request_to_verify': false,
            'verification': true,
            'points': points + 1000,
            });
        sendStatusNotificationApproval();
        Alert(
          context: context,
          type: AlertType.success,
          title: "Verification Approve",
          desc: "Verification approve, this user will receive the verification result",
          buttons: [
            DialogButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show();
      }else{
        await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({
            'request_to_verify': false,
            'verification': false,
            'proof_for_verification_1': ['Empty'],
            'proof_for_verification_2': ['Empty'],
            });
        sendStatusNotificationRejected();
        Alert(
          context: context,
          type: AlertType.error,
          title: "Verification Rejectected",
          desc: "Verification rejected, this user will receive the verification result",
          buttons: [
            DialogButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show();
      }
    } catch (error) {
      print('Error updating status: $error');
      // Handle error as needed
    }
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
            'User Detail',
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
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            (image(widget.user.proof_for_verification_1!) != "Empty") ?  
                            Expanded(
                              child: Container(
                                  child: Image.network(image(widget.user.proof_for_verification_1!)),
                              ),
                            )
                            :
                            Row(),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            (image(widget.user.proof_for_verification_1!) != "Empty") ?  
                            Expanded(
                              child: Container(
                                  child: Image.network(image(widget.user.proof_for_verification_2!)),
                              ),
                            )
                            :
                            Row(),
                          ],
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
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 40.0, 0.0, 20.0),
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                updateStatus("approve");
                                              },
                                              text: 'Approve',
                                              options: FFButtonOptions(
                                                width: double.infinity,
                                                height: 50.0,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .success,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .customColor1,
                                                          fontSize: 16.0,
                                                        ),
                                                elevation: 3.0,
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 40.0),
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                updateStatus("reject");
                                              },
                                              text: 'Reject',
                                              options: FFButtonOptions(
                                                width: double.infinity,
                                                height: 50.0,
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                            0.0, 0.0, 0.0, 0.0),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .customColor1,
                                                          fontSize: 16.0,
                                                        ),
                                                elevation: 3.0,
                                                borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

