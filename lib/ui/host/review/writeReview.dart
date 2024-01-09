import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'package:getwidget/getwidget.dart';
import 'reviewList.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:alphacar/ui/widgets/textField_widget3.dart';
import 'package:getwidget/getwidget.dart';
import '../../../data/models/shared_pref.dart';
import 'dart:convert';
import '../../../data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';


class WriteReview extends StatefulWidget {
  final String? eventID;

  const WriteReview({Key? key, required this.eventID}) : super(key: key);

  @override
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
    final titleController = TextEditingController();
    TextEditingController textarea = TextEditingController();
    
    var ratings;
    late var name;

    SharedPref sharedPref = SharedPref();
    var user;
    String? userPic = "";
    String? firstName = "";
    String? lastName = "";
    String? userId = "";
    late Users currentUser;
    late SharedPreferences sharedPreferences;


    void initialGetSaved() async{
        sharedPreferences = await SharedPreferences.getInstance();
        
        setState(() {
            print(sharedPreferences.getString('current_user_image'));
            print(sharedPreferences.getString('current_user_name'));
            print(sharedPreferences.getString('current_user_uid'));
            userPic = sharedPreferences.getString('current_user_image');
            firstName = sharedPreferences.getString('current_user_name');
            userId = sharedPreferences.getString('current_user_uid');
        });
    }

    

    @override
    void initState() {
        super.initState();
        initialGetSaved();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            appBar: AppBar(
                backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                iconTheme:
                    IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
                automaticallyImplyLeading: true,
                title: Text(
                    'Event Detail',
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
            body: Center(
                child: Padding(
                padding: EdgeInsets.all(20),
                child: ListView(
                    children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Text(
                            'Write your review',
                            style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Outfit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .customColor1,
                                              ),
                        )),
                    Center(
                        child: RatingBar.builder(
                            unratedColor: Colors.grey,
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            updateOnDrag: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                                Ionicons.star,
                                color: Colors.yellow,
                                ),
                            onRatingUpdate: (rating) {
                            ratings = rating;
                            }),
                    ),
                    SizedBox(
                        height: 20,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(0),
                        child: TextFormField(
                          controller: titleController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Comment Title',
                            hintText: 'Enter the comment title',
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
                              return 'Please enter comment title';
                            }
                            return null;
                          },
                        ),
                    ),
                    
                    SizedBox(
                        height: 20,
                    ),

                    TextFormField(
                      controller: textarea,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Review Description',
                        hintText: 'Enter description',
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
                      validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description';
                            }
                            return null;
                          },
                    ),

                    SizedBox(
                        height: 20,
                    ),

                    Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          child: FFButtonWidget(
                            onPressed: () async {
                                if (ratings == null) {
                                    AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.WARNING,
                                        headerAnimationLoop: false,
                                        animType: AnimType.TOPSLIDE,
                                        showCloseIcon: true,
                                        closeIcon: const Icon(Icons.close_fullscreen_outlined),
                                        title: 'Fail to submit review.',
                                        desc:
                                        'Please add a rating.',
                                        btnOkOnPress: () {},
                                        btnOkText: "Tutup",
                                        btnOkColor: Colors.red,
                                    ).show();
                                } else if (titleController.text == '') {
                                    AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.WARNING,
                                        headerAnimationLoop: false,
                                        animType: AnimType.TOPSLIDE,
                                        showCloseIcon: true,
                                        closeIcon: const Icon(Icons.close_fullscreen_outlined),
                                        title: 'Fail to submit review.',
                                        desc:
                                        'Please add a Title to the review.',
                                        btnOkOnPress: () {},
                                        btnOkText: "Tutup",
                                        btnOkColor: Colors.red,
                                    ).show();
                                } else {
                                FirebaseFirestore.instance
                                    .collection("event")
                                    .doc(widget.eventID)
                                    .collection('reviews')
                                    .add({
                                        "title": titleController.text,
                                        "rating": ratings,
                                        "content": textarea.text,
                                        "userID": userId,
                                        "userImage": userPic,
                                        "timestamp": Timestamp.now(),
                                        "name": firstName,
                                        "lastName": lastName,
                                    });
                                    Navigator.pop(context);
                                }
                            },
                            text: 'Submit Review',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 55.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).primaryText,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    fontSize: 4.0,
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
        );
    }

}