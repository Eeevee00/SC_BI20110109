import '../../flutter_flow/flutter_flow_drop_down.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'update_profile_user_model.dart';
export 'update_profile_user_model.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../service/auth.dart';
import '../../../service/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../updateLocation.dart';

class UpdateProfileUserWidget extends StatefulWidget {
  final String uid;
  const UpdateProfileUserWidget({required this.uid});

  @override
  _UpdateProfileUserWidgetState createState() =>
      _UpdateProfileUserWidgetState();
}

class _UpdateProfileUserWidgetState extends State<UpdateProfileUserWidget> {
  late UpdateProfileUserModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProcessing = false;
  final db = FirebaseFirestore.instance;
  final _registerFormKey = GlobalKey<FormState>();
  Map<String, dynamic>? userDetails;

  var description;
  var address;
  late var userLocation = "";
  var latitude;
  var longitude;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UpdateProfileUserModel());

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
            DocumentSnapshot userDoc =
                await firestore.collection('users').doc(uid).get();

            if (userDoc.exists) {
            Map<String, dynamic> userDetails = {
                'name': userDoc['name'],
                'email': userDoc['email'],
                'phone': userDoc['phone'],
                'address': userDoc['location']['address'],
                'latitude': userDoc['location']['latitude'],
                'longitude': userDoc['location']['longitude'],
                'bio': userDoc['bio'],
            };
            return userDetails;
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
            print(userDetails);
            _model.textController1.text = userDetails!['name']!;
            _model.textController2.text = userDetails!['phone']!;
            _model.textController5.text = userDetails!['address']!;
            _model.textController4.text = userDetails!['bio']!;
            userLocation = userDetails!['address']!;
            latitude = userDetails!['latitude']!;
            longitude = userDetails!['longitude']!;
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
            'phone': _model.textController2.text,
            'bio': _model.textController4.text,
            'location': {
              'address': _model.textController5.text,
              'latitude': latitude,
              'longitude': longitude,
            },
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
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
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
                                'Update Profile',
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
                          hintText: 'Enter full name',
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
                        validator:
                            _model.textController1Validator.asValidator(context),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                      child: TextFormField(
                        controller: _model.textController2,
                        focusNode: _model.textFieldFocusNode2,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter phone number',
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
                        validator:
                            _model.textController2Validator.asValidator(context),
                      ),
                    ),
                    // Column(
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: [
                    //     Padding(
                    //       padding:
                    //           EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.max,
                    //         children: [
                    //           Expanded(
                    //             child: TextFormField(
                    //               controller: _model.textController3,
                    //               focusNode: _model.textFieldFocusNode3,
                    //               obscureText: false,
                    //               decoration: InputDecoration(
                    //                 labelText: 'Interest',
                    //                 hintText: 'Enter your interest',
                    //                 hintStyle:
                    //                     FlutterFlowTheme.of(context).bodyLarge,
                    //                 labelStyle: TextStyle( // Add this block for label text style
                    //                   color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                    //                 ),
                    //                 enabledBorder: OutlineInputBorder(
                    //                   borderSide: BorderSide(
                    //                     color: FlutterFlowTheme.of(context)
                    //                         .primaryBackground,
                    //                     width: 2.0,
                    //                   ),
                    //                   borderRadius: BorderRadius.circular(5.0),
                    //                 ),
                    //                 focusedBorder: OutlineInputBorder(
                    //                   borderSide: BorderSide(
                    //                     color: FlutterFlowTheme.of(context)
                    //                         .primaryText,
                    //                     width: 2.0,
                    //                   ),
                    //                   borderRadius: BorderRadius.circular(5.0),
                    //                 ),
                    //                 errorBorder: OutlineInputBorder(
                    //                   borderSide: BorderSide(
                    //                     color: Color(0x00000000),
                    //                     width: 2.0,
                    //                   ),
                    //                   borderRadius: BorderRadius.circular(5.0),
                    //                 ),
                    //                 focusedErrorBorder: OutlineInputBorder(
                    //                   borderSide: BorderSide(
                    //                     color: Color(0x00000000),
                    //                     width: 2.0,
                    //                   ),
                    //                   borderRadius: BorderRadius.circular(5.0),
                    //                 ),
                    //                 filled: true,
                    //                 fillColor: FlutterFlowTheme.of(context)
                    //                     .primaryBackground,
                    //                 contentPadding:
                    //                     EdgeInsetsDirectional.fromSTEB(
                    //                         20.0, 24.0, 20.0, 24.0),
                    //               ),
                    //               style: FlutterFlowTheme.of(context).bodyMedium,
                    //               validator: _model.textController3Validator
                    //                   .asValidator(context),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: EdgeInsetsDirectional.fromSTEB(
                    //                 8.0, 0.0, 0.0, 0.0),
                    //             child: Icon(
                    //               Icons.add_box,
                    //               color: FlutterFlowTheme.of(context).primaryText,
                    //               size: 48.0,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: [
                    //     Flexible(
                    //       child: Padding(
                    //         padding: EdgeInsetsDirectional.fromSTEB(
                    //             0.0, 0.0, 0.0, 16.0),
                    //         child: FlutterFlowDropDown<String>(
                    //           controller: _model.dropDownValueController ??=
                    //               FormFieldController<String>(null),
                    //           options: ['City A', 'City B'],
                    //           onChanged: (val) =>
                    //               setState(() => _model.dropDownValue = val),
                    //           width: double.infinity,
                    //           height: 50.0,
                    //           textStyle: FlutterFlowTheme.of(context).bodyMedium,
                    //           hintText: 'Please select location',
                    //           icon: Icon(
                    //             Icons.keyboard_arrow_down_rounded,
                    //             color: FlutterFlowTheme.of(context).primaryText,
                    //             size: 24.0,
                    //           ),
                    //           fillColor:
                    //               FlutterFlowTheme.of(context).primaryBackground,
                    //           elevation: 2.0,
                    //           borderColor:
                    //               FlutterFlowTheme.of(context).primaryBackground,
                    //           borderWidth: 2.0,
                    //           borderRadius: 8.0,
                    //           margin: EdgeInsetsDirectional.fromSTEB(
                    //               16.0, 4.0, 16.0, 4.0),
                    //           hidesUnderline: true,
                    //           isSearchable: false,
                    //           isMultiSelect: false,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                        child: TextFormField(
                          controller: _model.textController5,
                          readOnly: true,
                          focusNode: _model.textFieldFocusNode5,
                          obscureText: false,
                          onTap: () async {
                            address = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Test(userLocation),
                              ),
                            );

                            if (address != null) {
                              setState(() {
                                print(address['PlaceName']);
                                print(address['latitude']);
                                print(address['longitude']);
                                // address = address['PlaceName'];
                                latitude = address['latitude'];
                                longitude = address['longitude'];
                                //userLocation = address['PlaceName'];
                              });
                              _model.textController5.text = address['PlaceName'];
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Address',
                            hintText: 'Enter your address',
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
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          maxLines: 10,
                          minLines: 5,
                          validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the event venue';
                              }
                              return null;
                            },
                        ),
                      ),
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      controller: _model.textController4,
                      focusNode: _model.textFieldFocusNode4,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Bio',
                        hintText: 'Enter bio',
                        hintStyle: FlutterFlowTheme.of(context).bodyLarge,
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
                      validator:
                          _model.textController4Validator.asValidator(context),
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
                        text: 'Save Changes',
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
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: FlutterFlowTheme.of(context).secondaryBackground,
                    //   ),
                    //   child: Padding(
                    //     padding:
                    //         EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                    //     child: Container(
                    //       width: 100.0,
                    //       decoration: BoxDecoration(
                    //         color: FlutterFlowTheme.of(context).primaryText,
                    //         borderRadius: BorderRadius.only(
                    //           bottomLeft: Radius.circular(12.0),
                    //           bottomRight: Radius.circular(12.0),
                    //           topLeft: Radius.circular(12.0),
                    //           topRight: Radius.circular(12.0),
                    //         ),
                    //       ),
                    //       child: Padding(
                    //         padding: EdgeInsetsDirectional.fromSTEB(
                    //             8.0, 2.0, 8.0, 2.0),
                    //         child: Row(
                    //           mainAxisSize: MainAxisSize.max,
                    //           children: [
                    //             Text(
                    //               '#Guitar',
                    //               style: FlutterFlowTheme.of(context)
                    //                   .bodyMedium
                    //                   .override(
                    //                     fontFamily: 'Outfit',
                    //                     color: FlutterFlowTheme.of(context)
                    //                         .secondaryBackground,
                    //                   ),
                    //             ),
                    //             Icon(
                    //               Icons.cancel_outlined,
                    //               color: FlutterFlowTheme.of(context).error,
                    //               size: 24.0,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
