import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_detail_screen_model.dart';
export 'admin_detail_screen_model.dart';
import '../../../data/models/user_model.dart';
import '../add_admin_screen/edit_admin_screen.dart';

class AdminDetailScreenWidget extends StatefulWidget {
  final Users user;
  const AdminDetailScreenWidget({required this.user});

  @override
  _AdminDetailScreenWidgetState createState() =>
    _AdminDetailScreenWidgetState();
}

class _AdminDetailScreenWidgetState extends State<AdminDetailScreenWidget> {
  late AdminDetailScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String name = "";
  String email = "";
  String phone = "";
  Map<String, dynamic>? userDetails;

  @override
  void initState(){
    super.initState();
    _model = createModel(context, () => AdminDetailScreenModel());
    loadUserDetails();
  }

  @override
  void dispose(){
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
      });
    } catch (error) {
      // Handling errors and printing an error message
      print('Error loading user details: $error');
    }
  }

  // Asynchronous function to prompt for user deletion confirmation
  deleteFunction(uid)async{
    await Alert(
      context: context,
      type: AlertType.warning,
      title: "Delete User",
      desc: "Confirm to delete user?",
      buttons: [
        DialogButton(
          child: Text(
            "Confirm",
            style: TextStyle(
              color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {           
            // Updating the 'status' field to false to deactivate the user
              await FirebaseFirestore.instance
                .collection("users")
                .doc(uid)
                .set({
                    'status': false,
                },SetOptions(merge: true));
            // Showing a success alert after successfully deleting the user
                Alert(
                  context: context,
                  type: AlertType.success,
                  title: "Delete user",
                  desc: "Successfully deleted user",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        // Closing the alert and navigating back multiple times
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
            'Admin Detail',
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
                                            child: Text('Name',
                                              style:FlutterFlowTheme.of(context).titleSmall.override(
                                                        fontFamily: 'Outfit',
                                                        color:FlutterFlowTheme.of(context).customColor1,
                                                        fontSize: 16.0,
                                                        fontWeight:FontWeight.normal,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Text(name,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Outfit',
                                                color:FlutterFlowTheme.of(context).customColor1,
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
                                            child: Text('Email',
                                              style:FlutterFlowTheme.of(context).titleSmall.override(
                                                        fontFamily: 'Outfit',
                                                        color:FlutterFlowTheme.of(context).customColor1,
                                                        fontSize: 16.0,
                                                        fontWeight:FontWeight.normal,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Text(email,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Outfit',
                                                color:FlutterFlowTheme.of(context).customColor1,
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
                                              style:FlutterFlowTheme.of(context).titleSmall.override(
                                                        fontFamily: 'Outfit',
                                                        color:FlutterFlowTheme.of(context).customColor1,
                                                        fontSize: 16.0,
                                                        fontWeight:FontWeight.normal,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          phone,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Outfit',
                                                color:FlutterFlowTheme.of(context).customColor1,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding:EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 20.0),
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                await Navigator.push(context,MaterialPageRoute(
                                                    builder: (context) => EditAdminScreenWidget(uid: widget.user.uid!),
                                                  ),
                                                );
                                                loadUserDetails();
                                              },
                                              text: 'Edit Detail',
                                              options: FFButtonOptions(
                                                width: double.infinity,
                                                height: 50.0,
                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                color:FlutterFlowTheme.of(context).primaryText,
                                                textStyle:FlutterFlowTheme.of(context).titleSmall.override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                                          fontSize: 19.0,
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
                                            padding:EdgeInsetsDirectional.fromSTEB( 0.0, 0.0, 0.0, 40.0),
                                            child: FFButtonWidget(
                                              onPressed: () async {
                                                print(widget.user.uid);
                                                deleteFunction(widget.user.uid);
                                              },
                                              text: 'Delete',
                                              options: FFButtonOptions(
                                                width: double.infinity,
                                                height: 50.0,
                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                iconPadding:EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                color:FlutterFlowTheme.of(context).error,
                                                textStyle:FlutterFlowTheme.of(context).titleSmall.override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme.of(context).customColor1,
                                                          fontSize: 19.0,
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
