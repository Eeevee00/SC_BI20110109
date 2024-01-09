import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_detail_screen_model.dart';
export 'admin_detail_screen_model.dart';
import '../../../data/models/claim_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../add_admin_screen/edit_user_screen.dart';

class UserDetailScreenWidget extends StatefulWidget {
  final Claim claim;
  const UserDetailScreenWidget({required this.claim});

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
  var points = 0;
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminDetailScreenModel());
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

  Future<void> loadUserDetails() async {
    Map<String, dynamic>? details = await getUserDetails(widget.claim.claim_by_uid!);
        setState(() {
            userDetails = details;
            name = userDetails!['name']!;
            email = userDetails!['email']!;
            phone = userDetails!['phone']!;
            user_type = userDetails!['user_type']!;
            points = userDetails!['points']!;
        });
    }

    approveFunction(uid)async{
        await Alert(
      context: context,
      type: AlertType.warning,
      title: "Approve Claim",
      desc: "Confirm to approve this claim?",
      buttons: [
        DialogButton(
          child: Text(
            "Confirm",
            style: TextStyle(
              color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              await FirebaseFirestore.instance
                .collection("claim")
                .doc(widget.claim.uid)
                .set({
                    'status': true,
                    'status_text': "Approve",
                },SetOptions(merge: true));

                FirebaseFirestore.instance
                .collection('users')
                .doc(widget.claim.claim_by_uid)
                .collection('notification')
                .add({
                    'title': "Claim Approve",
                    'content': 'Your claim of "' + widget.claim.title! + '" have been approve by admin. please contact our admin to get your reward claim',
                    'timestamp': FieldValue.serverTimestamp(),
                    'uid': "",
                    'send_to': "user",
                    'created_by': "",
                    'read': false,
                });

                Alert(
                  context: context,
                  type: AlertType.success,
                  title: "Approve Claim",
                  desc: "Successfully approve this claim",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      width: 120,
                    )
                  ],
                ).show();
            },
            gradient: LinearGradient(colors: const [
              Color.fromRGBO(116, 116, 191, 1.0),
              Color.fromRGBO(52, 138, 199, 1.0)
            ]
          ),
        ),
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: const [
            Colors.redAccent,
            Colors.red
          ]),
        )
      ],
    ).show();
    }

  rejectFunction(uid)async{
    var balance_point = points + int.parse(widget.claim.point_required!);
    await Alert(
      context: context,
      type: AlertType.warning,
      title: "Reject Claim",
      desc: "Confirm to reject this claim?",
      buttons: [
        DialogButton(
          child: Text(
            "Confirm",
            style: TextStyle(
              color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              await FirebaseFirestore.instance
                .collection("claim")
                .doc(widget.claim.uid)
                .set({
                    'status': false,
                    'status_text': "Rejected",
                },SetOptions(merge: true));

                await FirebaseFirestore.instance
                .collection("users")
                .doc(widget.claim.claim_by_uid)
                .set({
                    'points': balance_point,
                },SetOptions(merge: true));

                FirebaseFirestore.instance
                .collection('users')
                .doc(widget.claim.claim_by_uid)
                .collection('notification')
                .add({
                    'title': "Claim Rejected",
                    'content': 'Your claim of "' + widget.claim.title! + '" have been reject by admin. please contact for more detail',
                    'timestamp': FieldValue.serverTimestamp(),
                    'uid': "",
                    'send_to': "user",
                    'created_by': "",
                    'read': false,
                });

                Alert(
                  context: context,
                  type: AlertType.success,
                  title: "Reject Claim",
                  desc: "Successfully reject this claim",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      width: 120,
                    )
                  ],
                ).show();
            },
            gradient: LinearGradient(colors: const [
              Color.fromRGBO(116, 116, 191, 1.0),
              Color.fromRGBO(52, 138, 199, 1.0)
            ]
          ),
        ),
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: const [
            Colors.redAccent,
            Colors.red
          ]),
        )
      ],
    ).show();
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
            'Claim Detail',
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
                                  (image(widget.claim.user_image!) != "Empty")
                                  ? image(widget.claim.user_image!)
                                  : "https://s3.amazonaws.com/37assets/svn/765-default-avatar.png",
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Center(
                        //   child: widget.claim.verification == true
                        //       ? Row(
                        //           mainAxisSize: MainAxisSize.min,
                        //           children: [
                        //             Text(
                        //               'Approve',
                        //               style: FlutterFlowTheme.of(context).titleSmall.override(
                        //                 fontFamily: 'Outfit',
                        //                 color: FlutterFlowTheme.of(context).customColor1,
                        //                 fontSize: 18.0,
                        //                 fontWeight: FontWeight.normal,
                        //               ),
                        //             ),
                        //             SizedBox(width: 10),
                        //             CircleAvatar(
                        //               radius: 16.0,
                        //               backgroundColor: FlutterFlowTheme.of(context).success,
                        //               child: Icon(
                        //                 Icons.check,
                        //                 color: Colors.white,
                        //               ),
                        //             ),
                        //           ],
                        //         )
                        //       : SizedBox(), // Empty SizedBox when verification is false
                        // ),
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
                                            padding: EdgeInsets.only(top: 16.0, left: 4.0, right: 4.0, bottom: 4.0),
                                            child: Text(
                                              'Reward Claimed',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor1,
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.normal,
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
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              'Reward',
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
                                          widget.claim.title!,
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
                                              'Point used to claim: ',
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
                                          widget.claim.point_required!,
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
                                              'Status: ',
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
                                          widget.claim.status_text!,
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
                                    widget.claim.status_text == "Pending"
                                    ? Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 40.0, 0.0, 20.0),
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                approveFunction(widget.claim.uid);
                                              },
                                              text: 'Approve User Claim',
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
                                                        .primaryText,
                                                textStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryBackground,
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
                                    )
                                    :
                                    Row(),

                                    widget.claim.status_text == "Pending"
                                    ? Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                        Expanded(
                                            child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 40.0),
                                            child: FFButtonWidget(
                                                onPressed: () async {
                                                rejectFunction(widget.claim.uid);
                                                },
                                                text: 'Reject User Claim',
                                                options: FFButtonOptions(
                                                width: double.infinity,
                                                height: 50.0,
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                iconPadding:
                                                    EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                color: FlutterFlowTheme.of(context).error,
                                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: 'Outfit',
                                                    color: FlutterFlowTheme.of(context).customColor1,
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
                                    )
                                    : Row(),
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
