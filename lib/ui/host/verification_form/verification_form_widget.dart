import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../data/models/user_model.dart';
import '../../../data/models/shared_pref.dart';
import 'verification_form_model.dart';
export 'verification_form_model.dart';

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
    //final pickedFile = await picker.pickImage(source: ImageSource.camera);
    //final pickedFile =await _showImageSourceDialog(ImageSource.camera);
  final pickedFile = await _showImageSourceDialog(ImageSource.camera, isFrontImage: true);

    // setState(() {
    //   if (pickedFile != null) {
    //     _selectedImage_1 = File(pickedFile.path);
    //   } else {
    //     print('No image captured.');
    //   }
    // });
  }

  Future<void> _pickImage_2() async {
    //final pickedFile = await picker.pickImage(source: ImageSource.camera);
    //final pickedFile =await _showImageSourceDialog(ImageSource.camera);
  final pickedFile = await _showImageSourceDialog(ImageSource.camera, isFrontImage: false);

    // setState(() {
    //   if (pickedFile != null) {
    //     _selectedImage_2 = File(pickedFile.path);
    //   } else {
    //     print('No image captured.');
    //   }
    // });
  }

  //Future<void> _showImageSourceDialog(ImageSource source) async {
    Future<void> _showImageSourceDialog(ImageSource source, {required bool isFrontImage}) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Select Image Source"),
          content: Text("Select source"),
          actions: [
            // Camera option
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.photo_camera,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    Text(
                      " Camera",
                      style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                    _getImage(source, isFrontImage).then((success) {
                        Navigator.pop(context); // Dismiss the dialog when image selection is complete
                      });
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Gallery option
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.photo_library,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    Text(
                      " Gallery",
                      style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                    _getImage(ImageSource.gallery, isFrontImage).then((success) {
                        Navigator.pop(context); // Dismiss the dialog when image selection is complete
                      });
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    },
                  );
                },

              ),
            ),
          ],
        );
      },
    );
      _getImage(source, isFrontImage);

  }

  //Future<void> _getImage(ImageSource source) async {
    Future<void> _getImage(ImageSource source, bool isFrontImage) async {

    final pickedFile = await picker.pickImage(source: source);

  setState(() {
    if (pickedFile != null) {
      if (isFrontImage) {
        _selectedImage_1 = File(pickedFile.path);
      } else {
        _selectedImage_2 = File(pickedFile.path);
      }
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
        .child('verifications/${DateTime.now().millisecondsSinceEpoch}.jpg');
    
    Reference storageReference_2 = FirebaseStorage.instance
        .ref()
        .child('verifications/${DateTime.now().millisecondsSinceEpoch}.jpg');

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
                desc: "Successfully submitted detail for verification",
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
            'Verification Submission',
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
                child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 20.0, 0.0, 20.0),
                      child: Text(
                        'Verification Submission',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 20.0,

                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 30.0),
                      child: Text(
                        'Please submit your front and back identification card as a prove for verification.',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).customColor1,
                            ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _selectedImage_1 != null
                              ? Image.file(_selectedImage_1!) // Display the image without rotation
                              : 
                              Container(
                                padding: EdgeInsetsDirectional.fromSTEB(108.0, 20.0, 108.0, 20.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                ),
                                child: Text(
                                  'No image selected',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                ),
                              ),
                          SizedBox(height: 20),
                          FFButtonWidget(
                            onPressed: () async {
                              await  _pickImage_1();
                            },
                            text: 'Front I/C Image',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 55.0,
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primaryText,
                              textStyle:
                                  FlutterFlowTheme.of(context).titleMedium.override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).secondaryBackground,
                                        fontSize:16.0,
                                      ),
                              elevation: 2.0,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _selectedImage_2 != null
                              ? Image.file(_selectedImage_2!)
                              : 
                              Container(
                                padding: EdgeInsetsDirectional.fromSTEB(108.0, 20.0, 108.0, 20.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                ),
                                child: Text(
                                  'No image selected',
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                ),
                              ),
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
                                        fontSize:16.0,
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
                          hintStyle: FlutterFlowTheme.of(context).bodyMedium,
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
                          fillColor: FlutterFlowTheme.of(context).primaryBackground,
                          
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        maxLines: 10,
                        minLines: 5,
                        validator: _model.textControllerValidator.asValidator(context),
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
                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                  fontSize:16.0,
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
    );
  }
}
