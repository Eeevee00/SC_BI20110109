import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'user_profile_model.dart';
export 'user_profile_model.dart';
import '../edit_password/reset_password_screen_widget.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../data/models/user_model.dart';
import '../../../data/models/shared_pref.dart';
import '../../editprofile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../profile_update/update_profile_user_widget.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({Key? key}) : super(key: key);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget>
    with TickerProviderStateMixin {
  late UserProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  late Users currentUser;
  CollectionReference docUser = FirebaseFirestore.instance.collection('users'); //Helper
  final EditProfileState _editProfileState = EditProfileState();
  var uid;
  var email;
  var id;
  var image = "Empty";
  var name;
  var phone;
  var address;
  var point;
  var tier;
  var bio;
  var hashtag;

  bool verification = false;

  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _model = createModel(context, () => UserProfileModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
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
    
    return docUser.doc(uid).snapshots().listen((data) async {
      currentUser = Users.fromDocument(data);
      var list = data['image'];
      var stringList = list.join("");
      setState(() {
        currentUser = Users.fromDocument(data);
        email = currentUser.email;
        id = currentUser.uid;
        image = stringList;
        name = currentUser.name;
        phone = currentUser.phone;
        point = currentUser.points ?? 0;
        tier = currentUser.tier ?? "Bronze";
        bio = currentUser.bio ?? "";
        hashtag = currentUser.hashtag ?? [];
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
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  PopupMenuItem<String>(
                    value: 'changePassword',
                    child: Text('Change Password'),
                  ),
                ],
                onSelected: (String choice) async {
                  if (choice == 'edit') {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfileUserWidget(uid: uid),
                      ),
                    );
                    _initializeFirebase();
                  } else if (choice == 'changePassword') {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPasswordScreenWidget(),
                      ),
                    );
                  }
                },
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
                                InkWell(
                                  onTap: () {},
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        80,
                                      ),
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
                                InkWell(
                                  onTap: () {},
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        80,
                                      ),
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
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30)),
                                    color: Theme.of(context).primaryColor,
                                    child: IconButton(
                                        alignment: Alignment.center,
                                        icon: Icon(
                                          Icons.photo_camera,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          var a = await _editProfileState.source(
                                              context, currentUser, true);
                                              
                                        }),
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
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  name,
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context)
                                            .customColor1,
                                        fontSize: 16.0,
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
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 1.0,
                                  height: 45.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              point.toString() + ' Point Balance',
                                              textAlign: TextAlign.center,
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
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                              'Tier ' + tier.toString(),
                                              textAlign: TextAlign.center,
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Container(
                            height: 427.0,
                            decoration: BoxDecoration(),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment(0.0, 0),
                                  child: TabBar(
                                    labelColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    unselectedLabelColor:
                                        FlutterFlowTheme.of(context)
                                            .customColor1,
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .titleMedium,
                                    unselectedLabelStyle: TextStyle(),
                                    indicatorColor:
                                        FlutterFlowTheme.of(context).accent3,
                                    padding: EdgeInsets.all(4.0),
                                    tabs: [
                                      Tab(
                                        text: 'Detail',
                                      ),
                                      // Tab(
                                      //   text: 'Management',
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
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Text(
                                                    'Bio',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.normal,
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
                                                    bio.toString(),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmall
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .customColor1,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Padding(
                                          //   padding:
                                          //       EdgeInsetsDirectional.fromSTEB(
                                          //           0.0, 16.0, 0.0, 0.0),
                                          //   child: Row(
                                          //     mainAxisSize: MainAxisSize.max,
                                          //     children: [
                                          //       Expanded(
                                          //         child: Padding(
                                          //           padding:
                                          //               EdgeInsets.all(4.0),
                                          //           child: Text(
                                          //             'Interest',
                                          //             style:
                                          //                 FlutterFlowTheme.of(
                                          //                         context)
                                          //                     .titleSmall
                                          //                     .override(
                                          //                       fontFamily:
                                          //                           'Outfit',
                                          //                       color: FlutterFlowTheme.of(
                                          //                               context)
                                          //                           .primaryText,
                                          //                       fontSize: 18.0,
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .normal,
                                          //                     ),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          // Row(
                                          //   mainAxisSize: MainAxisSize.max,
                                          //   children: [
                                          //     Padding(
                                          //       padding: EdgeInsetsDirectional
                                          //           .fromSTEB(
                                          //               0.0, 0.0, 8.0, 0.0),
                                          //       child: Container(
                                          //         decoration: BoxDecoration(
                                          //           color: FlutterFlowTheme.of(
                                          //                   context)
                                          //               .primaryText,
                                          //           borderRadius:
                                          //               BorderRadius.only(
                                          //             bottomLeft:
                                          //                 Radius.circular(12.0),
                                          //             bottomRight:
                                          //                 Radius.circular(12.0),
                                          //             topLeft:
                                          //                 Radius.circular(12.0),
                                          //             topRight:
                                          //                 Radius.circular(12.0),
                                          //           ),
                                          //         ),
                                          //         child: Padding(
                                          //           padding:
                                          //               EdgeInsetsDirectional
                                          //                   .fromSTEB(8.0, 2.0,
                                          //                       8.0, 2.0),
                                          //           child: Row(
                                          //             mainAxisSize:
                                          //                 MainAxisSize.max,
                                          //             children: [
                                          //               Text(
                                          //                 '#Guitar',
                                          //                 style: FlutterFlowTheme
                                          //                         .of(context)
                                          //                     .bodyMedium
                                          //                     .override(
                                          //                       fontFamily:
                                          //                           'Outfit',
                                          //                       color: FlutterFlowTheme.of(
                                          //                               context)
                                          //                           .secondaryBackground,
                                          //                     ),
                                          //               ),
                                          //               Icon(
                                          //                 Icons.cancel_outlined,
                                          //                 color: FlutterFlowTheme
                                          //                         .of(context)
                                          //                     .error,
                                          //                 size: 24.0,
                                          //               ),
                                          //             ],
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     Padding(
                                          //       padding: EdgeInsetsDirectional
                                          //           .fromSTEB(
                                          //               0.0, 0.0, 8.0, 0.0),
                                          //       child: Container(
                                          //         decoration: BoxDecoration(
                                          //           color: FlutterFlowTheme.of(
                                          //                   context)
                                          //               .primaryText,
                                          //           borderRadius:
                                          //               BorderRadius.only(
                                          //             bottomLeft:
                                          //                 Radius.circular(12.0),
                                          //             bottomRight:
                                          //                 Radius.circular(12.0),
                                          //             topLeft:
                                          //                 Radius.circular(12.0),
                                          //             topRight:
                                          //                 Radius.circular(12.0),
                                          //           ),
                                          //         ),
                                          //         child: Padding(
                                          //           padding:
                                          //               EdgeInsetsDirectional
                                          //                   .fromSTEB(8.0, 2.0,
                                          //                       8.0, 2.0),
                                          //           child: Row(
                                          //             mainAxisSize:
                                          //                 MainAxisSize.max,
                                          //             children: [
                                          //               Text(
                                          //                 '#Jazz',
                                          //                 style: FlutterFlowTheme
                                          //                         .of(context)
                                          //                     .bodyMedium
                                          //                     .override(
                                          //                       fontFamily:
                                          //                           'Outfit',
                                          //                       color: FlutterFlowTheme.of(
                                          //                               context)
                                          //                           .secondaryBackground,
                                          //                     ),
                                          //               ),
                                          //               Icon(
                                          //                 Icons.cancel_outlined,
                                          //                 color: FlutterFlowTheme
                                          //                         .of(context)
                                          //                     .error,
                                          //                 size: 24.0,
                                          //               ),
                                          //             ],
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 16.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(4.0),
                                                    child: Text(
                                                      'Connect with me Via',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                fontFamily:
                                                                    'Outfit',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 18.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 8.0, 0.0, 10.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  20.0,
                                                                  0.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            4.0,
                                                                            0.0,
                                                                            8.0,
                                                                            0.0),
                                                                child: Icon(
                                                                  Icons.phone,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .customColor1,
                                                                  size: 24.0,
                                                                ),
                                                              ),
                                                              Text(
                                                                phone.toString(),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium,
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
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    4.0,
                                                                    0.0,
                                                                    8.0,
                                                                    0.0),
                                                        child: Icon(
                                                          Icons.email,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .customColor1,
                                                          size: 24.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        email.toString(),
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // SingleChildScrollView(
                                      //   child: Column(
                                      //     mainAxisSize: MainAxisSize.max,
                                      //     children: [
                                      //       Padding(
                                      //         padding: EdgeInsetsDirectional
                                      //             .fromSTEB(
                                      //                 0.0, 0.0, 0.0, 16.0),
                                      //         child: Container(
                                      //           width: double.infinity,
                                      //           height: 230.0,
                                      //           decoration: BoxDecoration(
                                      //             color: FlutterFlowTheme.of(
                                      //                     context)
                                      //                 .primaryBackground,
                                      //             image: DecorationImage(
                                      //               fit: BoxFit.cover,
                                      //               image: Image.network(
                                      //                 '',
                                      //               ).image,
                                      //             ),
                                      //             borderRadius:
                                      //                 BorderRadius.circular(
                                      //                     12.0),
                                      //           ),
                                      //           child: Stack(
                                      //             children: [
                                      //               ClipRect(
                                      //                 child: ImageFiltered(
                                      //                   imageFilter:
                                      //                       ImageFilter.blur(
                                      //                     sigmaX: 2.0,
                                      //                     sigmaY: 2.0,
                                      //                   ),
                                      //                   child: Container(
                                      //                     width:
                                      //                         double.infinity,
                                      //                     height:
                                      //                         double.infinity,
                                      //                     decoration:
                                      //                         BoxDecoration(
                                      //                       color: FlutterFlowTheme
                                      //                               .of(context)
                                      //                           .secondaryBackground,
                                      //                       image:
                                      //                           DecorationImage(
                                      //                         fit: BoxFit.cover,
                                      //                         image:
                                      //                             CachedNetworkImageProvider(
                                      //                           'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw2fHxldmVudHxlbnwwfHx8fDE3MDI2OTMwMzR8MA&ixlib=rb-4.0.3&q=80&w=1080',
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //               Container(
                                      //                 decoration:
                                      //                     BoxDecoration(),
                                      //                 child: Padding(
                                      //                   padding: EdgeInsets.all(
                                      //                       16.0),
                                      //                   child: Column(
                                      //                     mainAxisSize:
                                      //                         MainAxisSize.max,
                                      //                     crossAxisAlignment:
                                      //                         CrossAxisAlignment
                                      //                             .start,
                                      //                     children: [
                                      //                       Padding(
                                      //                         padding:
                                      //                             EdgeInsetsDirectional
                                      //                                 .fromSTEB(
                                      //                                     0.0,
                                      //                                     0.0,
                                      //                                     12.0,
                                      //                                     0.0),
                                      //                         child: Row(
                                      //                           mainAxisSize:
                                      //                               MainAxisSize
                                      //                                   .max,
                                      //                           children: [
                                      //                             Icon(
                                      //                               Icons
                                      //                                   .event_rounded,
                                      //                               color: FlutterFlowTheme.of(
                                      //                                       context)
                                      //                                   .customColor1,
                                      //                               size: 24.0,
                                      //                             ),
                                      //                             Padding(
                                      //                               padding: EdgeInsetsDirectional
                                      //                                   .fromSTEB(
                                      //                                       8.0,
                                      //                                       0.0,
                                      //                                       0.0,
                                      //                                       0.0),
                                      //                               child: Text(
                                      //                                 'Event Name',
                                      //                                 style: FlutterFlowTheme.of(
                                      //                                         context)
                                      //                                     .bodyLarge
                                      //                                     .override(
                                      //                                       fontFamily:
                                      //                                           'Outfit',
                                      //                                       color:
                                      //                                           FlutterFlowTheme.of(context).customColor1,
                                      //                                     ),
                                      //                               ),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                       ),
                                      //                       Expanded(
                                      //                         child: Padding(
                                      //                           padding:
                                      //                               EdgeInsetsDirectional
                                      //                                   .fromSTEB(
                                      //                                       0.0,
                                      //                                       8.0,
                                      //                                       0.0,
                                      //                                       0.0),
                                      //                           child: Text(
                                      //                             'Event Description Event Description Event Description Event Description Event Description Event Description Event Description ',
                                      //                             textAlign:
                                      //                                 TextAlign
                                      //                                     .start,
                                      //                             maxLines: 2,
                                      //                             style: FlutterFlowTheme.of(
                                      //                                     context)
                                      //                                 .labelMedium
                                      //                                 .override(
                                      //                                   fontFamily:
                                      //                                       'Outfit',
                                      //                                   color: FlutterFlowTheme.of(context)
                                      //                                       .customColor1,
                                      //                                 ),
                                      //                           ),
                                      //                         ),
                                      //                       ),
                                      //                       Padding(
                                      //                         padding:
                                      //                             EdgeInsetsDirectional
                                      //                                 .fromSTEB(
                                      //                                     0.0,
                                      //                                     16.0,
                                      //                                     0.0,
                                      //                                     0.0),
                                      //                         child: Row(
                                      //                           mainAxisSize:
                                      //                               MainAxisSize
                                      //                                   .max,
                                      //                           mainAxisAlignment:
                                      //                               MainAxisAlignment
                                      //                                   .spaceBetween,
                                      //                           children: [
                                      //                             Text(
                                      //                               'Date & Time',
                                      //                               style: FlutterFlowTheme.of(
                                      //                                       context)
                                      //                                   .labelSmall
                                      //                                   .override(
                                      //                                     fontFamily:
                                      //                                         'Outfit',
                                      //                                     color:
                                      //                                         FlutterFlowTheme.of(context).customColor1,
                                      //                                   ),
                                      //                             ),
                                      //                             Padding(
                                      //                               padding: EdgeInsetsDirectional
                                      //                                   .fromSTEB(
                                      //                                       16.0,
                                      //                                       4.0,
                                      //                                       4.0,
                                      //                                       0.0),
                                      //                               child: Text(
                                      //                                 'Friday, May 27, 2023',
                                      //                                 style: FlutterFlowTheme.of(
                                      //                                         context)
                                      //                                     .bodySmall
                                      //                                     .override(
                                      //                                       fontFamily:
                                      //                                           'Outfit',
                                      //                                       color:
                                      //                                           FlutterFlowTheme.of(context).customColor1,
                                      //                                     ),
                                      //                               ),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                       ),
                                      //                       Padding(
                                      //                         padding:
                                      //                             EdgeInsetsDirectional
                                      //                                 .fromSTEB(
                                      //                                     0.0,
                                      //                                     16.0,
                                      //                                     0.0,
                                      //                                     0.0),
                                      //                         child: Row(
                                      //                           mainAxisSize:
                                      //                               MainAxisSize
                                      //                                   .max,
                                      //                           mainAxisAlignment:
                                      //                               MainAxisAlignment
                                      //                                   .spaceBetween,
                                      //                           children: [
                                      //                             Text(
                                      //                               'Location',
                                      //                               style: FlutterFlowTheme.of(
                                      //                                       context)
                                      //                                   .labelSmall
                                      //                                   .override(
                                      //                                     fontFamily:
                                      //                                         'Outfit',
                                      //                                     color:
                                      //                                         FlutterFlowTheme.of(context).customColor1,
                                      //                                   ),
                                      //                             ),
                                      //                             Padding(
                                      //                               padding: EdgeInsetsDirectional
                                      //                                   .fromSTEB(
                                      //                                       16.0,
                                      //                                       4.0,
                                      //                                       4.0,
                                      //                                       0.0),
                                      //                               child: Text(
                                      //                                 '123 Main St, City',
                                      //                                 style: FlutterFlowTheme.of(
                                      //                                         context)
                                      //                                     .bodySmall
                                      //                                     .override(
                                      //                                       fontFamily:
                                      //                                           'Outfit',
                                      //                                       color:
                                      //                                           FlutterFlowTheme.of(context).customColor1,
                                      //                                     ),
                                      //                               ),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                       ),
                                      //                       Row(
                                      //                         mainAxisSize:
                                      //                             MainAxisSize
                                      //                                 .max,
                                      //                         mainAxisAlignment:
                                      //                             MainAxisAlignment
                                      //                                 .spaceBetween,
                                      //                         children: [
                                      //                           Padding(
                                      //                             padding: EdgeInsetsDirectional
                                      //                                 .fromSTEB(
                                      //                                     0.0,
                                      //                                     16.0,
                                      //                                     0.0,
                                      //                                     0.0),
                                      //                             child:
                                      //                                 FFButtonWidget(
                                      //                               onPressed:
                                      //                                   () {
                                      //                                 print(
                                      //                                     'Button pressed ...');
                                      //                               },
                                      //                               text:
                                      //                                   'Detail',
                                      //                               options:
                                      //                                   FFButtonOptions(
                                      //                                 width:
                                      //                                     150.0,
                                      //                                 height:
                                      //                                     44.0,
                                      //                                 padding: EdgeInsetsDirectional.fromSTEB(
                                      //                                     0.0,
                                      //                                     0.0,
                                      //                                     0.0,
                                      //                                     0.0),
                                      //                                 iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      //                                     0.0,
                                      //                                     0.0,
                                      //                                     0.0,
                                      //                                     0.0),
                                      //                                 color: FlutterFlowTheme.of(
                                      //                                         context)
                                      //                                     .primaryText,
                                      //                                 textStyle: FlutterFlowTheme.of(
                                      //                                         context)
                                      //                                     .titleSmall
                                      //                                     .override(
                                      //                                       fontFamily:
                                      //                                           'Outfit',
                                      //                                       color:
                                      //                                           FlutterFlowTheme.of(context).secondaryBackground,
                                      //                                     ),
                                      //                                 elevation:
                                      //                                     3.0,
                                      //                                 borderRadius:
                                      //                                     BorderRadius.circular(
                                      //                                         12.0),
                                      //                               ),
                                      //                             ),
                                      //                           ),
                                      //                         ],
                                      //                       ),
                                      //                     ],
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
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
