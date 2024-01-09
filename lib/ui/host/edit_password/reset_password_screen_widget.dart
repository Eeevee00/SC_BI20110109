import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'reset_password_screen_model.dart';
export 'reset_password_screen_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ResetPasswordScreenWidget extends StatefulWidget {
  const ResetPasswordScreenWidget({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenWidgetState createState() =>
      _ResetPasswordScreenWidgetState();
}

class _ResetPasswordScreenWidgetState
    extends State<ResetPasswordScreenWidget> {
  late ResetPasswordScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ResetPasswordScreenModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
     WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Future<void> resetPassword(context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _model.textController.text);
      Alert(
        context: context,
        type: AlertType.success,
        title: "Reset Password confirmation",
        desc:
            "Please check your email to continue with reseting your account password",
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: const Color(0xFFEE8B60),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    } on FirebaseAuthException catch (e) {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "Password reset fail",
        desc: "fail to send email because it didnt exist.",
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: const Color(0xFFFF5963),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
      return;
    }
  }

  notice(context) {
    Navigator.pop(context);
    resetPassword(context);
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
            'Change Password',
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 50.0, 0.0, 16.0),
                  child: Text(
                    'Change Password',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 16.0),
                  child: Text(
                    'Please enter your email address below. We will send you a link to reset your password.',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).customColor1,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _model.textController,
                    focusNode: _model.textFieldFocusNode,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'Enter your email',
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
                      contentPadding: EdgeInsetsDirectional.fromSTEB(
                          20.0, 24.0, 20.0, 24.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium,
                    validator:
                        _model.textControllerValidator.asValidator(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      if(_model.textController.text.isEmpty){
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "Reset password fail",
                          desc: "Please enter your email",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Close",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              color: const Color(0xFFFF5963),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            )
                          ],
                        ).show();
                      }else{
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "Reset password",
                          desc: "Confirm to reset password?",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => notice(context),
                              color: const Color(0xFFEE8B60),
                            ),
                            DialogButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              color: const Color(0xFFFF5963),
                            )
                          ],
                        ).show();
                      }
                    },
                    text: 'Reset Password',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
