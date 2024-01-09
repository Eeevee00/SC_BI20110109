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

class SendNotificationScreenWidget extends StatefulWidget {
  const SendNotificationScreenWidget({Key? key}) : super(key: key);

  @override
  _SendNotificationScreenWidgetState createState() =>
      _SendNotificationScreenWidgetState();
}

class _SendNotificationScreenWidgetState
    extends State<SendNotificationScreenWidget> {
  late SendNotificationScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProcessing = false;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SendNotificationScreenModel());
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  send_notification() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Add a document to the top-level "notifications" collection
      DocumentReference notificationDocRef = await firestore
          .collection('notification')
          .add({
            'title': _model.textController1.text,
            'content': _model.textController2.text,
            'timestamp': FieldValue.serverTimestamp(),
            'send_to': "user",
            'created_by': "",
          });

      String notificationUid = notificationDocRef.id;
      await firestore.collection('notification').doc(notificationUid).update({
        'uid': notificationUid,
      });

      QuerySnapshot usersQuery = await firestore
          .collection('users')
          .where('user_type', whereIn: ['host', 'seeker'])
          .where('status', isEqualTo: true)
          .get();

      for (QueryDocumentSnapshot userDoc in usersQuery.docs) {
        String docId = userDoc.id;

        if (userDoc['user_type'] == 'host') {
          await firestore
              .collection('users')
              .doc(docId)
              .collection('notification')
              .doc(notificationUid)
              .set({
                'title': _model.textController1.text,
                'content': _model.textController2.text,
                'timestamp': FieldValue.serverTimestamp(),
                'uid': notificationUid,
                'send_to': "user",
                'created_by': "",
                'read': false,
              });
        } else if (userDoc['user_type'] == 'seeker') {
          await firestore
              .collection('users')
              .doc(docId)
              .collection('notification')
              .doc(notificationUid)
              .set({
                'title': _model.textController1.text,
                'content': _model.textController2.text,
                'timestamp': FieldValue.serverTimestamp(),
                'uid': notificationUid,
                'send_to': "user",
                'created_by': "",
                'read': false,
              });
        }
      }

      Alert(
        context: context,
        type: AlertType.success,
        title: "Sending Notification",
        desc: "Notification successfully send to all user",
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
    } catch (error) {
      print('Error sending notification: $error');
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
            'Send Notification',
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
                          'Send Notification',
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
                              await send_notification();
                            }
                          },
                          text: 'Send Now',
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
