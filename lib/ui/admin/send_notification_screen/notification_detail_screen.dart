import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'send_notification_screen_model.dart';
export 'send_notification_screen_model.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../service/auth.dart';
import '../../../service/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationDetailScreenWidget extends StatefulWidget {
    final String uid;
  const NotificationDetailScreenWidget({required this.uid});

  @override
  _NotificationDetailScreenWidgetState createState() =>
      _NotificationDetailScreenWidgetState();
}

class _NotificationDetailScreenWidgetState
    extends State<NotificationDetailScreenWidget> {
  late SendNotificationScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProcessing = false;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? notificationDetails;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SendNotificationScreenModel());
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    loadNotificationDetails();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

    Future<Map<String, dynamic>> getNotificationDetails(String uid) async {
        try {
            FirebaseFirestore firestore = FirebaseFirestore.instance;
            DocumentSnapshot notificationDoc =
                await firestore.collection('notification').doc(uid).get();

            if (notificationDoc.exists) {
            Map<String, dynamic> notificationDetails = {
                'title': notificationDoc['title'],
                'content': notificationDoc['content'],
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

  Future<void> loadNotificationDetails() async {
    Map<String, dynamic>? details = await getNotificationDetails(widget.uid);
        setState(() {
            notificationDetails = details;
            _model.textController1.text = notificationDetails!['title']!;
            _model.textController2.text = notificationDetails!['content']!;
        });
    }

    delete_notification() async {
        await Alert(
            context: context,
            type: AlertType.warning,
            title: "Delete Notification",
            desc: "Deleting this notification will not delete notification at user side.",
            buttons: [
                DialogButton(
                child: Text(
                    "Confirm",
                    style: TextStyle(
                    color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () async {
                        try {
                            FirebaseFirestore firestore = FirebaseFirestore.instance;
                            
                            await firestore.collection('notification').doc(widget.uid).delete();
                            
                            Alert(
                                context: context,
                                type: AlertType.success,
                                title: "Delete Notification",
                                desc: "Successfully delete notification",
                                buttons: [
                                    DialogButton(
                                    child: Text(
                                        "Close",
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                    },
                                    width: 120,
                                    )
                                ],
                            ).show();
                        } catch (error) {
                            // Handle errors
                            print('Error deleting notification: $error');
                        }
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
            'Notification Detail',
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
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 20.0),
                        child: Text(
                          'Notification Detail',
                          style: FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                        child: TextFormField(
                          controller: _model.textController1,
                          readOnly: true,
                          focusNode: _model.textFieldFocusNode1,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Subject',
                            hintText: 'Enter subject',
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
                          validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Subject';
                          }
                          return null; // Return null if validation succeeds
                        },
                        ),
                      ),
                      TextFormField(
                        controller: _model.textController2,
                        readOnly: true,
                        focusNode: _model.textFieldFocusNode2,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Content',
                          hintText: 'Enter the content',
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
                            return 'Please enter content';
                          }
                          return null; // Return null if validation succeeds
                        },
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await delete_notification();
                            }
                          },
                          text: 'Delete Notification',
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
