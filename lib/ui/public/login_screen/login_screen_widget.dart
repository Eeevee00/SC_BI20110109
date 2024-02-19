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

import '../../admin/admin_dashboard_screen/admin_dashboard_screen_widget.dart';
import '../../host/host_dashboard_screen/host_dashboard_screen_widget.dart';
import '../../seeker/seeker_dashboard_screen/seeker_dashboard_screen_widget.dart';
import '../forgot_password_screen/forgot_password_screen_widget.dart';
import '../register_screen/register_screen_widget.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({Key? key}) : super(key: key);

  @override
  _LoginScreenWidgetState createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  late LoginScreenModel _model;

// To validate, reset, or interact with a form widget 
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// This key helps Flutter uniquely identify and manage the state of a Scaffold widget.:
// It allows things like showing snackbars or opening drawers programmatically.
  final scaffoldKey = GlobalKey<ScaffoldState>();

// This variable is like a switch, telling whether a certain process is happening or not.:
// true = particular process (like submitting a form) is currently in progress. 
// false= the process is not happening.
  bool _isProcessing = false;

  @override
  void initState() {
    _initializeFirebase(); // setting up Firebase-related functionality early in the widget's lifecycle
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

//Initializes Firebase using Firebase.initializeApp() and retrieves the FirebaseApp instance.
//It checks if a user is signed in using Firebase Authentication.
  Future<FirebaseApp> _initializeFirebase() async {
    var documentData;
    var userExist = false;
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;

    //It checks if a user is signed in using Firebase Authentication.
    //If the user is found, it sets the userExist variable to true and 
    //captures the data of the first matching document in the documentData variable.
    if (user != null) {
        await FirebaseFirestore.instance.collection('users')
        .where('email', isEqualTo: user.email).get().then((value) {
              value.docs.forEach((element) async {
                setState(() {
                  userExist = true;
                  documentData = element;
                });
              });
        });

        //Based on the user's existence and 'user_type', 
        //it navigates to the appropriate dashboard screen.
        //Uses the Navigator to navigate to different screens based on user type
        if(userExist == true){
          if(documentData['user_type'] == "superadmin"){
            if (user != null) {
              Navigator.of(context)
                .pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                      AdminDashboardScreenWidget(user: user),
                  ),
                );
            }
          }
          
          else if(documentData['user_type'] == "admin"){
            if (user != null) {
              Navigator.of(context)
                .pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
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
                  ),
                );
            }
          }
        }
    }
    return firebaseApp; //Finally, it returns the FirebaseApp instance.

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
        
        //TopBar with back button
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          iconTheme:IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          // title: Text(
          //   'Log In',
          //   style: FlutterFlowTheme.of(context).bodyMedium.override(
          //         fontFamily: 'Outfit',
          //         color: FlutterFlowTheme.of(context).primaryText,
          //         fontSize: 20.0,
          //         fontWeight: FontWeight.w500,
          //       ),
          // ),
          
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),

        //Body
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                Container(
                  height: 180.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: Image.asset(
                        'assets/images/MuzikLokal_logo.png',
                      ).image,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Log In',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context)
                          .displaySmall
                          .override(
                            fontFamily: 'Outfit',
                            color: FlutterFlowTheme.of(context)
                                .customColor1,
                          ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome Back',
                      style: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(
                            fontFamily: 'Outfit',
                            color: FlutterFlowTheme.of(context)
                                .customColor1,
                                fontSize: 20.0,
                          ),
                    ),
                  ],
                ),

                //Wrap in Form Widget
                Form(
                  key: _formKey,
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 0.0), // The values (0.0, 0.0) represent the center point of the parent widget.
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email textfield
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 26.0, 0.0, 16.0),
                            child: TextFormField(
                              controller: _model.textController1,
                              focusNode: _model.textFieldFocusNode1,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                                labelStyle: TextStyle( // Add this block for label text style
                                  color: FlutterFlowTheme.of(context).primaryText, fontSize: 16.0, // Set the color 
                                ),
                                prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: FlutterFlowTheme.of(context).primaryText,
                                        size: 20,
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
                              // validator: _model.textController1Validator
                              //     .asValidator(context),
                              validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an email address';
                                  }
                                  // Use a regex pattern for email validation
                                  String emailRegex =
                                      //r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                                      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
                                  RegExp regex = RegExp(emailRegex);
                                  if (!regex.hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null; // Return null if validation succeeds
                                },

                            ),
                          ),
                          // Password textfield
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 6.0),
                            child: TextFormField(
                              controller: _model.textController2,
                              focusNode: _model.textFieldFocusNode2,
                              obscureText: !_model.passwordVisibility,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                hintStyle: FlutterFlowTheme.of(context).bodyMedium,
                                labelStyle: TextStyle( // Add this block for label text style
                                  color: FlutterFlowTheme.of(context).primaryText, fontSize :16.0, // Set the color
                                ),
                                 prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: FlutterFlowTheme.of(context).primaryText,
                                        size: 20,
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

                                // Suffix button to show password visibility
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
                              // validator: _model.textController2Validator
                              //     .asValidator(context),
                              validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null; // Return null if validation succeeds
                            },
                            ),
                          ),

                          //Text of "Forgot Password", upon press will navigate to FPW Page
                          Align(alignment: AlignmentDirectional(1, 0),
                            child:FFButtonWidget(
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
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    elevation: 0.0,
                                  ),
                                ),
                          ),

                          // If _isProcessing = true , display CircularProgressIndicator
                          _isProcessing ? 
                          CircularProgressIndicator()
                          : 
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [FFButtonWidget(
                                    //Login Button
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
                                                case "superadmin":
                                                  Navigator.of(context).pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) => AdminDashboardScreenWidget(user: user),
                                                    ),
                                                  );                                            
                                                  break;
                                                case "admin":
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
                                              // If key in credential is wrong , pop alert box
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

                                    text: 'Log In',
                                    options: FFButtonOptions(
                                      width: 325.0,
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
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                      elevation: 3.0,
                                      borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ],
                      ),
                    ),
                  ),
                ), // Form


                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      0.0, 20.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    const Text("Don't have an account? ",
                        style: TextStyle(color: Colors.white70, fontSize: 17)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreenWidget()));
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                  ),
                ),

              ],// children: [
            ),// child: Column
          ), // SingleChildScrollView
        ),//Safe Area
      ),
    );
  }
}
