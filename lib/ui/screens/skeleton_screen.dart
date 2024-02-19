import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../public/initial_screen/initial_screen_model.dart';
export '../public/initial_screen/initial_screen_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../service/auth.dart';
import '../../service/validator.dart';

import '../public/login_screen/login_screen_widget.dart';
import '../public/register_screen/register_screen_widget.dart';
import '../public/forgot_password_screen/forgot_password_screen_widget.dart';
import '../admin/admin_dashboard_screen/admin_dashboard_screen_widget.dart';
import '../host/host_dashboard_screen/host_dashboard_screen_widget.dart';
import '../seeker/seeker_dashboard_screen/seeker_dashboard_screen_widget.dart';


class InitialScreenWidget extends StatefulWidget {
  const InitialScreenWidget({Key? key}) : super(key: key);

  @override
  _InitialScreenWidgetState createState() => _InitialScreenWidgetState();
}

class _InitialScreenWidgetState extends State<InitialScreenWidget> {
  late InitialScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _initializeFirebase();
    super.initState();
    _model = createModel(context, () => InitialScreenModel());
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
    return firebaseApp;
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
        body: SafeArea(
            top: true,
            child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 100, 20, 100),
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0.0, 64.0, 0.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    height: 180.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: Image.asset(
                        'assets/images/MuzikLokal_logo.png',
                        ).image,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                        topLeft: Radius.circular(0.0),
                        topRight: Radius.circular(0.0),
                      ),
                    ),
                  ),
                ),
                Text(
                  'Get Started',
                  style: FlutterFlowTheme.of(context)
                    .displaySmall
                    .override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context)
                      .customColor1,
                  ),
                ),
                Text(
                  'Discover the music around you',
                  style: FlutterFlowTheme.of(context)
                    .bodyMedium
                    .override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context)
                        .customColor1,
                      fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 150),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB( 0.0, 16.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreenWidget()));
                          },
                          text: 'Sign Up',
                          options: FFButtonOptions(
                            width: 150.0,
                            height: 50.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB( 0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context)
                              .primaryText,
                            textStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ",
                        style: TextStyle(color: Colors.white70, fontSize: 17)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreenWidget()));
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
