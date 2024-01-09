import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_screen_model.dart';
export 'login_screen_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../service/auth.dart';
import '../../../service/validator.dart';

import '../forgot_password_screen/forgot_password_screen_widget.dart';
import '../../admin/admin_dashboard_screen/admin_dashboard_screen_widget.dart';
import '../../host/host_dashboard_screen/host_dashboard_screen_widget.dart';
import '../../seeker/seeker_dashboard_screen/seeker_dashboard_screen_widget.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({Key? key}) : super(key: key);

  @override
  _LoginScreenWidgetState createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  late LoginScreenModel _model;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
   bool _isProcessing = false;

  @override
  void initState() {
    _initializeFirebase();
    super.initState();
    _model = createModel(context, () => LoginScreenModel());
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

  Future<FirebaseApp> _initializeFirebase() async {
    var documentData;
    var userExist = false;
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
        await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: user.email).get().then((value) {
              value.docs.forEach((element) async {
                setState(() {
                  userExist = true;
                  documentData = element;
                });
              });
        });

        if(userExist == true){
          if(documentData['user_type'] == "admin"){
            if (user != null) {
              Navigator.of(context)
                .pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                      //ContractorHomePageScreenWidget(user: user),
                      AdminDashboardScreenWidget(user: user),
                  ),
                );
            }
          }
          else if(documentData['user_type'] == "superadmin"){
            if (user != null) {
              Navigator.of(context)
                .pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                      //ManagerHomePageScreenWidget(user: user),
                      AdminDashboardScreenWidget(user: user),
                  ),
                );
            }
          }
          else if(documentData['user_type'] == "host"){
            if (user != null) {
              Navigator.of(context)
                .pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                      //ManagerHomePageScreenWidget(user: user),
                      HostDashboardScreenWidget(user: user),
                  ),
                );
            }
          }
          else if(documentData['user_type'] == "seeker"){
            if (user != null) {
                Navigator.of(context)
                .pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                      SeekerDashboardScreenWidget(user: user),
                      //SeekerDashboardScreenWidget(user: user),
                  ),
                );
            }
          }
        }
    }
    return firebaseApp;
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
            'Sign In',
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Container(
                  height: 180.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: Image.asset(
                        'assets/images/asd.png',
                      ).image,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                    ),
                  ),
                ),
                Container(
                  height: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16.0),
                                bottomRight: Radius.circular(16.0),
                                topLeft: Radius.circular(0.0),
                                topRight: Radius.circular(0.0),
                              ),
                            ),
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Muzik Local',
                                      textAlign: TextAlign.center,
                                      style:
                                          FlutterFlowTheme.of(context).displaySmall,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Discover the music around you',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context)
                                                .customColor1,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(32.0, 12.0, 32.0, 32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 24.0),
                            child: Text(
                              'Log in to your account',
                              style: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    color:
                                        FlutterFlowTheme.of(context).customColor1,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 16.0),
                            child: TextFormField(
                              controller: _model.textController1,
                              focusNode: _model.textFieldFocusNode1,
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
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        FlutterFlowTheme.of(context).primaryText,
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
                                fillColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 24.0, 20.0, 24.0),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              validator: _model.textController1Validator
                                  .asValidator(context),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 16.0),
                            child: TextFormField(
                              controller: _model.textController2,
                              focusNode: _model.textFieldFocusNode2,
                              obscureText: !_model.passwordVisibility,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
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
                                    color:
                                        FlutterFlowTheme.of(context).primaryText,
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
                                fillColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    20.0, 24.0, 20.0, 24.0),
                                suffixIcon: InkWell(
                                  onTap: () => setState(
                                    () => _model.passwordVisibility =
                                        !_model.passwordVisibility,
                                  ),
                                  focusNode: FocusNode(skipTraversal: true),
                                  child: Icon(
                                    _model.passwordVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    size: 22.0,
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium,
                              validator: _model.textController2Validator
                                  .asValidator(context),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FFButtonWidget(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ForgotPasswordScreenWidget(),
                                      ),
                                    );
                                  },
                                  text: 'Forgot Password?',
                                  options: FFButtonOptions(
                                    width: 150.0,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          color: FlutterFlowTheme.of(context)
                                              .customColor1,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    elevation: 0.0,
                                  ),
                                ),
                                _isProcessing ? 
                                CircularProgressIndicator()
                                : 
                                FFButtonWidget(
                                  onPressed:() async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isProcessing = true;
                                      });

                                      var documentData;
                                      var userExist = false;

                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .where('email', isEqualTo: _model.textController1.text)
                                          .get()
                                          .then((value) {
                                        value.docs.forEach((element) async {
                                          setState(() {
                                            userExist = true;
                                            documentData = element;
                                          });
                                        });
                                      });

                                      if (userExist && documentData['status'] == true) {
                                        try {
                                          User? user = await FireAuth.signInUsingEmailPassword(
                                            email: _model.textController1.text,
                                            password: _model.textController2.text,
                                            context: context,
                                          );
                                          print(user);

                                          if (user != null) {
                                            // Check user type and navigate accordingly
                                            switch (documentData['user_type']) {
                                              case "admin":
                                                Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) => AdminDashboardScreenWidget(user: user),
                                                  ),
                                                );
                                                break;
                                              case "superadmin":
                                                Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) => AdminDashboardScreenWidget(user: user),
                                                  ),
                                                );
                                                break;
                                              case "host":
                                                Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) => HostDashboardScreenWidget(user: user),
                                                  ),
                                                );
                                                break;
                                              case "seeker":
                                                Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) => SeekerDashboardScreenWidget(user: user),
                                                  ),
                                                );
                                                break;
                                              default:
                                                // Handle unknown user type
                                                print("Unknown user type: ${documentData['user_type']}");
                                            }
                                          }else{
                                            Alert(
                                              context: context,
                                              type: AlertType.error,
                                              title: "Login error",
                                              desc: "Wrong email or password.",
                                              buttons: [
                                                DialogButton(
                                                  child: Text(
                                                    "Close",
                                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                                  ),
                                                  onPressed: () => Navigator.pop(context),
                                                  width: 120,
                                                )
                                              ],
                                            ).show();
                                          }
                                        } catch (e) {
                                          print("Error logging in: $e");
                                          Alert(
                                            context: context,
                                            type: AlertType.error,
                                            title: "Login error",
                                            desc: "Invalid email or password.",
                                            buttons: [
                                              DialogButton(
                                                child: Text(
                                                  "Close",
                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                ),
                                                onPressed: () => Navigator.pop(context),
                                                width: 120,
                                              )
                                            ],
                                          ).show();
                                        }
                                      } else {
                                        Alert(
                                          context: context,
                                          type: AlertType.error,
                                          title: "Login error",
                                          desc: "Invalid email or user not found.",
                                          buttons: [
                                            DialogButton(
                                              child: Text(
                                                "Close",
                                                style: TextStyle(color: Colors.white, fontSize: 20),
                                              ),
                                              onPressed: () => Navigator.pop(context),
                                              width: 120,
                                            )
                                          ],
                                        ).show();
                                      }

                                      setState(() {
                                        _isProcessing = false;
                                      });
                                    }
                                  },
                                  text: 'Login',
                                  options: FFButtonOptions(
                                    width: 150.0,
                                    height: 50.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color:
                                        FlutterFlowTheme.of(context).primaryText,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          fontFamily: 'Outfit',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          fontSize: 14.0,
                                        ),
                                    elevation: 3.0,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsetsDirectional.fromSTEB(
                          //       0.0, 20.0, 0.0, 0.0),
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.max,
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       // You will have to add an action on this rich text to go to your login page.
                          //       Padding(
                          //         padding: EdgeInsetsDirectional.fromSTEB(
                          //             0.0, 12.0, 0.0, 12.0),
                          //         child: RichText(
                          //           textScaleFactor:
                          //               MediaQuery.of(context).textScaleFactor,
                          //           text: TextSpan(
                          //             children: [
                          //               TextSpan(
                          //                 text: 'Dont have account? ',
                          //                 style: TextStyle(
                          //                   color: FlutterFlowTheme.of(context)
                          //                       .customColor1,
                          //                 ),
                          //               ),
                          //               TextSpan(
                          //                 text: 'Sign Up here',
                          //                 style: FlutterFlowTheme.of(context)
                          //                     .bodyMedium
                          //                     .override(
                          //                       fontFamily: 'Outfit',
                          //                       color:
                          //                           FlutterFlowTheme.of(context)
                          //                               .primaryText,
                          //                       fontSize: 16.0,
                          //                       fontWeight: FontWeight.w600,
                          //                     ),
                          //               )
                          //             ],
                          //             style:
                          //                 FlutterFlowTheme.of(context).labelLarge,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
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
