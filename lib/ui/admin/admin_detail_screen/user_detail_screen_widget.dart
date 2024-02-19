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
import '../../../data/models/user_model.dart';
import '../add_admin_screen/edit_user_screen.dart';
import 'admin_detail_screen_model.dart';
export 'admin_detail_screen_model.dart';

class UserDetailScreenWidget extends StatefulWidget {
  final Users user;
  const UserDetailScreenWidget({required this.user});

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

  // Asynchronous function to retrieve user details from Firestore
  Future<Map<String, dynamic>> getUserDetails(String uid) async {
    try {
      // Creating a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Retrieving the document snapshot for the specified user ID
      DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();

      // Checking if the user document exists
      if (userDoc.exists) {
        // Creating a Map with user details from the document
        Map<String, dynamic> userDetails = {
          'name': userDoc['name'],
          'email': userDoc['email'],
          'phone': userDoc['phone'],
          'user_type': userDoc['user_type'],
        };

        // Returning the user details if the document exists
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

  // Asynchronous function to load user details and update state
  Future<void> loadUserDetails() async {
    try {
      // Calling the getUserDetails function to retrieve user details
      Map<String, dynamic>? details = await getUserDetails(widget.user.uid!);

      // Checking if user details are available
      if (details != null) {
        // Updating the state with the retrieved user details
        setState(() {
          userDetails = details;
          name = userDetails!['name']!;
          email = userDetails!['email']!;
          phone = userDetails!['phone']!;
          user_type = userDetails!['user_type']!;
        });
      }
    } catch (error) {
      // Handling errors and printing an error message
      print('Error loading user details: $error');
    }
  }

  // Function to show a confirmation alert dialog and delete user if confirmed
  deleteFunction(uid) async {
    try {
      // Showing a confirmation alert dialog
      await Alert(
        context: context,
        type: AlertType.warning,
        title: "Delete User",
        desc: "Confirm to delete user?",
        buttons: [
          DialogButton(
            child: Text("Confirm",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async {
              // Updating the 'status' field in the Firestore document to mark user as inactive
              await FirebaseFirestore.instance
                .collection("users")
                .doc(uid)
                .set({
                  'status': false,
                }, SetOptions(merge: true));

              // Showing a success alert dialog after successful deletion
              Alert(
                context: context,
                type: AlertType.success,
                title: "Delete user",
                desc: "Successfully delete user",
                buttons: [
                  DialogButton(
                    child: Text( "Close",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      // Closing the alert dialogs and navigating back
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
              Color.fromRGBO(52, 138, 199, 1.0),
            ]),
          ),
          // Cancel button for the confirmation alert dialog
          DialogButton(
            child: Text("Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            gradient: LinearGradient(colors: const [
              Colors.redAccent,
              Colors.red,
            ]),
          )
        ],
      ).show();
    } catch (error) {
      // Handling errors and printing an error message
      print('Error deleting user: $error');
    }
  }

  // Function to concatenate a list of items into a single string
  String image(List pictures) {
    // Creating a local variable 'list' to store the input list
    var list = pictures;

    // Joining the list into a single string
    var stringList = list.join("");

    // Returning the concatenated string
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
            'User Detail',
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
                                          style: FlutterFlowTheme.of(context) .bodyMedium.override(
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
                                            child: Text('User Type',
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
                                          user_type == "seeker" ? "Seeker" : "Host" ,
                                          style: FlutterFlowTheme.of(context) .bodyMedium.override(
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
                                          style: FlutterFlowTheme.of(context) .bodyMedium.override(
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
                                            child: Text('Phone',
                                               style:FlutterFlowTheme.of(context).titleSmall.override(
                                                        fontFamily: 'Outfit',
                                                        color:FlutterFlowTheme.of(context).customColor1,
                                                        fontSize: 16.0,
                                                        fontWeight:FontWeight.normal,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Text( phone,
                                          style: FlutterFlowTheme.of(context) .bodyMedium.override(
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
                                                  builder: (context) => EditUserScreenWidget(uid: widget.user.uid!),),
                                                );
                                                loadUserDetails();
                                              },
                                              text: 'Edit Detail',
                                              options: FFButtonOptions(
                                                width: double.infinity,
                                                height: 50.0,
                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                                iconPadding:EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
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
                                            padding:EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 40.0),
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
