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

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_image.dart';

class AddRewardScreenWidget extends StatefulWidget {
  const AddRewardScreenWidget({Key? key}) : super(key: key);

  @override
  _AddRewardScreenWidgetState createState() =>
      _AddRewardScreenWidgetState();
}

class _AddRewardScreenWidgetState extends State<AddRewardScreenWidget> {
  late RewardDetailScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProcessing = false;
  final db = FirebaseFirestore.instance;
  final _registerFormKey = GlobalKey<FormState>();

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
  }

  image(pictures){
    var list = pictures;
    var stringList = list.join("");
    return stringList;
  }

  Future<void> saveReward() async {
    try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        DocumentReference rewardsRef = await firestore.collection('rewards').add({
            'name': _model.textController1.text,
            'point': _model.textController2.text,
            'quantity': _model.textController3.text,
            'description': _model.textController4.text,
            'image': ['https://cdn.vectorstock.com/i/preview-1x/65/30/default-image-icon-missing-picture-page-vector-40546530.jpg'], 
            'uid': '', 
            'timestamp': FieldValue.serverTimestamp(),
            'text_status': "New",
            'status': true,
        });

        String rewardUid = rewardsRef.id;

        await rewardsRef.update({'uid': rewardUid});
        Alert(
            context: context,
            type: AlertType.success,
            title: "Add New Reward",
            desc: "Successfully added new reward",
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
        print('Reward details saved successfully with UID: $rewardUid');
    } catch (error) {
        print('Error saving reward details: $error');
    } finally {
        setState(() {
        _isProcessing = false;
        });
    }
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
            'Reward Detail',
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
                              fontSize: 20.0,

                            ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                        child: Center(
                            child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                                fadeInDuration: Duration(milliseconds: 500),
                                fadeOutDuration: Duration(milliseconds: 500),
                                imageUrl: 'https://cdn.vectorstock.com/i/preview-1x/65/30/default-image-icon-missing-picture-page-vector-40546530.jpg',
                                width: 250,
                                fit: BoxFit.cover,
                            ),
                            ),
                        ),
                    ),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                        child: Center(
                            child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                                Expanded(
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                    'Update image once successfully added reward to confirm reward',
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).primaryText,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                    ),
                                    ),
                                ),
                                ),
                            ],
                            ),
                        ),
                    ),
                    // Row(
                    //   mainAxisSize: MainAxisSize.max,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Center(
                    //       child: Stack(
                    //         children: [
                    //           Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: CircleAvatar(
                    //                 radius: 120,
                    //                 backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                    //                 child: Material(
                    //                   color: FlutterFlowTheme.of(context).secondaryBackground,
                    //                   child: Stack(
                    //                     children: <Widget>[
                    //                       _image == "Empty" ? 
                    //                       Column(
                    //                         mainAxisSize: MainAxisSize.max,
                    //                         children: [
                    //                           Image.network(
                    //                             'https://user-images.githubusercontent.com/43302778/106805462-7a908400-6645-11eb-958f-cd72b74a17b3.jpg',
                    //                             width: double.infinity,
                    //                             height: 160.0,
                    //                             fit: BoxFit.cover,
                    //                           ),
                    //                         ],
                    //                       )
                    //                       :
                    //                       Column(
                    //                         mainAxisSize: MainAxisSize.max,
                    //                         children: [
                    //                           Image.network(
                    //                             _image,
                    //                             width: double.infinity,
                    //                             height: 200.0,
                    //                             fit: BoxFit.cover,
                    //                           ),
                    //                         ],
                    //                       ),
                    //                       Positioned(
                    //                             bottom: 16, // Adjust the bottom value as needed
                    //                             right: -4, 
                    //                         child: Card(
                    //                           shape: RoundedRectangleBorder(
                    //                               borderRadius: BorderRadius.circular(30)),
                    //                           color: Theme.of(context).primaryColor,
                    //                           child: IconButton(
                    //                               alignment: Alignment.center,
                    //                               icon: Icon(
                    //                                 Icons.photo_camera,
                    //                                 size: 25,
                    //                                 color: Colors.white,
                    //                               ),
                    //                               onPressed: () async {
                    //                                 var a = await _editProfileState.source(
                    //                                     context, currentReward, true);
                    //                                 _initializeFirebase();
                    //                               }),
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    
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
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                            return 'Please enter points to claim';
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
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          if (_registerFormKey.currentState?.validate() ?? false) {
                            await saveReward();
                          }
                        },
                        text: 'Save',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 55.0,
                          padding:EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          iconPadding:EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primaryText,
                          textStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    fontSize: 19.0,
                                  ),
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(5.0),
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
