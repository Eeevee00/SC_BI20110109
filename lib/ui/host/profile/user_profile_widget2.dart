//View mode

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../profile_update/update_profile_user_widget.dart';
import '../edit_password/reset_password_screen_widget.dart';
// import '../../editprofile.dart';

import '../../../data/models/user_model.dart';
import '../../../data/models/shared_pref.dart';
import 'user_profile_model.dart';
export 'user_profile_model.dart';

// This is user Proifle from seeker POV
class UserProfileWidget extends StatefulWidget {
  final String uid;
  const UserProfileWidget({required this.uid});

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> with TickerProviderStateMixin {
  late UserProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  late Users currentUser;

  var uid;
  var bio;
  var email;
  var image = "Empty";  
  var address;
  var name;
  var phone;
  var point;
  var tier;
  bool verification = false;
  SharedPref sharedPref = SharedPref();
  CollectionReference docUser = FirebaseFirestore.instance.collection('users'); //Helper
  //final EditProfileState _editProfileState = EditProfileState();

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _model = createModel(context, () => UserProfileModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 1,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
  }

    _getCurrentUser() async {
    sharedPref.save("user", currentUser);
  }

  _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        email = user.email;
        uid = user.uid;
      });
    }
    
    return docUser.doc(widget.uid).snapshots().listen((data) async {
      currentUser = Users.fromDocument(data);
      var list = data['image'];
      var stringList = list.join("");
      setState(() {
        currentUser = Users.fromDocument(data);
        email = currentUser.email;
        uid = currentUser.uid;
        image = stringList;
        name = currentUser.name;
        phone = currentUser.phone;
        point = currentUser.points ?? 0;
        tier = currentUser.tier ?? "Bronze";
        bio = currentUser.bio ?? "";
        //hashtag = currentUser.hashtag ?? [];
        address = currentUser.location!['address'];
        verification = currentUser.verification!;
      });
    });
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
          iconTheme: IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'User Detail',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),

        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                       //Profile Picture
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                              child: Stack(
                                children: [
                                  Hero(
                                    tag: "User Profile",
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 80,
                                        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                                        child: Material(
                                          color: FlutterFlowTheme.of(context).secondaryBackground,
                                          child: Stack(
                                            children: <Widget>[
                                              image == "Empty" ? 
                                              // Network avatar as profile
                                              InkWell(
                                                onTap: () {},
                                                child: Center(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(80,),
                                                    child: Container(
                                                      width: 150,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 4,
                                                              color: Theme.of(context).scaffoldBackgroundColor),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                spreadRadius: 2,
                                                                blurRadius: 10,
                                                                color: Colors.black.withOpacity(0.1),
                                                                offset: Offset(0, 10))
                                                          ],
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                "https://s3.amazonaws.com/37assets/svn/765-default-avatar.png",
                                                              ),
                                                            ),
                                                        ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              :
                                              // Chosen image as profile
                                              InkWell(
                                                onTap: () {},
                                                child: Center(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(80,),
                                                    child: Container(
                                                      width: 150,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 4,
                                                              color: Theme.of(context).scaffoldBackgroundColor),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                spreadRadius: 2,
                                                                blurRadius: 10,
                                                                color: Colors.black.withOpacity(0.1),
                                                                offset: Offset(0, 10))
                                                          ],
                                                          shape: BoxShape.circle,
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                image
                                                              ),
                                                            ),
                                                        ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        //Name
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  name ??'', // Add a null check here
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).customColor1,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ),
                              verification == true ?
                              Icon(
                                Icons.verified_sharp,
                                color: FlutterFlowTheme.of(context).success,
                                size: 24.0,
                              )
                              :
                              Row(),
                            ],
                          ),
                        ),

                        //Address
                        Padding(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            address.toString(),
                            textAlign: TextAlign.center,
                            maxLines: null, // Set to null or a large number
                            overflow: TextOverflow.visible,
                            style: FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).customColor1,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),

                      //Point + Tier
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 1.0,
                                  height: 45.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primaryBackground,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12.0),
                                      bottomRight: Radius.circular(12.0),
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                          padding: EdgeInsets.all(0.0),
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Point Balance: ',
                                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: 'Outfit',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: point.toString(),
                                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: 'Outfit',
                                                    color: FlutterFlowTheme.of(context).customColor1,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ),
                                          Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Tier: ',
                                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: 'Outfit',
                                                    color: FlutterFlowTheme.of(context).primaryText,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: tier.toString(),
                                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: 'Outfit',
                                                    color: FlutterFlowTheme.of(context).customColor1,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        //Detail
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                          child: Container(
                            height: 427.0,
                            //height: MediaQuery.of(context).size.height, // Adjust the height as needed

                            decoration: BoxDecoration(),
                            child: Column(
                              children: [

                                // Tabs : Detail 
                                Align(
                                  alignment: Alignment(0.0, 0),
                                  child: TabBar(
                                    labelColor: FlutterFlowTheme.of(context).primaryText,
                                    unselectedLabelColor:FlutterFlowTheme.of(context).customColor1,
                                    labelStyle: FlutterFlowTheme.of(context).titleMedium,
                                    unselectedLabelStyle: TextStyle(),
                                    indicatorColor: FlutterFlowTheme.of(context).accent3,
                                    padding: EdgeInsets.all(4.0),
                                    tabs: [
                                      Tab(text: 'Detail',
                                      ),
                                      // Tab(text: 'Management',
                                      // ),
                                    ],
                                    controller: _model.tabBarController,
                                  ),
                                ),

                                Expanded(
                                  child: TabBarView(
                                    controller: _model.tabBarController,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          //Title : Bio
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Text('Bio',
                                                    style: FlutterFlowTheme.of(context).titleSmall.override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme.of(context).primaryText,
                                                          fontSize: 18.0,
                                                          fontWeight:FontWeight.normal,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          //Bio Description
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Text(
                                                    bio.toString(),
                                                    style: FlutterFlowTheme.of(context).titleSmall.override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme.of(context).customColor1,
                                                          fontSize: 16.0,
                                                          fontWeight:FontWeight.normal,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          //Connect with me via
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:EdgeInsets.all(4.0),
                                                    child: Text('Connect with me via',
                                                      style:FlutterFlowTheme.of(context).titleSmall.override(
                                                        fontFamily:'Outfit',
                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Phone
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                                child: Row(
                                                  mainAxisSize:MainAxisSize.max,
                                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 20.0, 10.0),
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:MainAxisSize.max,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 8.0, 0.0),
                                                                child: Icon(
                                                                  Icons.phone,
                                                                  color: FlutterFlowTheme.of(context).primaryText,
                                                                  size: 24.0,
                                                                ),
                                                              ),
                                                              Text(
                                                                phone.toString(),
                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                  fontFamily: 'Outfit',
                                                                  color: FlutterFlowTheme.of(context).customColor1,
                                                                  fontSize: 16.0,
                                                                  fontWeight:FontWeight.normal,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Email

                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:EdgeInsetsDirectional.fromSTEB(4.0,0.0,8.0,0.0),
                                                        child: Icon(
                                                          Icons.email,
                                                          color: FlutterFlowTheme.of(context).primaryText,
                                                          size: 24.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        email.toString(),
                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme.of(context).customColor1,
                                                          fontSize: 16.0,
                                                          fontWeight:FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
}
