import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'verification_form_model.dart';
export 'verification_form_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/shared_pref.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class VerificationFormWidget extends StatefulWidget {
  final String uid;
  const VerificationFormWidget({required this.uid});

  @override
  _VerificationFormWidgetState createState() => _VerificationFormWidgetState();
}

class _VerificationFormWidgetState extends State<VerificationFormWidget> {
  late VerificationFormModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  File? _selectedImage_1;
  File? _selectedImage_2;
  final picker = ImagePicker();

  Future<void> _pickImage_1() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _selectedImage_1 = File(pickedFile.path);
      } else {
        print('No image captured.');
      }
    });
  }

  Future<void> _pickImage_2() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _selectedImage_2 = File(pickedFile.path);
      } else {
        print('No image captured.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_selectedImage_1 == null && _selectedImage_2 == null) {
      return;
    }

    Reference storageReference_1 = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    
    Reference storageReference_2 = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    UploadTask uploadTask_1 = storageReference_1.putFile(_selectedImage_1!);
    UploadTask uploadTask_2 = storageReference_2.putFile(_selectedImage_2!);

    await uploadTask_1.whenComplete(() => print('Image uploaded'));
    await uploadTask_2.whenComplete(() => print('Image uploaded'));

    String downloadURL_1 = await storageReference_1.getDownloadURL();
    String downloadURL_2 = await storageReference_2.getDownloadURL();
    updateUserData(downloadURL_1, downloadURL_2);
    print('Download URL: $downloadURL_1');
    print('Download URL: $downloadURL_2');
  }

  Future<void> updateUserData(String image_1, String image_2) async {
    CollectionReference<Map<String, dynamic>> usersCollection =
        FirebaseFirestore.instance.collection('users');

    QuerySnapshot<Map<String, dynamic>> userQuery =
        await usersCollection.where('uid', isEqualTo: widget.uid).get();

    if (userQuery.docs.isNotEmpty) {
      DocumentReference<Map<String, dynamic>> userDocRef =
          usersCollection.doc(userQuery.docs.first.id);

      await userDocRef.update({
        'proof_for_verification_1': image_1,
        'proof_for_verification_2': image_2,
        'request_to_verify': true,
        'verification_detail': _model.textController.text,
      });
      print("update complete");
      Alert(
                context: context,
                type: AlertType.success,
                title: "Verification",
                desc: "Successfully submit detail for verification",
                buttons: [
                  DialogButton(
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: const Color(0xFFEE8B60),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    width: 120,
                  )
                ],
              ).show();
    } else {
      print('User not found with uid: $widget.uid');
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VerificationFormModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
            'Verification',
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
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                      child: Text(
                        'User verification',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 16.0),
                      child: Text(
                        'Please submit your front and back identification card as a prove for verification.',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).customColor1,
                            ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _selectedImage_1 != null
                              ? RotatedBox(
                                quarterTurns: 1,
                                child: Image.file(_selectedImage_1!),
                              )
                              : 
                              Text('No image selected',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).customColor1,
                            ),),
                          SizedBox(height: 20),
                          FFButtonWidget(
                            onPressed: () async {
                              await  _pickImage_1();
                            },
                            text: 'Front I/C Image',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 55.0,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primaryText,
                              textStyle:
                                  FlutterFlowTheme.of(context).titleMedium.override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        fontSize: 4.0,
                                      ),
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _selectedImage_2 != null
                              ? RotatedBox(
                                  quarterTurns: 1,
                                  child: Image.file(_selectedImage_2!),
                                )
                              : 
                              Text('No image selected',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).customColor1,
                            ),),
                          SizedBox(height: 20),
                          FFButtonWidget(
                            onPressed: () async {
                              await  _pickImage_2();
                            },
                            text: 'Back I/C Image',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 55.0,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primaryText,
                              textStyle:
                                  FlutterFlowTheme.of(context).titleMedium.override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        fontSize: 4.0,
                                      ),
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 16.0),
                      child: TextFormField(
                        controller: _model.textController,
                        focusNode: _model.textFieldFocusNode,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Detail',
                          hintText:
                              'Tell us more about you to prove credibility.',
                          hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                          labelStyle: TextStyle( // Add this block for label text style
                              color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                            ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
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
                        validator:
                            _model.textControllerValidator.asValidator(context),
                      ),
                    ),
                    FFButtonWidget(
                      onPressed: () async {
                        await _uploadImage();
                      },
                      text: 'Upload Detail for Verification',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 55.0,
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primaryText,
                        textStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  fontSize: 4.0,
                                ),
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                     SizedBox(height: 180.0),
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
