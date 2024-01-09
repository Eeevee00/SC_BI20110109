import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_admin_screen_model.dart';
export 'add_admin_screen_model.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../service/auth.dart';
import '../../../service/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EditUserScreenWidget extends StatefulWidget {
  final String uid;
  const EditUserScreenWidget({required this.uid});

  @override
  _EditUserScreenWidgetState createState() => _EditUserScreenWidgetState();
}

class _EditUserScreenWidgetState extends State<EditUserScreenWidget> {
  late AddAdminScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProcessing = false;
  final db = FirebaseFirestore.instance;
  final _registerFormKey = GlobalKey<FormState>();
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddAdminScreenModel());
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();
    _model.textController5 ??= TextEditingController();
    _model.textFieldFocusNode5 ??= FocusNode();
    loadUserDetails();
  }

  Future<Map<String, dynamic>> getUserDetails(String uid) async {
        try {
            FirebaseFirestore firestore = FirebaseFirestore.instance;
            DocumentSnapshot notificationDoc =
                await firestore.collection('users').doc(uid).get();

            if (notificationDoc.exists) {
            Map<String, dynamic> notificationDetails = {
                'name': notificationDoc['name'],
                'email': notificationDoc['email'],
                'phone': notificationDoc['phone'],
            };
            return notificationDetails;
            } else {
            return {};
            }
        } catch (error) {
            print('Error getting notification details: $error');
            return {};
        }
    }

  Future<void> loadUserDetails() async {
    Map<String, dynamic>? details = await getUserDetails(widget.uid);
        setState(() {
            userDetails = details;
            _model.textController1.text = userDetails!['name']!;
            _model.textController2.text = userDetails!['email']!;
            _model.textController3.text = userDetails!['phone']!;
        });
    }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> update_user() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      String uid = widget.uid; 

      DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        await firestore.collection('users').doc(uid).update({
          'name': _model.textController1.text,
          'phone': _model.textController3.text,
        });

        Alert(
          context: context,
          type: AlertType.success,
          title: "Update User",
          desc: "Successfully update user detail",
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
      } else {
        print('User with UID $uid not found');
      }
    } catch (error) {
      print('Error updating user details: $error');
    } finally {
      setState(() {
        _isProcessing = false;
      });
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
            'Edit User Detail',
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
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
            child: SingleChildScrollView(
              child: Form(
                  key: _registerFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'User Detail',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                        child: TextFormField(
                          controller: _model.textController1,
                          focusNode: _model.textFieldFocusNode1,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            hintText: 'Enter user full name',
                            hintStyle: FlutterFlowTheme.of(context).bodyLarge,
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
                              return 'Please enter user name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                        child: TextFormField(
                          controller: _model.textController2,
                          readOnly: true,
                          focusNode: _model.textFieldFocusNode2,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'Enter user email address',
                            hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                            labelStyle: TextStyle(
                              color: FlutterFlowTheme.of(context).primaryText,
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
                            contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 24.0),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            }
                            // Use a regex pattern for email validation
                            String emailRegex =
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                            RegExp regex = RegExp(emailRegex);
                            if (!regex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null; // Return null if validation succeeds
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                        child: TextFormField(
                          controller: _model.textController3,
                          focusNode: _model.textFieldFocusNode3,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            hintText: 'Enter user phone number',
                            hintStyle: FlutterFlowTheme.of(context).bodyLarge,
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
                              return 'Please enter phone number';
                            }
                            return null; // Return null if validation succeeds
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 40.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            if (_registerFormKey.currentState?.validate() ?? false) {
                              await update_user();
                            }
                          },
                          text: 'Update User',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 50.0,
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primaryText,
                            textStyle:
                                FlutterFlowTheme.of(context).titleSmall.override(
                                      fontFamily: 'Outfit',
                                      color: FlutterFlowTheme.of(context)
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
                    ],
                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}