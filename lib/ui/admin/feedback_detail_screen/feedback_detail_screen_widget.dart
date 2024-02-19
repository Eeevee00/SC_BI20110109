import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'feedback_detail_screen_model.dart';
export 'feedback_detail_screen_model.dart';
import '../../../data/models/feedback_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class FeedbackDataDetailScreenWidget extends StatefulWidget {
  final Feedbacks feedback;
  const FeedbackDataDetailScreenWidget({required this.feedback});

  @override
  _FeedbackDataDetailScreenWidgetState createState() =>
      _FeedbackDataDetailScreenWidgetState();
}

class _FeedbackDataDetailScreenWidgetState extends State<FeedbackDataDetailScreenWidget> {
  late FeedbackDataDetailScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProcessing = false;
  final db = FirebaseFirestore.instance;
  final _registerFormKey = GlobalKey<FormState>();
  late Feedbacks currentFeedback;

  CollectionReference docNotification = FirebaseFirestore.instance.collection('feedback');
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FeedbackDataDetailScreenModel());
  }

  String formatTimestamp(Timestamp timestamp) {
    if (timestamp == null) {
      return '';
    }

    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    
    return formattedDate;
  }

    // Function to delete a feedback document from the 'feedback' collection
    deleteFeedback() async {
        try {
           // Delete the feedback document using its UID
            await FirebaseFirestore.instance
                .collection('feedback') 
                .doc(widget.feedback.uid)
                .delete();

           // Show a success message
            Alert(
            context: context,
            type: AlertType.success,
            title: "Delete Feedback",
            desc: "Successfully deleted feedback",
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
        } catch (error) {
            // Print error details if deletion fails
            print('Error deleting feedback: $error');
            // Handle error as needed
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
            'Feedback Detail',
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
                        'Feedback Detail',
                        style: FlutterFlowTheme.of(context).headlineMedium.override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                      ),
                    ),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                        'Sender name',
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
                            Expanded(
                                flex: 2, // Adjust the flex value as needed
                                child:Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                            widget.feedback.sender_name!,
                                            textAlign: TextAlign.right,
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Outfit',
                                                color: FlutterFlowTheme.of(context).customColor1,
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
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                        'Sender email',
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
                            Expanded(
                                flex: 2, // Adjust the flex value as needed
                                child:Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                            widget.feedback.sender_email!,
                                            textAlign: TextAlign.right,
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Outfit',
                                                color: FlutterFlowTheme.of(context).customColor1,
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
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                        'Date created',
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
                            Expanded(
                                flex: 2, // Adjust the flex value as needed
                                child:Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                            formatTimestamp(widget.feedback.timestamp!),
                                            textAlign: TextAlign.right,
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Outfit',
                                                color: FlutterFlowTheme.of(context).customColor1,
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
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                        'Subject',
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
                            Expanded(
                                flex: 2, // Adjust the flex value as needed
                                child:Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                            widget.feedback.subject!,
                                            textAlign: TextAlign.right,
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Outfit',
                                                color: FlutterFlowTheme.of(context).customColor1,
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
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                    'Content',
                                    style: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).customColor1,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal,
                                    ),
                                    ),
                                ),
                            ),
                            Expanded(
                                flex: 2, // Adjust the flex value as needed
                                child:Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                            widget.feedback.content!,
                                            textAlign: TextAlign.right,
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Outfit',
                                                color: FlutterFlowTheme.of(context).customColor1,
                                            ),
                                        ),
                                    ),
                                ),
                            ),
                        ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          if (_registerFormKey.currentState?.validate() ?? false) {
                            await deleteFeedback();
                          }
                        },
                        text: 'Delete Feedback',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 55.0,
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          iconPadding:
                              EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).error,
                          textStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context)
                                        .customColor1,
                                    fontSize: 14.0,
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
