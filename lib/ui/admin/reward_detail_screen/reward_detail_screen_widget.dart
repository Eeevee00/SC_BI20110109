import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'reward_detail_screen_model.dart';
export 'reward_detail_screen_model.dart';
import '../../../data/models/reward_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'edit_image.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class RewardDetailScreenWidget extends StatefulWidget {
  final Reward reward;
  const RewardDetailScreenWidget({required this.reward});

  @override
  _RewardDetailScreenWidgetState createState() =>
      _RewardDetailScreenWidgetState();
}

class _RewardDetailScreenWidgetState extends State<RewardDetailScreenWidget> {
  late RewardDetailScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProcessing = false;
  final db = FirebaseFirestore.instance;
  final _registerFormKey = GlobalKey<FormState>();
  late Reward currentReward;
  var _image;
  var status = false;
  final EditProfileState _editProfileState = EditProfileState();
  CollectionReference docReward = FirebaseFirestore.instance.collection('rewards');
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RewardDetailScreenModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();

    _model.textController1.text = widget.reward.name!;
    _model.textController2.text = widget.reward.point!;
    _model.textController3.text = widget.reward.quantity!;
    _model.textController4.text = widget.reward.description!;
    status = widget.reward.status!;
    _initializeFirebase();
  }

  image(pictures){
    var list = pictures;
    var stringList = list.join("");
    return stringList;
  }

  _initializeFirebase() async {
    return docReward.doc(widget.reward.uid).snapshots().listen((data) async {
      currentReward = Reward.fromDocument(data);
      var list = data['image'];
      var stringList = list.join("");
      setState(() {
        currentReward = Reward.fromDocument(data);
        _image = stringList;
      });
    });
  }

  Future<void> updateStatus() async {
    var _status;
    if(status == true){
      _status = false;
    }else{
      _status = true;
    }
    try {
      await FirebaseFirestore.instance
          .collection('rewards')
          .doc(widget.reward.uid)
          .update({'status': _status});
      print('Status updated successfully.');
      if(status == true){
        Alert(
          context: context,
          type: AlertType.success,
          title: "Update Status",
          desc: "Reward deactivated",
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
        Alert(
          context: context,
          type: AlertType.success,
          title: "Update Status",
          desc: "Reward activated",
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
      setState(() {
        status = _status;
      });
    } catch (error) {
      print('Error updating status: $error');
      // Handle error as needed
    }
  }

  Future<void> updateReward() async {
    setState(() {
      _isProcessing = true;
    });
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      String uid = widget.reward.uid!; 

      DocumentSnapshot rewardDoc = await firestore.collection('rewards').doc(uid).get();

      if (rewardDoc.exists) {
        await firestore.collection('rewards').doc(uid).update({
          'name': _model.textController1.text,
          'point': _model.textController2.text,
          'quantity': _model.textController3.text,
          'description': _model.textController4.text,
          'text_status': "Open",
        });

        Alert(
          context: context,
          type: AlertType.success,
          title: "Update Reward",
          desc: "Successfully updated reward detail",
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
        setState(() {
          _isProcessing = false;
        });
      } else {
        print('Reward with UID $uid not found');
      }
    } catch (error) {
      print('Error updating reward details: $error');
    }
    setState(() {
      _isProcessing = false;
    });
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
          iconTheme:IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Text('Reward Detail',
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
          child: SingleChildScrollView(
            child: Form(
              key: _registerFormKey,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 20.0, 16.0, 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 20.0),
                      child: Text(
                        'Reward Detail',
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize:20,
                            ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 120,
                                  backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                  child: Material(
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    child: Stack(
                                      children: <Widget>[
                                        _image == null || _image == "Empty" // Check if _image is null or "Empty"
                                            ? Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Image.network(
                                                    'https://user-images.githubusercontent.com/43302778/106805462-7a908400-6645-11eb-958f-cd72b74a17b3.jpg',
                                                    width: double.infinity,
                                                    height: 160.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Image.network(
                                                    _image,
                                                    width: double.infinity,
                                                    height: 200.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ],
                                              ),
                                        Positioned(
                                          bottom: 16, // Adjust the bottom value as needed
                                          right: -4,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30)),
                                            color: Theme.of(context).primaryColor,
                                            child: IconButton(
                                              alignment: Alignment.center,
                                              icon: Icon(
                                                Icons.photo_camera,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                              onPressed: () async {
                                                var a = await _editProfileState.source(
                                                    context, currentReward, true);
                                                _initializeFirebase();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                      child: TextFormField(
                        controller: _model.textController1,
                        focusNode: _model.textFieldFocusNode1,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Reward',
                          hintText: 'Enter reward',
                          hintStyle: FlutterFlowTheme.of(context).bodyMedium,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter reward name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                      child: TextFormField(
                        controller: _model.textController2,
                        focusNode: _model.textFieldFocusNode2,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Point to claim',
                          hintText: 'Enter point needed to claim',
                          hintStyle: FlutterFlowTheme.of(context).bodyMedium,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter point to claim';
                          }
                          // Convert the value to a numeric type (assuming it's a number)
                          int? numericValue = int.tryParse(value);

                          // Check if the numeric value is less than or equal to 0
                          if (numericValue == null || numericValue <= 0) {
                            return 'Please enter a point greater than 0';
                          }

                          // Return null if validation succeeds
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                      child: TextFormField(
                        controller: _model.textController3,
                        focusNode: _model.textFieldFocusNode3,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Available quantity',
                          hintText: 'Quantity of the reward avaialble',
                          hintStyle: FlutterFlowTheme.of(context).bodyMedium,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter quantity';
                          }
                          // Convert the value to a numeric type (assuming it's a number)
                          int? numericValue = int.tryParse(value);

                          // Check if the numeric value is less than or equal to 0
                          if (numericValue == null || numericValue <= 0) {
                            return 'Please enter a quantity greater than 0';
                          }

                          // Return null if validation succeeds
                          return null;
                        },
                      ),
                    ),
                    TextFormField(
                      controller: _model.textController4,
                      focusNode: _model.textFieldFocusNode4,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Reward Description',
                        hintText: 'Enter reward description',
                        hintStyle: FlutterFlowTheme.of(context).bodyMedium,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null; // Return null if validation succeeds
                      },
                    ),

                                        //Status
                   // Status
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 5.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          if (_registerFormKey.currentState?.validate() ?? false) {
                            await updateStatus();
                          }
                        },
                        text: 'Current Status: ${status == true ? "Active" : "Deactivated"}',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 60.0,
                          color: status == true
                              ? FlutterFlowTheme.of(context).success // Green color for 'Activate'
                              : FlutterFlowTheme.of(context).error, // Red color for 'Deactivate'
                          //borderRadius: 5.0,
                          elevation: 5.0,
                          textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Outfit',
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),

                    //Save button
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          if (_registerFormKey.currentState?.validate() ?? false) {
                            await updateReward();
                          }
                        },
                        text: 'Save',
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
                                    fontSize: 15.0,
                                  ),
                          elevation: 2.0,
                          //borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),

                     //Status
                    // Padding(
                    //   padding:EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 5.0),
                    //     child: InkWell(
                    //       onTap: () async {
                    //         if (_registerFormKey.currentState?.validate() ?? false) {
                    //           await updateStatus();
                    //         }
                    //       },
                    //       child: Material(
                    //         color: Colors.transparent,
                    //         elevation: 5.0,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(5.0),
                    //         ),
                    //         child: Container(
                    //           width: double.infinity,
                    //           height: 60.0,
                    //           decoration: BoxDecoration(
                              
                    //           color: status == true
                    //               ? FlutterFlowTheme.of(context).success // Green color for 'Activate'
                    //               : FlutterFlowTheme.of(context).error, // Red color for 'Deactivate'
                              
                    //             boxShadow: [
                    //               BoxShadow(
                    //                 blurRadius: 4.0,
                    //                 color: Color(0x33000000),
                    //                 offset: Offset(0.0, 2.0),
                    //               )
                    //             ],
                    //             borderRadius: BorderRadius.circular(5.0),
                    //           ),
                    //           alignment: Alignment.center, // Center the content horizontally and vertically
                    //           child: Padding(
                    //             padding: EdgeInsets.all(12.0),
                    //             child: Row(
                    //               mainAxisSize: MainAxisSize.max,
                    //               mainAxisAlignment: MainAxisAlignment.center, // Center the text horizontally
                    //               children: [
                    //                 Padding(
                    //                   padding: EdgeInsetsDirectional.fromSTEB(
                    //                       0.0, 0.0, 0.0, 0.0),
                    //                   child: Text(
                    //                     'Status:',
                    //                     style: FlutterFlowTheme.of(context)
                    //                         .titleMedium
                    //                         .override(
                    //                           fontFamily: 'Outfit',
                    //                           color: FlutterFlowTheme.of(context)
                    //                               .secondaryBackground,
                    //                           fontSize: 14.0,

                    //                         ),
                    //                   ),
                    //                 ),
                    //                 Padding(
                    //                   padding: EdgeInsetsDirectional.fromSTEB(
                    //                       12.0, 0.0, 0.0, 0.0),
                    //                   child: Text(
                    //                     status == true?"Active":"Deactivated",
                    //                     style: FlutterFlowTheme.of(context)
                    //                         .titleMedium
                    //                         .override(
                    //                           fontFamily: 'Outfit',
                    //                           color: FlutterFlowTheme.of(context)
                    //                               .secondaryBackground,
                    //                                fontSize: 14.0,

                    //                         ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    // ),
                             
                    // Padding(
                    //   padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                    //   child: FFButtonWidget(
                    //     onPressed: () async {
                    //       if (_registerFormKey.currentState?.validate() ?? false) {
                    //         await updateStatus();
                    //       }
                    //     },
                    //     text: 'Deactivate/Activate Reward',
                    //     options: FFButtonOptions(
                    //       width: double.infinity,
                    //       height: 55.0,
                    //       padding:
                    //           EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    //       iconPadding:
                    //           EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    //       color: FlutterFlowTheme.of(context).error,
                    //       textStyle:
                    //           FlutterFlowTheme.of(context).titleMedium.override(
                    //                 fontFamily: 'Outfit',
                    //                 color: FlutterFlowTheme.of(context)
                    //                     .customColor1,
                    //                 fontSize: 14.0,
                    //               ),
                    //       elevation: 2.0,
                    //       borderRadius: BorderRadius.circular(5.0),
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
