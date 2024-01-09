import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'skeleton_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../admin/admin_dashboard_screen/admin_dashboard_screen_widget.dart';
import '../host/host_dashboard_screen/host_dashboard_screen_widget.dart';
import '../seeker/seeker_dashboard_screen/seeker_dashboard_screen_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var querySnapshot =
          await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: user.email).get();
      if (querySnapshot.docs.isNotEmpty) {
        var documentData = querySnapshot.docs.first.data();
        String userType = documentData['user_type'];

        switch (userType) {
          case 'admin':
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => AdminDashboardScreenWidget(user: user),
              ),
            );
            break;
          case 'superadmin':
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => AdminDashboardScreenWidget(user: user),
              ),
            );
            break;
          case 'host':
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HostDashboardScreenWidget(user: user),
              ),
            );
            break;
          case 'seeker':
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SeekerDashboardScreenWidget(user: user),
              ),
            );
            break;
          default:
            // Handle unknown user type or navigate to a default screen
            break;
        }
      }
    } else {
      // User is not logged in, navigate to the initial screen
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (context) => const InitialScreenWidget(),
    //     ),
    //   );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 64.0, 0.0, 0.0),
                child: Container(
                    width: double.infinity,
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
            ),
            const SizedBox(height: 20),
            Text(
              'Finding your music community',
              style: FlutterFlowTheme.of(context)
                .bodyMedium
                .override(
                    fontFamily: 'Outfit',
                    color: FlutterFlowTheme.of(context)
                        .customColor1,
                    fontSize: 18.0,
                ),
            ),
          ],
        ),
      ),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      splashIconSize: 300,
      duration: 1500, // 3 seconds
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      nextScreen: FutureBuilder<void>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const InitialScreenWidget();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
