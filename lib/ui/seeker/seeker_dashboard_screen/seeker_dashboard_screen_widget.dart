import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../public/login_screen/login_screen_widget.dart';
import '../../screens/skeleton_screen.dart';
import '../../../data/models/event_model.dart';
import '../../host/event_list/event_list_widget.dart';
import '../event_detail/event_detail_host_widget.dart';

import '../../host/profile/user_profile_widget.dart';
import '../job_list/job_list_widget.dart';
import '../my_job/my_job_list_widget.dart';
import '../event_list/event_list_widget.dart';
import '../my_event/my_event_list_widget.dart';
import '../../host/host_verification/verification.dart';
import '../../host/reward_list/reward_list_screen_widget.dart';
import '../../host/notification_list/notification_list_screen_widget.dart';
import '../../setting/setting_screen/setting_screen_widget.dart';
import 'seeker_dashboard_screen_model.dart';
export 'seeker_dashboard_screen_model.dart';

class SeekerDashboardScreenWidget extends StatefulWidget {
  final User user; // User
  const SeekerDashboardScreenWidget({required this.user});

  @override
  _SeekerDashboardScreenWidgetState createState() =>
      _SeekerDashboardScreenWidgetState();
}

class _SeekerDashboardScreenWidgetState extends State<SeekerDashboardScreenWidget> {
  late SeekerDashboardScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  //Backend : Listing all variable 

  Map editInfo = {}; // Map to store user information for editing
  late FirebaseMessaging messaging; // Initialize FirebaseMessaging for push notifications

  // Collection references for different Firestore collections
  CollectionReference docRef = FirebaseFirestore.instance.collection('users');
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference eventsCollection = FirebaseFirestore.instance.collection('event');
  final CollectionReference jobsCollection = FirebaseFirestore.instance.collection('job');

  // Counters for different statistics
  int my_event = 0;
  int my_job = 0;
  int job_applicant = 0;

  // User information variables
  var _name = "Empty";
  var _email = "Empty";
  var _image = "Empty";
  var uid = "";
  
  // User location variables
  var user_latitude = 0.0;
  var user_longitude = 0.0;

  // Host tier and point variables
  var host_tier;
  var host_point;

  // List to store DocumentSnapshots for events
  List<DocumentSnapshot<Object?>> eventList = [];

  // StreamController to handle the stream of events
  StreamController<List<DocumentSnapshot<Object?>>> eventController =
      StreamController<List<DocumentSnapshot<Object?>>>();

  // Stream to provide a continuous flow of event data
  Stream<List<DocumentSnapshot<Object?>>> get eventStream => eventController.stream;

  @override
  void initState() {
    super.initState();

      // Create the model for the SeekerDashboardScreen
    _model = createModel(context, () => SeekerDashboardScreenModel());

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value){
        print(value); //  // Get the device token for push notifications and print it
    });

    // Force a re-render after the initial frame to ensure accurate widget state
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    
    saveUserDetail();
    configurePushNotification(); // Configure and set up push notifications
    getMainMenuDetail();         // Fetch details for the main menu
    //listenToEventChanges();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  //Function : Fetch details for the main menu
  Future<void> getMainMenuDetail() async {
    try {
      await getEventsCount();
      await getJobsCount();
    } catch (e) {
      print('Error fetching main menu details: $e');
    }
  }

  //Function : Fetches and LIST events that the user has joined based on the user's UID.
  Future<void> getEvent() async {
    eventList.clear();

    try {
      String userUid = widget.user.uid;

      //Queries the `eventsCollection` 
      //for events where the participant array contains the user's UID.
      QuerySnapshot<Object?> snapshot = await eventsCollection
          .where('participant', arrayContains: {'uid': userUid})
          .orderBy('timestamp', descending: true)
          .get();

      //Sets the event list, adds it to the stream controller, and updates the UI.
      List<DocumentSnapshot<Object?>> joinedEvents = snapshot.docs;
      setEventList(joinedEvents);
      eventController.add(joinedEvents);
    } catch (e) {
      print('Error fetching joined events: $e');
    }
  }

  // Fucntion : Fetches and COUNTS the total number of events that the user has joined.
    // - **Steps:**
    // 1. Initializes an empty list `joinedEvents`.
    // 2. Queries the main 'event' collection for events with `status` equal to true.
    // 3. Iterates through the events and checks if the user is a participant in each event.
    // 4. Updates the state with the count of joined events and prints the count.
  Future<void> getEventsCount() async {
    try {
      List<DocumentSnapshot<Object?>> joinedEvents = [];

      QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
          .collection('event') // Adjust the main collection name if needed
          .where('status', isEqualTo: true)
          .get();

      for (QueryDocumentSnapshot<Object?> eventDoc in snapshot.docs) {
        QuerySnapshot<Object?> participantsSnapshot =
            await eventDoc.reference.collection('participant')
                .where('uid', isEqualTo: widget.user.uid)
                .get();

        if (participantsSnapshot.size > 0) {
          joinedEvents.add(eventDoc);
          print(joinedEvents);
        }
      }

      setState(() {
        setEventList(joinedEvents);
        eventController.add(joinedEvents);
        my_event = joinedEvents.length;
        print("My event (Joined)): " + my_event.toString());
      });
    } catch (e) {
      print('Error fetching event count: $e');
    }
  }

  // Fucntion : Fetches and counts the total number of events ( without maintaining a list of joined events.)
    // - **Steps:**
    // 1. Queries the main 'event' collection for events with `status` equal to true.
    // 2. Iterates through the events and checks if the user is a participant in each event.
    // 3. Updates the state with the count of joined events and prints the count.
  Future<void> getEventsCount2() async {
    try {
      QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
          .collection('event') // Adjust the main collection name if needed
          .where('status', isEqualTo: true)
          .get();

      int count = 0;

      for (QueryDocumentSnapshot<Object?> eventDoc in snapshot.docs) {
        QuerySnapshot<Object?> participantsSnapshot =
            await eventDoc.reference.collection('participant')
                .where('uid', isEqualTo: widget.user.uid)
                .get();

        if (participantsSnapshot.size > 0) {
          count++;
        }
      }

      setState(() {
        my_event = count;
        print("My event I Join: " + my_event.toString());
      });
    } catch (e) {
      print('Error fetching event count: $e');
    }
  }


  Future<void> getJobsCount() async {
    setState(() {
      job_applicant = 0;
    });
    try {
      QuerySnapshot<Object?> snapshot = await FirebaseFirestore.instance
          .collection('job') // Adjust the main collection name if needed
          .where('status', isEqualTo: true)
          .get();

      int count = 0;

      for (QueryDocumentSnapshot<Object?> eventDoc in snapshot.docs) {
        QuerySnapshot<Object?> participantsSnapshot =
            await eventDoc.reference.collection('applicants')
                .where('uid', isEqualTo: widget.user.uid)
                .get();

        if (participantsSnapshot.size > 0) {
          count++;
        }
      }

      setState(() {
        job_applicant = count;
        print("My job (Applied): " + job_applicant.toString());
      });
    } catch (e) {
      print('Error fetching job count: $e');
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    if (timestamp == null) {
      return '';
    }

    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    
    return formattedDate;
  }

  void setEventList(List<DocumentSnapshot<Object?>> list) {
    eventList = list;
  }

  void listenToEventChanges2() {
    eventsCollection.orderBy('end_date', descending: true).snapshots().listen(
      (QuerySnapshot<Object?> snapshot) {
        print("Snapshot received: ${snapshot.docs.length} documents");
        List<DocumentSnapshot<Object?>> eventList = snapshot.docs;
        setEventList(snapshot.docs);
        setState(() {
          eventController.add(eventList);
        }); 
      },
      onError: (error) => print('Error listening to event changes: $error'),
    );
  }

  void listenToEventChanges() {
    print("============================");
    eventsCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen(
          (QuerySnapshot<Object?> snapshot) async {
            print("Snapshot received: ${snapshot.docs.length} documents");
            List<DocumentSnapshot<Object?>> allEvents = snapshot.docs;
            List<DocumentSnapshot<Object?>> joinedEvents = [];

            for (var eventDoc in allEvents) {
              var participantSnapshot =
                  await eventDoc.reference.collection('participant').get();
              
              var participantDocs = participantSnapshot.docs;

              for (var participantDoc in participantDocs) {
                if (participantDoc['uid'] == widget.user.uid) {
                  // This event is joined by the user
                  joinedEvents.add(eventDoc);
                  break; // No need to check further for this event
                }
              }
            }

            setEventList(joinedEvents);
            setState(() {
              eventController.add(joinedEvents);
            });
          },
          onError: (error) =>
              print('Error listening to joined event changes: $error'),
        );
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
      prefs.setString("user_type", "seeker");
      print(userDetails['image'][0]);
      if(userDetails['image'][0] == "Empty"){
        prefs.setString("current_user_image", "https://s3.amazonaws.com/37assets/svn/765-default-avatar.png");
      }else{
        prefs.setString("current_user_image", userDetails['image'][0]);
      }
      setState(() {
        _name = userDetails['name']!;
        _email = userDetails['email']!;
        user_latitude = userDetails['location']['latitude'];
        user_longitude = userDetails['location']['longitude'];
        prefs.setDouble("user_latitude", userDetails['location']['latitude']);
        prefs.setDouble("user_longitude", userDetails['location']['longitude']);
        host_tier = userDetails['tier']!;
        host_point = userDetails['points']!;
        
        if(userDetails['image'][0] == "Empty"){
          _image = "https://s3.amazonaws.com/37assets/svn/765-default-avatar.png";
        }else{
          _image = image(userDetails['image']!);
        }
        uid = widget.user.uid!;
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

        //Scaffold -Drawer
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

            //Drawer 
            child: SingleChildScrollView(
              child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20.0, 50.0, 0.0, 10.0),
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
                //Seeker's name
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
                //Seeker's email
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
                //All the button
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
                                      builder: (context) => UserProfileWidget(),
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
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PublicEventListScreenWidget(),
                                    ),
                                  );
                                  getMainMenuDetail();
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
                                      builder: (context) => MyEventListScreenWidget(),
                                    ),
                                  );
                                  getMainMenuDetail();
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.event_available,
                                    size: 24.0,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  title: Text(
                                    'My Event',
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
                                      builder: (context) => MyJobListScreenWidget(),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.business,
                                    size: 24.0,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  title: Text(
                                    'My Job',
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
                                      builder: (context) => Verification(uid: widget.user.uid),
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
                                    'Verification',
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
                                      builder: (context) => RewardListScreenWidget(uid: widget.user.uid),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.card_giftcard,
                                    size: 24.0,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                  ),
                                  title: Text(
                                    'Rewards & Claims',
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
                                      builder: (context) => NotificationListScreenWidget(uid: widget.user.uid),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.chat,
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
                                      builder: (context) => LoginScreenWidget(),
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
                // 'MuzikLokal v1.0',
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 10.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SelectionArea(
                            child: Text(
                          'MuzikLokal v1.0',
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
        //Scaffold -Appbar
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Text('MuzikLokal',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        //Scaffold -body
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome Back, ',
                          style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Outfit',
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 24.0,
                          ),
                        ),
                        TextSpan(
                          text: _name.toString(),
                          style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: 'Outfit',
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Divider(
                  thickness: 2.0,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),

                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 15.0),
                  child: Text(
                    'My Dashboard',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 20.0,
                        ),
                  ),
                ),

                //Point + Tier 
                Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(6), 

                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        //Point balance
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Point Balance: ',
                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                TextSpan(
                                  text: host_point.toString(),
                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).customColor1,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //Tier
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
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                TextSpan(
                                  text: host_tier.toString(),
                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).customColor1,
                                    fontSize: 17.0,
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

                SizedBox (height: 15), 
                
                // Counter box
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Material(
                            color: Colors.transparent,
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Container(
                              height: 85.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primaryBackground,
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Event Joined',
                                      style: FlutterFlowTheme.of(context).labelMedium.override(
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            fontSize: 17.0,
                                          ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center, // Center the content horizontally
                                      children: [
                                        Text(
                                          my_event.toString(),
                                          style: FlutterFlowTheme.of(context).titleSmall.override(
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context).customColor1,
                                            fontWeight: FontWeight.w300,
                                            fontSize:25,
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
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Material(
                            color: Colors.transparent,
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Container(
                              height: 85.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primaryBackground,
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context).primaryBackground,
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
                                      'Job Applied',
                                      style: FlutterFlowTheme.of(context).labelMedium.override(
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            fontSize: 17.0,
                                          ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center, // Center the content horizontally
                                      children: [
                                        Text(
                                          job_applicant.toString(),
                                          style: FlutterFlowTheme.of(context).displaySmall.override(
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context).customColor1,
                                            fontWeight: FontWeight.w300,
                                            fontSize:25,
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

                // Title : My Event                  
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 5.0),
                  child: Text(
                    'My Event',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 20.0,
                        ),
                  ),
                ),

                //Listing of event
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Builder(
                          builder: (BuildContext builderContext) {
                            if (eventList.isEmpty) {
                              return Center(
                                child: Text(
                                  "You haven't joined any event.",
                                  style: TextStyle(fontSize: 18),
                                ),
                              );
                            } 
                            else {
                              return ListView.builder(
                                itemCount: eventList.length > 3 ? 3 : eventList.length,
                                //itemCount: eventList.length,
                                itemBuilder: (context, index) {
                                  final eventData = eventList[index].data() as Map<String, dynamic>;
                                  final event = Event.fromJson(eventData);
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                                    child: InkWell(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EventDetailHostWidget(event: event),
                                          ),
                                        );
                                        //getEvent();
                                        getEventsCount();
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
                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 260.0,
                                                      decoration: BoxDecoration(
                                                        color: FlutterFlowTheme.of(context).primaryBackground,
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: Image.network('',).image,
                                                        ),
                                                        borderRadius: BorderRadius.circular(12.0),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          //image 
                                                          ClipRect(
                                                            child: ImageFiltered(
                                                              imageFilter: ImageFilter.blur(
                                                                sigmaX: 2.0,
                                                                sigmaY: 2.0,
                                                              ),
                                                              child: Container(
                                                                width: double.infinity,
                                                                height: double.infinity,
                                                                decoration: BoxDecoration(
                                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                  image: DecorationImage(
                                                                    fit: BoxFit.cover,
                                                                    image: CachedNetworkImageProvider(image(event.image!)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //Container detail
                                                          Container(
                                                            decoration: BoxDecoration(),
                                                            child: Padding(
                                                              padding: EdgeInsets.all(16.0),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.max,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment.start,
                                                                children: [
                                                                  //Name
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsetsDirectional
                                                                            .fromSTEB(0.0, 0.0,
                                                                                12.0, 0.0),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize.max,
                                                                      children: [
                                                                        Icon(
                                                                          Icons.event_rounded,
                                                                          color: FlutterFlowTheme
                                                                                  .of(context)
                                                                              .customColor1,
                                                                          size: 24.0,
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsetsDirectional
                                                                                  .fromSTEB(
                                                                                      8.0,
                                                                                      0.0,
                                                                                      0.0,
                                                                                      0.0),
                                                                          child: Text(
                                                                            event.title.toString(),
                                                                            style: FlutterFlowTheme
                                                                                    .of(context)
                                                                                .bodyLarge
                                                                                .override(
                                                                                  fontFamily:
                                                                                      'Outfit',
                                                                                  color: FlutterFlowTheme.of(
                                                                                          context)
                                                                                      .customColor1,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  //Description
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding:
                                                                          EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                                  0.0,
                                                                                  8.0,
                                                                                  0.0,
                                                                                  0.0),
                                                                      child: Text(
                                                                        event.description.toString(),
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        maxLines: 2,
                                                                        style:
                                                                            FlutterFlowTheme.of(
                                                                                    context)
                                                                                .labelMedium
                                                                                .override(
                                                                                  fontFamily:
                                                                                      'Outfit',
                                                                                  color: FlutterFlowTheme.of(
                                                                                          context)
                                                                                      .customColor1,
                                                                                ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  //Date
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                                0.0,
                                                                                8.0,
                                                                                0.0,
                                                                                0.0),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize.max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'Date',
                                                                          style: FlutterFlowTheme
                                                                                  .of(context)
                                                                              .labelSmall
                                                                              .override(
                                                                                fontFamily:
                                                                                    'Outfit',
                                                                                color: FlutterFlowTheme.of(
                                                                                        context)
                                                                                    .customColor1,
                                                                              ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsetsDirectional
                                                                                  .fromSTEB(
                                                                                      16.0,
                                                                                      4.0,
                                                                                      4.0,
                                                                                      0.0),
                                                                          child: Text(
                                                                            formatTimestamp(event.start_date) + " - " + formatTimestamp(event.end_date),
                                                                            style: FlutterFlowTheme.of(
                                                                                    context)
                                                                                .bodySmall
                                                                                .override(
                                                                                  fontFamily:
                                                                                      'Outfit',
                                                                                  color: FlutterFlowTheme.of(
                                                                                          context)
                                                                                      .customColor1,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                      //Time
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsetsDirectional
                                                                                .fromSTEB(
                                                                                    0.0,
                                                                                    8.0,
                                                                                    0.0,
                                                                                    0.0),
                                                                        child: Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment
                                                                                  .spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              'Time',
                                                                              style: FlutterFlowTheme
                                                                                      .of(context)
                                                                                  .labelSmall
                                                                                  .override(
                                                                                    fontFamily:
                                                                                        'Outfit',
                                                                                    color: FlutterFlowTheme.of(
                                                                                            context)
                                                                                        .customColor1,
                                                                                  ),
                                                                            ),
                                                                            Padding(
                                                                              padding:
                                                                                  EdgeInsetsDirectional
                                                                                      .fromSTEB(
                                                                                          16.0,
                                                                                          4.0,
                                                                                          4.0,
                                                                                          0.0),
                                                                              child: Text(
                                                                                event.start_time! + " - " + event.end_time!,
                                                                                style: FlutterFlowTheme.of(
                                                                                        context)
                                                                                    .bodySmall
                                                                                    .override(
                                                                                      fontFamily:
                                                                                          'Outfit',
                                                                                      color: FlutterFlowTheme.of(
                                                                                              context)
                                                                                          .customColor1,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),

                                                                  //Location
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsetsDirectional
                                                                            .fromSTEB(0.0, 8.0,
                                                                                0.0, 0.0),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize.max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'Location',
                                                                          style: FlutterFlowTheme
                                                                                  .of(context)
                                                                              .labelSmall
                                                                              .override(
                                                                                fontFamily:
                                                                                    'Outfit',
                                                                                color: FlutterFlowTheme.of(
                                                                                        context)
                                                                                    .customColor1,
                                                                              ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Padding(
                                                                            padding:
                                                                                EdgeInsetsDirectional
                                                                                    .fromSTEB(
                                                                                        16.0,
                                                                                        4.0,
                                                                                        4.0,
                                                                                        0.0),
                                                                            child: Text(
                                                                              event.location!['address']!,
                                                                              textAlign: TextAlign.end,
                                                                              maxLines: 2,
                                                                              style:
                                                                                  FlutterFlowTheme.of(
                                                                                          context)
                                                                                      .labelMedium
                                                                                      .override(
                                                                                        fontFamily:
                                                                                            'Outfit',
                                                                                        color: FlutterFlowTheme.of(
                                                                                                context)
                                                                                            .customColor1,
                                                                                      ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),

                                                                  // Detail button
                                                                  Row(
                                                                    mainAxisSize:MainAxisSize.max,
                                                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Padding(padding:EdgeInsetsDirectional.fromSTEB(0.0,16.0,0.0,0.0),

                                                                        child: FFButtonWidget(
                                                                          onPressed: () async {
                                                                            await Navigator.push(context,
                                                                              MaterialPageRoute(builder: (context) => EventDetailHostWidget(event: event),),
                                                                            );
                                                                            //getEvent();
                                                                            getEventsCount();
                                                                          },
                                                                          text: 'Detail',
                                                                          options: FFButtonOptions(
                                                                            width: 150.0,
                                                                            height: 44.0,
                                                                            padding:EdgeInsetsDirectional.fromSTEB(0.0,0.0,0.0,0.0),      
                                                                            iconPadding:EdgeInsetsDirectional.fromSTEB(0.0,0.0,0.0,0.0),                                                                                            
                                                                            color:FlutterFlowTheme.of(context).primaryText,
                                                                            textStyle:FlutterFlowTheme.of(context)
                                                                                      .titleSmall.override(
                                                                                        fontFamily:'Outfit',
                                                                                        color: FlutterFlowTheme.of(context).secondaryBackground,),
                                                                                        elevation: 3.0, 
                                                                                        borderRadius:BorderRadius.circular(12.0),
                                                                              
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ), // Row

                                                                ],
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

                // // 2Title : My Event                  
                // Padding(
                //   padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 5.0),
                //   child: Text(
                //     'My Event',
                //     style: FlutterFlowTheme.of(context).titleMedium.override(
                //           fontFamily: 'Outfit',
                //           color: FlutterFlowTheme.of(context).primaryText,
                //           fontSize: 20.0,
                //         ),
                //   ),
                // ),

                // //2Listing of event
                // SingleChildScrollView(
                //   child: Column(
                //     children: [
                //       Container(
                //         height: MediaQuery.of(context).size.height * 0.5,
                //         child: Builder(
                //           builder: (BuildContext builderContext) {
                //             if (eventList.isEmpty) {
                //               return Center(
                //                 child: Text(
                //                   "You haven't joined any event.",
                //                   style: TextStyle(fontSize: 18),
                //                 ),
                //               );
                //             } 
                //             else {
                //               return ListView.builder(
                //                 itemCount: eventList.length > 3 ? 3 : eventList.length,
                //                 //itemCount: eventList.length,
                //                 itemBuilder: (context, index) {
                //                   final eventData = eventList[index].data() as Map<String, dynamic>;
                //                   final event = Event.fromJson(eventData);
                //                   return Padding(
                //                     padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                //                     child: InkWell(
                //                       onTap: () async {
                //                         await Navigator.push(
                //                           context,
                //                           MaterialPageRoute(
                //                             builder: (context) => EventDetailHostWidget(event: event),
                //                           ),
                //                         );
                //                         //getEvent();
                //                         getEventsCount();
                //                       },

                //                       child: Row(
                //                         mainAxisSize: MainAxisSize.max,
                //                         children: [
                //                           Expanded(
                //                             child: SingleChildScrollView(
                //                               child: Column(
                //                                 mainAxisSize: MainAxisSize.max,
                //                                 children: [

                //                                   Padding(
                //                                     padding: EdgeInsetsDirectional.fromSTEB(
                //                                         0.0, 0.0, 0.0, 16.0),
                //                                     child: Container(
                //                                       width: double.infinity,
                //                                       height: 260.0,
                //                                       decoration: BoxDecoration(
                //                                         color: FlutterFlowTheme.of(context)
                //                                             .primaryBackground,
                //                                         image: DecorationImage(
                //                                           fit: BoxFit.cover,
                //                                           image: Image.network(
                //                                             '',
                //                                           ).image,
                //                                         ),
                //                                         borderRadius:
                //                                             BorderRadius.circular(12.0),
                //                                       ),
                //                                       child: Stack(
                //                                         children: [
                //                                           //image 
                //                                           ClipRect(
                //                                             child: ImageFiltered(
                //                                               imageFilter: ImageFilter.blur(
                //                                                 sigmaX: 2.0,
                //                                                 sigmaY: 2.0,
                //                                               ),
                //                                               child: Container(
                //                                                 width: double.infinity,
                //                                                 height: double.infinity,
                //                                                 decoration: BoxDecoration(
                //                                                   color: FlutterFlowTheme.of(
                //                                                           context)
                //                                                       .secondaryBackground,
                //                                                   image: DecorationImage(
                //                                                     fit: BoxFit.cover,
                //                                                     image: CachedNetworkImageProvider(image(event.image!)),
                //                                                   ),
                //                                                 ),
                //                                               ),
                //                                             ),
                //                                           ),
                //                                           //Container detail
                //                                           Container(
                //                                             decoration: BoxDecoration(),
                //                                             child: Padding(
                //                                               padding: EdgeInsets.all(16.0),
                //                                               child: Column(
                //                                                 mainAxisSize: MainAxisSize.max,
                //                                                 crossAxisAlignment:
                //                                                     CrossAxisAlignment.start,
                //                                                 children: [
                //                                                   //Name
                //                                                   Padding(
                //                                                     padding:
                //                                                         EdgeInsetsDirectional
                //                                                             .fromSTEB(0.0, 0.0,
                //                                                                 12.0, 0.0),
                //                                                     child: Row(
                //                                                       mainAxisSize:
                //                                                           MainAxisSize.max,
                //                                                       children: [
                //                                                         Icon(
                //                                                           Icons.event_rounded,
                //                                                           color: FlutterFlowTheme
                //                                                                   .of(context)
                //                                                               .customColor1,
                //                                                           size: 24.0,
                //                                                         ),
                //                                                         Padding(
                //                                                           padding:
                //                                                               EdgeInsetsDirectional
                //                                                                   .fromSTEB(
                //                                                                       8.0,
                //                                                                       0.0,
                //                                                                       0.0,
                //                                                                       0.0),
                //                                                           child: Text(
                //                                                             event.title.toString(),
                //                                                             style: FlutterFlowTheme
                //                                                                     .of(context)
                //                                                                 .bodyLarge
                //                                                                 .override(
                //                                                                   fontFamily:
                //                                                                       'Outfit',
                //                                                                   color: FlutterFlowTheme.of(
                //                                                                           context)
                //                                                                       .customColor1,
                //                                                                 ),
                //                                                           ),
                //                                                         ),
                //                                                       ],
                //                                                     ),
                //                                                   ),
                //                                                   //Description
                //                                                   Expanded(
                //                                                     child: Padding(
                //                                                       padding:
                //                                                           EdgeInsetsDirectional
                //                                                               .fromSTEB(
                //                                                                   0.0,
                //                                                                   8.0,
                //                                                                   0.0,
                //                                                                   0.0),
                //                                                       child: Text(
                //                                                         event.description.toString(),
                //                                                         textAlign:
                //                                                             TextAlign.start,
                //                                                         maxLines: 2,
                //                                                         style:
                //                                                             FlutterFlowTheme.of(
                //                                                                     context)
                //                                                                 .labelMedium
                //                                                                 .override(
                //                                                                   fontFamily:
                //                                                                       'Outfit',
                //                                                                   color: FlutterFlowTheme.of(
                //                                                                           context)
                //                                                                       .customColor1,
                //                                                                 ),
                //                                                       ),
                //                                                     ),
                //                                                   ),
                //                                                   //Date
                //                                                   Padding(
                //                                                     padding:
                //                                                         EdgeInsetsDirectional
                //                                                             .fromSTEB(
                //                                                                 0.0,
                //                                                                 8.0,
                //                                                                 0.0,
                //                                                                 0.0),
                //                                                     child: Row(
                //                                                       mainAxisSize:
                //                                                           MainAxisSize.max,
                //                                                       mainAxisAlignment:
                //                                                           MainAxisAlignment
                //                                                               .spaceBetween,
                //                                                       children: [
                //                                                         Text(
                //                                                           'Date',
                //                                                           style: FlutterFlowTheme
                //                                                                   .of(context)
                //                                                               .labelSmall
                //                                                               .override(
                //                                                                 fontFamily:
                //                                                                     'Outfit',
                //                                                                 color: FlutterFlowTheme.of(
                //                                                                         context)
                //                                                                     .customColor1,
                //                                                               ),
                //                                                         ),
                //                                                         Padding(
                //                                                           padding:
                //                                                               EdgeInsetsDirectional
                //                                                                   .fromSTEB(
                //                                                                       16.0,
                //                                                                       4.0,
                //                                                                       4.0,
                //                                                                       0.0),
                //                                                           child: Text(
                //                                                             formatTimestamp(event.start_date) + " - " + formatTimestamp(event.end_date),
                //                                                             style: FlutterFlowTheme.of(
                //                                                                     context)
                //                                                                 .bodySmall
                //                                                                 .override(
                //                                                                   fontFamily:
                //                                                                       'Outfit',
                //                                                                   color: FlutterFlowTheme.of(
                //                                                                           context)
                //                                                                       .customColor1,
                //                                                                 ),
                //                                                           ),
                //                                                         ),
                //                                                       ],
                //                                                     ),
                //                                                   ),
                //                                                       //Time
                //                                                       Padding(
                //                                                         padding:
                //                                                             EdgeInsetsDirectional
                //                                                                 .fromSTEB(
                //                                                                     0.0,
                //                                                                     8.0,
                //                                                                     0.0,
                //                                                                     0.0),
                //                                                         child: Row(
                //                                                           mainAxisSize:
                //                                                               MainAxisSize.max,
                //                                                           mainAxisAlignment:
                //                                                               MainAxisAlignment
                //                                                                   .spaceBetween,
                //                                                           children: [
                //                                                             Text(
                //                                                               'Time',
                //                                                               style: FlutterFlowTheme
                //                                                                       .of(context)
                //                                                                   .labelSmall
                //                                                                   .override(
                //                                                                     fontFamily:
                //                                                                         'Outfit',
                //                                                                     color: FlutterFlowTheme.of(
                //                                                                             context)
                //                                                                         .customColor1,
                //                                                                   ),
                //                                                             ),
                //                                                             Padding(
                //                                                               padding:
                //                                                                   EdgeInsetsDirectional
                //                                                                       .fromSTEB(
                //                                                                           16.0,
                //                                                                           4.0,
                //                                                                           4.0,
                //                                                                           0.0),
                //                                                               child: Text(
                //                                                                 event.start_time! + " - " + event.end_time!,
                //                                                                 style: FlutterFlowTheme.of(
                //                                                                         context)
                //                                                                     .bodySmall
                //                                                                     .override(
                //                                                                       fontFamily:
                //                                                                           'Outfit',
                //                                                                       color: FlutterFlowTheme.of(
                //                                                                               context)
                //                                                                           .customColor1,
                //                                                                     ),
                //                                                               ),
                //                                                             ),
                //                                                           ],
                //                                                         ),
                //                                                       ),

                //                                                   //Location
                //                                                   Padding(
                //                                                     padding:
                //                                                         EdgeInsetsDirectional
                //                                                             .fromSTEB(0.0, 8.0,
                //                                                                 0.0, 0.0),
                //                                                     child: Row(
                //                                                       mainAxisSize:
                //                                                           MainAxisSize.max,
                //                                                       mainAxisAlignment:
                //                                                           MainAxisAlignment
                //                                                               .spaceBetween,
                //                                                       children: [
                //                                                         Text(
                //                                                           'Location',
                //                                                           style: FlutterFlowTheme
                //                                                                   .of(context)
                //                                                               .labelSmall
                //                                                               .override(
                //                                                                 fontFamily:
                //                                                                     'Outfit',
                //                                                                 color: FlutterFlowTheme.of(
                //                                                                         context)
                //                                                                     .customColor1,
                //                                                               ),
                //                                                         ),
                //                                                         Expanded(
                //                                                           child: Padding(
                //                                                             padding:
                //                                                                 EdgeInsetsDirectional
                //                                                                     .fromSTEB(
                //                                                                         16.0,
                //                                                                         4.0,
                //                                                                         4.0,
                //                                                                         0.0),
                //                                                             child: Text(
                //                                                               event.location!['address']!,
                //                                                               textAlign: TextAlign.end,
                //                                                               maxLines: 2,
                //                                                               style:
                //                                                                   FlutterFlowTheme.of(
                //                                                                           context)
                //                                                                       .labelMedium
                //                                                                       .override(
                //                                                                         fontFamily:
                //                                                                             'Outfit',
                //                                                                         color: FlutterFlowTheme.of(
                //                                                                                 context)
                //                                                                             .customColor1,
                //                                                                       ),
                //                                                             ),
                //                                                           ),
                //                                                         ),
                //                                                       ],
                //                                                     ),
                //                                                   ),

                //                                                   // Detail button
                //                                                   Row(
                //                                                     mainAxisSize:MainAxisSize.max,
                //                                                     mainAxisAlignment:MainAxisAlignment.spaceBetween,
                //                                                     children: [
                //                                                       Padding(padding:EdgeInsetsDirectional.fromSTEB(0.0,16.0,0.0,0.0),

                //                                                         child: FFButtonWidget(
                //                                                           onPressed: () async {
                //                                                             await Navigator.push(context,
                //                                                               MaterialPageRoute(builder: (context) => EventDetailHostWidget(event: event),),
                //                                                             );
                //                                                             //getEvent();
                //                                                             getEventsCount();
                //                                                           },
                //                                                           text: 'Detail',
                //                                                           options: FFButtonOptions(
                //                                                             width: 150.0,
                //                                                             height: 44.0,
                //                                                             padding:EdgeInsetsDirectional.fromSTEB(0.0,0.0,0.0,0.0),      
                //                                                             iconPadding:EdgeInsetsDirectional.fromSTEB(0.0,0.0,0.0,0.0),                                                                                            
                //                                                             color:FlutterFlowTheme.of(context).primaryText,
                //                                                             textStyle:FlutterFlowTheme.of(context)
                //                                                                       .titleSmall.override(
                //                                                                         fontFamily:'Outfit',
                //                                                                         color: FlutterFlowTheme.of(context).secondaryBackground,),
                //                                                                         elevation: 3.0, 
                //                                                                         borderRadius:BorderRadius.circular(12.0),
                                                                              
                //                                                           ),
                //                                                         ),
                //                                                       ),
                //                                                     ],
                //                                                   ), // Row

                //                                                 ],
                //                                               ),
                //                                             ),
                //                                           ),

                //                                         ],
                //                                       ),
                //                                     ),
                //                                   ),
                //                                 ],
                //                               ),
                //                             ),
                //                           ),
                //                         ],
                //                       ),

                //                     ),
                //                   );
                //                 },
                //               );
                //             }
                //           },
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

      ),
    );
  }

}
