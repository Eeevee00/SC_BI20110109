import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_dashboard_screen_model.dart';
export 'admin_dashboard_screen_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/skeleton_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setting/setting_screen/setting_screen_widget.dart';
import '../admin_list_screen/admin_list_screen_widget.dart';
import '../user_list_screen/user_list_screen_widget.dart';
import '../reward_list_screen/reward_list_screen_widget.dart';
import '../host_verification_list/host_verification_list_widget.dart';
import '../notification_list_screen/notification_list_screen_widget.dart';
import '../reward_detail_screen/reward_detail_screen_widget.dart';
import '../admin_profile/profile_widget.dart';
import '../../../data/models/reward_model.dart';
import '../feedback_list_screen/feedback_list_screen_widget.dart';
import '../job_list/job_list_widget.dart';
import '../event_list_screen/event_list_widget.dart';
import '../admin_profile/profile_widget.dart';

import '../claim_list/claim_list_screen_widget.dart';

class AdminDashboardScreenWidget extends StatefulWidget {
  final User user;
  const AdminDashboardScreenWidget({required this.user});

  @override
  _AdminDashboardScreenWidgetState createState() =>
      _AdminDashboardScreenWidgetState();
}

class _AdminDashboardScreenWidgetState
    extends State<AdminDashboardScreenWidget> {
  late AdminDashboardScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late FirebaseMessaging messaging;
  Map editInfo = {};
  CollectionReference docRef = FirebaseFirestore.instance.collection('users');
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference eventsCollection = FirebaseFirestore.instance.collection('event');
  final CollectionReference jobsCollection = FirebaseFirestore.instance.collection('job');
  final CollectionReference rewardsCollection = FirebaseFirestore.instance.collection('rewards');

  int active_admin = 0;
  int active_host = 0;
  int active_seeker = 0;
  int no_of_event = 0;
  int no_of_job = 0;
  var _name = "Empty";
  var _email = "Empty";
  var _image = "Empty";
  var _userType = "Empty";
  var user_type;

  List<DocumentSnapshot<Object?>> rewardsList = [];

  StreamController<List<DocumentSnapshot<Object?>>> rewardsController =
      StreamController<List<DocumentSnapshot<Object?>>>();

  Stream<List<DocumentSnapshot<Object?>>> get rewardsStream => rewardsController.stream;

  StreamController<void> _userCountController = StreamController<void>.broadcast();

  Stream<void> get userCountStream => _userCountController.stream;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminDashboardScreenModel());
    saveUserDetail();
    configurePushNotification();
    messaging = FirebaseMessaging.instance;
    
    messaging.getToken().then((value){
        print(value);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    getMainMenuDetail();
    listenToRewardsChanges();
    listenToUserChanges();
  }

  void setRewardsList(List<DocumentSnapshot<Object?>> list) {
    rewardsList = list;
  }

  Future<void> getMainMenuDetail() async {
    try {
      await getUsersCount();
      await getEventsCount();
      await getJobsCount();
      await getRewards();
    } catch (e) {
      print('Error fetching main menu details: $e');
    }
  }

  Future<void> getUsersCount() async {
    try {
      usersCollection.snapshots().listen((QuerySnapshot<Object?> snapshot) {
        active_admin = 0;
        active_host = 0;
        active_seeker = 0;

        snapshot.docs.forEach((doc) {
          String userType = (doc.data() as Map<String, dynamic>)['user_type'];
          bool status = (doc.data() as Map<String, dynamic>)['status'];

          if (userType == 'admin' && status == true) {
            setState(() {
              active_admin++;
            });

          } else if (userType == 'host' && status == true) {
            setState(() {
              active_host++;
            });
            
          } else if (userType == 'seeker' && status == true) {
            setState(() {
              active_seeker++;
            });
            
          }
        });

        
        print("user data changes");
        // Notify listeners about the change in user counts
        _userCountController.add(null);
      });
    } catch (e) {
      print('Error fetching user counts: $e');
    }
  }

  Future<void> getEventsCount() async {
    try {
      eventsCollection.where('status', isEqualTo: true).snapshots().listen((QuerySnapshot<Object?> snapshot) {
        setState(() {
          no_of_event = snapshot.size;
        });
      });
    } catch (e) {
      print('Error fetching event count: $e');
    }
  }

  Future<void> getJobsCount() async {
    try {
      jobsCollection.where('status', isEqualTo: true).snapshots().listen((QuerySnapshot<Object?> snapshot) {
        setState(() {
          no_of_job = snapshot.size;
        });
      });
    } catch (e) {
      print('Error fetching job count: $e');
    }
  }

  Future<void> getRewards() async {
    try {
      QuerySnapshot<Object?> snapshot = await rewardsCollection.orderBy('timestamp', descending: true).get();

      List<DocumentSnapshot<Object?>> rewardsList = snapshot.docs;
      setRewardsList(snapshot.docs);
      rewardsController.add(rewardsList);
    } catch (e) {
      print('Error fetching rewards: $e');
    }
  }

  void listenToUserChanges() {
    int admin = 0;
    int host = 0;
    int seeker = 0;
    usersCollection.snapshots().listen(
      (QuerySnapshot<Object?> snapshot) {
        print("Snapshot received: ${snapshot.docs.length} documents");
        admin = 0;
        host = 0;
        seeker = 0;
        snapshot.docs.forEach((doc) {
          String userType = (doc.data() as Map<String, dynamic>)['user_type'];
          bool status = (doc.data() as Map<String, dynamic>)['status'];
          
          if (userType == 'admin' && status == true) {
            setState(() {
              admin++;
            });

          } else if (userType == 'host' && status == true) {
            setState(() {
              host++;
            });
            
          } else if (userType == 'seeker' && status == true) {
            setState(() {
              seeker++;
            });
            
          }
        });
        setState(() {
          _userCountController.add(null);
          active_admin = admin;
          active_host = host;
          active_seeker = seeker;
        }); 
      },
      onError: (error) => print('Error listening to rewards changes: $error'),
    );
  }

  void listenToRewardsChanges() {
    print("listener called");
    rewardsCollection.orderBy('timestamp', descending: true).snapshots().listen(
      (QuerySnapshot<Object?> snapshot) {
        print("Snapshot received: ${snapshot.docs.length} documents");
        List<DocumentSnapshot<Object?>> rewardsList = snapshot.docs;
        setRewardsList(snapshot.docs);
        setState(() {
          rewardsController.add(rewardsList);
        }); 
      },
      onError: (error) => print('Error listening to rewards changes: $error'),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    _userCountController.close();
    super.dispose();
  }

  image(pictures){
    var list = pictures;
    var stringList = list.join("");

    return stringList;
  }

  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        return userSnapshot.data();
      } else {
        return null;
      }
    } catch (e) {
      print('Error retrieving user details: $e');
      return null;
    }
  }

  configurePushNotification() async {
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((token) {
      docRef.doc(widget.user.uid).update({
        'pushToken': token,
      });
    });
  }

  saveUserDetail()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("current_user_email", widget.user.email!);
    prefs.setString("current_user_uid", widget.user.uid!);

    Map<String, dynamic>? userDetails = await getUserDetails(widget.user.uid!);
    if (userDetails != null) {
      prefs.setString("current_user_name", userDetails['name']!);
      prefs.setString("user_type", userDetails['user_type']!);
      print(userDetails['image'][0]);
      if(userDetails['image'][0] == "Empty"){
        prefs.setString("current_user_image", "https://s3.amazonaws.com/37assets/svn/765-default-avatar.png");
      }else{
        prefs.setString("current_user_image", userDetails['image'][0]);
      }
      setState(() {
        _name = userDetails['name']!;
        _email = userDetails['email']!;
        _userType = userDetails['user_type']!;
        
        if(userDetails['image'][0] == "Empty"){
          _image = "https://s3.amazonaws.com/37assets/svn/765-default-avatar.png";
        }else{
          _image = image(userDetails['image']!);
        }
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
        drawer: Drawer(
          elevation: 16.0,
          child: Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              border: Border.all(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 90.0, 0.0, 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SelectionArea(
                            child: Container(
                              width: 100.0,
                              height: 100.0,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.network(
                                _image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SelectionArea(
                            child: Text(
                              _name,
                              textAlign: TextAlign.right,
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SelectionArea(
                            child: Text(
                              _email,
                              textAlign: TextAlign.right,
                              style: FlutterFlowTheme.of(context).bodyMedium,
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
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileWidget(),
                                    ),
                                  );
                                  saveUserDetail();
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.person,
                                    size: 24.0,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  title: Text(
                                    'Profile',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  tileColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  dense: false,
                                ),
                              ),
                              _userType == "superadmin" ? 
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminListScreenWidget(),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.account_circle,
                                    size: 24.0,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  title: Text(
                                    'Admin Management',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  tileColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  dense: false,
                                ),
                              )
                              :Row(),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserListScreenWidget(),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.people,
                                    size: 24.0,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  title: Text(
                                    'User Management',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  tileColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  dense: false,
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RewardListScreenWidget(),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.star,
                                    size: 24.0,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  title: Text(
                                    'Reward Management',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  tileColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  dense: false,
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HostVerificationListWidget(),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.verified_user,
                                    size: 24.0,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  title: Text(
                                    'User Verification',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  tileColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  dense: false,
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventListScreenWidget(),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.event,
                                    size: 24.0,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  title: Text(
                                    'Event List',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  tileColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  dense: false,
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobListScreenWidget(),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.work,
                                    size: 24.0,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  title: Text(
                                    'Job List',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  tileColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  dense: false,
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ClaimListScreenWidget(),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.check,
                                    size: 24.0,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  title: Text(
                                    'Claim List',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  tileColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  dense: false,
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NotificationListScreenWidget(),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.notifications,
                                    size: 24.0,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  title: Text(
                                    'Notification',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  tileColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  dense: false,
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FeedbackListScreenWidget(),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.feedback,
                                    size: 24.0,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  title: Text(
                                    'Feedback List',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  tileColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  dense: false,
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SettingScreenWidget(),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.settings,
                                    size: 24.0,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  title: Text(
                                    'Setting',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  tileColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  dense: false,
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  editInfo.addAll({'pushToken': ""});
                                  await FirebaseMessaging.instance.deleteToken();
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => InitialScreenWidget(),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: FaIcon(
                                    FontAwesomeIcons.signOutAlt,
                                    size: 24.0,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  title: Text(
                                    'Log Out',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  tileColor: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  dense: false,
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 50.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SelectionArea(
                            child: Text(
                          'Muzik Local v1.0',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        )),
                      ),
                    ],
                  ),
                ),
              ]
            ),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Text(
            'Muzik Local',
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
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Muzik Local',
                          style: FlutterFlowTheme.of(context).headlineSmall,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 5.0, 0.0, 5.0),
                          child: Text(
                            'Welcom Back ' + _name.toString(),
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).customColor1,
                                  fontSize: 14.0,
                                ),
                          ),
                        ),
                        Divider(
                          thickness: 2.0,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Active Admin',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                            ),
                                            Text(
                                              active_admin.toString(),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .displaySmall
                                                  .override(
                                                    fontFamily: 'Outfit',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .customColor1,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      elevation: 1.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Active Host',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                        ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    active_host.toString(),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .displaySmall
                                                        .override(
                                                          fontFamily: 'Outfit',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .customColor1,
                                                          fontWeight:
                                                              FontWeight.w300,
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
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Active Seeker',
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  active_seeker.toString(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .displaySmall
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor1,
                                                        fontWeight:
                                                            FontWeight.w300,
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
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 10.0, 0.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        elevation: 1.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'No of Event',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                                ),
                                                Text(
                                                  no_of_event.toString(),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .displaySmall
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .customColor1,
                                                        fontWeight:
                                                            FontWeight.w300,
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
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          10.0, 0.0, 0.0, 0.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        elevation: 1.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Active Job',
                                                  textAlign: TextAlign.start,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily: 'Outfit',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                      ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      no_of_job.toString(),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .displaySmall
                                                              .override(
                                                                fontFamily:
                                                                    'Outfit',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .customColor1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                              ),
                                                    ),
                                                  ],
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
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 24.0, 0.0, 5.0),
                          child: Text(
                            'Reward List',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).customColor1,
                                  fontSize: 14.0,
                                ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: Builder(
                                  builder: (BuildContext builderContext) {
                                    if (rewardsList.isEmpty) {
                                      return Center(
                                        child: Text(
                                          'No rewards have been created.',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      );
                                    } else {
                                      return ListView.builder(
                                        itemCount: rewardsList.length,
                                        itemBuilder: (context, index) {
                                          final rewardData = rewardsList[index].data() as Map<String, dynamic>;
                                          final reward = Reward.fromJson(rewardData);
                                          return Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                                            child: InkWell(
                                              onTap: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => RewardDetailScreenWidget(reward: reward),
                                                  ),
                                                );
                                                getRewards();
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                                                            child: Container(
                                                              width: double.infinity,
                                                              decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                  fit: BoxFit.cover,
                                                                  image: CachedNetworkImageProvider(image(rewardData['image'])
                                                                    ,
                                                                  ),
                                                                ),
                                                                gradient: LinearGradient(
                                                                  colors: [
                                                                    FlutterFlowTheme.of(context).primary,
                                                                    FlutterFlowTheme.of(context).secondary,
                                                                  ],
                                                                  stops: [0.0, 1.0],
                                                                  begin: AlignmentDirectional(0.0, -1.0),
                                                                  end: AlignmentDirectional(0, 1.0),
                                                                ),
                                                                borderRadius: BorderRadius.circular(10.0),
                                                              ),
                                                              child: Container(
                                                                width: double.infinity,
                                                                decoration: BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                    colors: [
                                                                      Color(0x4D1A1A1A),
                                                                      Color(0xB348426D),
                                                                    ],
                                                                    stops: [0.0, 1.0],
                                                                    begin: AlignmentDirectional(0.0, -1.0),
                                                                    end: AlignmentDirectional(0, 1.0),
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                ),
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      width: 120.0,
                                                                      decoration: BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context).primaryBackground,
                                                                        borderRadius: BorderRadius.only(
                                                                          bottomLeft: Radius.circular(0.0),
                                                                          bottomRight: Radius.circular(10.0),
                                                                          topLeft: Radius.circular(10.0),
                                                                          topRight: Radius.circular(0.0),
                                                                        ),
                                                                        border: Border.all(
                                                                          color: FlutterFlowTheme.of(context).primaryBackground,
                                                                        ),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                        child: Text(
                                                                          rewardData['text_status'],
                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                            fontFamily: 'Outfit',
                                                                            color: FlutterFlowTheme.of(context).primaryText,
                                                                            fontSize: 12.0,
                                                                            fontWeight: FontWeight.normal,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 50.0, 20.0, 35.0),
                                                                      child: Container(
                                                                        width: double.infinity,
                                                                        decoration: BoxDecoration(),
                                                                        child: Column(
                                                                          mainAxisSize: MainAxisSize.max,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              rewardData['name'],
                                                                              textAlign: TextAlign.start,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                fontFamily: 'Outfit',
                                                                                color: FlutterFlowTheme.of(context).customColor1,
                                                                                fontSize: 16.0,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              rewardData['point'] + ' Point Needed',
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                fontFamily: 'Outfit',
                                                                                color: FlutterFlowTheme.of(context).customColor1,
                                                                                fontSize: 12.0,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
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

  Widget RewardList({required List<DocumentSnapshot<Object?>> rewardsList}) {
    return ListView.builder(
      itemCount: rewardsList.length,
      itemBuilder: (context, index) {
        var rewardData = rewardsList[index].data() as Map<String, dynamic>;

        return ListTile(
          title: Text(rewardData['rewardName']),
          subtitle: Text(rewardData['timestamp'].toString()),
          // Add more widgets for other reward details
        );
      },
    );
  }
}
