
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'host_verification_detail_screen_model.dart';
export 'host_verification_detail_screen_model.dart';
import '../../../data/models/user_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../add_admin_screen/edit_user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HostVerificationDetailScreenWidget extends StatefulWidget {
  final Users user;
  const HostVerificationDetailScreenWidget({required this.user});
  @override
  _HostVerificationDetailScreenWidgetState createState() =>
      _HostVerificationDetailScreenWidgetState();
}
class _HostVerificationDetailScreenWidgetState extends State<HostVerificationDetailScreenWidget> {
  late SharedPreferences _prefs;
  late HostVerificationDetailScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String name = "";
  String email = "";
  String phone = "";
  String user_type = "";
  var points = 0;
  Map<String, dynamic>? userDetails;

  bool isButtonPressed =false;
  bool isVerificationApproved = false;
  bool isVerificationRejected = false;
  var user_verify_status = false;
  var request_to_verify ;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HostVerificationDetailScreenModel());
     
    // Initialize SharedPreferences for the current user
    initializeUserSharedPreferences();
    
    loadUserDetails();
    loadButtonState();
    if (widget.user.uid != null) {
      getUserVerificationStatus(widget.user.uid!);
        // Initialize state variables here
    }
  }
  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> initializeUserSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }
  // Function to fetch user details from the 'users' collection using the provided UID
  Future<Map<String, dynamic>> getUserDetails(String uid) async {
    try {
      // Create an instance of FirebaseFirestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Get the document snapshot for the specified UID
      DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();
      // Check if the document exists
      if (userDoc.exists) {
        // Extract user details from the document
        Map<String, dynamic> userDetails = {
          'name': userDoc['name'],
          'email': userDoc['email'],
          'phone': userDoc['phone'],
          'user_type': userDoc['user_type'],
          'points': userDoc['points'],
        };
        return userDetails;
      } else {
        // Return an empty map if the document does not exist
        return {};
      }
    } catch (error) {
      // Print error details if fetching user details fails
      print('Error getting user details: $error');
      return {};
    }
  }

  // Function to generate unique keys for each user based on their UID
  String getKey(String key) {
    // Concatenate the user's UID with the key
    return '${widget.user.uid}_$key';
  }

  Future<void> getUserVerificationStatus(String? userUid) async {
        try {
            // Define a reference to the 'users' collection
            CollectionReference<Map<String, dynamic>> usersCollection = FirebaseFirestore.instance.collection('users');
            // Retrieve a specific document from the collection using its userUid
            DocumentSnapshot<Map<String, dynamic>> userSnapshot = await usersCollection.doc(userUid).get();
            if (userSnapshot.exists) {
            // If the document exists, retrieve the verification status and request verification status
            // else  if that value is null, it defaults to false. It's a concise way of handling null values in Dart.
            bool verificationStatus = userSnapshot.get('verification') ?? false;
            bool requestVerification = userSnapshot.get('request_to_verify') ;
            //bool approvalStatus = userSnapshot.get('is_approved') ?? false;
            //bool rejectedStatus = userSnapshot.get('is_rejected') ?? false;

            // Update the state variables using setState
            setState(() {
                user_verify_status = verificationStatus;
                request_to_verify = requestVerification;
                //isVerificationApproved : approvalStatus;
                //isVerificationRejected : rejectedStatus;
            });
            } else {
                  // If the document does not exist, set user_verify_status to false
                setState(() {
                    user_verify_status = false;
                    // isVerificationApproved =false;
                    // isVerificationRejected =false;
                });
            }
        } catch (e) {
              // Handle any errors that might occur during the retrieval of verification status
            print('Error getting user verification status: $e');
            setState(() {
                user_verify_status = false;
                // isVerificationApproved =false;
                // isVerificationRejected =false;
            });
        }
  }
  
  sendStatusNotificationApproval() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Get the UID of the current user
      String adminUid = currentUser.uid;

      try {
        // Retrieve the user document from Firestore to get the name
        DocumentSnapshot<Map<String, dynamic>> userSnapshot = await firestore
            .collection('users')
            .doc(adminUid)
            .get();

        // Check if the user document exists and contains the 'name' field
        if (userSnapshot.exists) {
          String adminName = userSnapshot.get('name') ?? 'Default Name';

          // Add the notification to the 'notification' collection
          DocumentReference notificationRef = await firestore
              .collection('users')
              .doc(widget.user.uid!)
              .collection('notification')
              .add({
                'title': "Verification Approve",
                'content': "1000 points have been credited to your account as a verification reward",
                'timestamp': FieldValue.serverTimestamp(),
                'uid': "", // Leave it empty for now
                'created_by': adminName,
                //'read': false,
              });

          // Get the auto-generated uid from the notificationRef
          String notificationUid = notificationRef.id;

          // Update the notification document with the correct uid
          await notificationRef.update({'uid': notificationUid});
        } else {
          // Handle the case where the user document does not exist
          print('User document does not exist');
        }
      } catch (e) {
        // Handle any errors that might occur during the retrieval of user data
        print('Error getting user data: $e');
      }
    } else {
      // Handle the case where there is no authenticated user
      print('No authenticated user');
    }
  }

  sendStatusNotificationRejected() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Get the UID of the current user
      String adminUid = currentUser.uid;

      try {
        // Retrieve the user document from Firestore to get the name
        DocumentSnapshot<Map<String, dynamic>> userSnapshot = await firestore
            .collection('users')
            .doc(adminUid)
            .get();

        // Check if the user document exists and contains the 'name' field
        if (userSnapshot.exists) {
          String adminName = userSnapshot.get('name') ?? 'Default Name';

          // Add the notification to the 'notification' collection
          DocumentReference notificationRef = await firestore
              .collection('users')
              .doc(widget.user.uid!)
              .collection('notification')
              .add({
                'title': "Verification Rejected",
                'content': "Verification rejected, please submit again.",
                'timestamp': FieldValue.serverTimestamp(),
                'uid': "", // Leave it empty for now
                'created_by': adminName,
                //'read': false,
              });

          // Get the auto-generated uid from the notificationRef
          String notificationUid = notificationRef.id;

          // Update the notification document with the correct uid
          await notificationRef.update({'uid': notificationUid});
        } else {
          // Handle the case where the user document does not exist
          print('User document does not exist');
        }
      } catch (e) {
        // Handle any errors that might occur during the retrieval of user data
        print('Error getting user data: $e');
      }
    } else {
      // Handle the case where there is no authenticated user
      print('No authenticated user');
    }
  }

  Future<void> loadUserDetails() async {
    Map<String, dynamic>? details = await getUserDetails(widget.user.uid!);
        setState(() {
            userDetails = details;
            name = userDetails!['name']!;
            email = userDetails!['email']!;
            phone = userDetails!['phone']!;
            user_type = userDetails!['user_type']!;
            points = userDetails!['points']!;
        });
  }
  image(pictures){
    var list = pictures;
    var stringList = list.join("");
    return stringList;
  }
  Future<void> updateStatus(String approval) async {
    try {
      if(approval == "approve"){
        await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({
             'request_to_verify': true,
            //'request_to_verify': false,
            'verification': true,
            'points': points + 1000,
            'is_approved' : true,
            'is_rejected' : false,
            });
                setState(() {
                  isVerificationApproved = true;
                  isVerificationRejected = false;
                  isButtonPressed = true;                  
                });
        sendStatusNotificationApproval();
        Alert(
          context: context,
          type: AlertType.success,
          title: "Verification Approve",
          desc: "Verification approved, this user will receive the verification badge",
          buttons: [
            DialogButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              width: 120,
            )
          ],
        ).show();
      }
      
      else{
        await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({
            // 'request_to_verify': false,
            'request_to_verify': true,
            'verification': false,
            'is_approved' : false,
            'is_rejected' : true,
            //'proof_for_verification_1': ['Empty'],
            //'proof_for_verification_2': ['Empty'],
            });
                  setState(() {
                  isVerificationApproved = false;
                  isVerificationRejected = true;
                  isButtonPressed = true;                  
                });
        sendStatusNotificationRejected();
        Alert(
          context: context,
          type: AlertType.error,
          title: "Verification Rejected",
          desc: "Verification rejected, this user will not receive the verification badge",
          buttons: [
            DialogButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                //bool isVerificationRejected = true;
              },
              width: 120,
            )
          ],
        ).show();
      }
    } catch (error) {
      print('Error updating status: $error');
      // Handle error as needed
    }
  }

      // Future<void> loadButtonState() async {
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   setState(() {
      //     isButtonPressed = prefs.getBool('isButtonPressed') ?? false;
      //     isVerificationApproved = prefs.getBool('isVerificationApproved') ?? false;
      //     isVerificationRejected = prefs.getBool('isVerificationRejected') ?? false;
   
      //   });
      // }
      // Future<void> saveButtonState(bool isPressed) async {
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   await prefs.setBool('isButtonPressed', isPressed);
      // }

  //       Future<void> loadButtonState() async {
  //   // Use the unique identifier (UID) of the current user for SharedPreferences keys
  //   String userKey = widget.user.uid ?? ''; // Replace with your logic to handle null UID
  //   setState(() {
  //     isButtonPressed = _prefs.getBool('$userKey-isButtonPressed') ?? false;
  //     isVerificationApproved = _prefs.getBool('$userKey-isVerificationApproved') ?? false;
  //     isVerificationRejected = _prefs.getBool('$userKey-isVerificationRejected') ?? false;
  //   });
  // }

  // Future<void> saveButtonState(bool isPressed) async {
  //   // Use the unique identifier (UID) of the current user for SharedPreferences keys
  //   String userKey = widget.user.uid ?? ''; // Replace with your logic to handle null UID
  //   await _prefs.setBool('$userKey-isButtonPressed', isPressed);
  //   await _prefs.setBool('$userKey-isVerificationApproved', isVerificationApproved);
  //   await _prefs.setBool('$userKey-isVerificationRejected', isVerificationRejected);
  // }

// In your loadButtonState method

Future<void> loadButtonState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    // Use getKey to get the user-specific keys
    isButtonPressed = prefs.getBool(getKey('isButtonPressed')) ?? false;
    isVerificationApproved = prefs.getBool(getKey('isVerificationApproved')) ?? false;
    isVerificationRejected = prefs.getBool(getKey('isVerificationRejected')) ?? false;
  });
}

// In your saveButtonState method

Future<void> saveButtonState(bool isPressed) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Use getKey to save user-specific keys
  await prefs.setBool(getKey('isButtonPressed'), isPressed);
  await prefs.setBool(getKey('isVerificationApproved'), isVerificationApproved);
  await prefs.setBool(getKey('isVerificationRejected'), isVerificationRejected);
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
            'User Detail',
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
                        //user profile pic
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Container(
                                width: 120.0,
                                height: 120.0,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.network(
                                  (image(widget.user.image!) != "Empty")
                                  ? image(widget.user.image!)
                                  : "https://s3.amazonaws.com/37assets/svn/765-default-avatar.png",
                                ),
                              ),
                            ),
                          ],
                        ),

                        // 4 Columns of Details
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 10.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row( //Name
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text('Name',
                                              style:FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: 'Outfit',
                                                    color:FlutterFlowTheme.of(context).primaryText,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(name,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Outfit',
                                                color: FlutterFlowTheme.of(context).customColor1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row( //User Type
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text('User Type',
                                              style:FlutterFlowTheme.of(context).titleSmall.override(
                                                      fontFamily: 'Outfit',
                                                      color:FlutterFlowTheme.of(context).primaryText,
                                                        fontSize: 16.0,
                                                        fontWeight:FontWeight.normal,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Text(user_type == "seeker" ? "Seeker" : "Host" ,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Outfit',
                                                color:FlutterFlowTheme.of(context).customColor1,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row( //Email
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text('Email',
                                              style:FlutterFlowTheme.of(context).titleSmall.override(
                                                        fontFamily: 'Outfit',
                                                        color:FlutterFlowTheme.of(context).primaryText,
                                                        fontSize: 16.0,
                                                        fontWeight:FontWeight.normal,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Text(email,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Outfit',
                                                color:FlutterFlowTheme.of(context).customColor1,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row( // Phone
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text('Phone',
                                              style:FlutterFlowTheme.of(context).titleSmall.override(
                                                        fontFamily: 'Outfit',
                                                        color:FlutterFlowTheme.of(context).primaryText,
                                                        fontSize: 16.0,
                                                        fontWeight:FontWeight.normal,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Text(phone,
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Outfit',
                                                color:FlutterFlowTheme.of(context).customColor1,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ], // children
                                ), //  child: Column(
                              ), // Expanded
                            ], //children 
                          ), //child:Row ()
                        ), // Padding for 4 Column Details 

                        // verification_picture1                           
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(04.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Front I/C :',
                                style: FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: EdgeInsetsDirectional.fromSTEB(4.0, 10.0, 0.0, 10.0),
                          child: (image(widget.user.proof_for_verification_1!) != "Empty")
                            ? Image.network(image(widget.user.proof_for_verification_1!))
                            : Image.network("https://s3.amazonaws.com/37assets/svn/765-default-avatar.png"),
                        ),

                       // verification_picture2
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(04.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Back I/C :',
                                style: FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),       
                        Container(
                          padding: EdgeInsetsDirectional.fromSTEB(4.0, 10.0, 0.0, 10.0),
                          child: (image(widget.user.proof_for_verification_2!) != "Empty")
                            ? Image.network(image(widget.user.proof_for_verification_2!))
                            : Image.network("https://s3.amazonaws.com/37assets/svn/765-default-avatar.png"),
                        ),

                        // If status is false as its not verify and no button have yet been press
                        // So show two buttons 
                        if (isVerificationApproved == false && isVerificationRejected == false)...[

                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(4.0, 10.0, 0.0, 10.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                //Set the boolean variable to true when the approve button is pressed
                                setState(() {
                                    isVerificationApproved = true;
                                    isVerificationRejected = false;
                                    isButtonPressed = true;
                                });
                                updateStatus("approve");
                                await saveButtonState(true);
                              },
                              text: 'Approve',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50.0,
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).success,
                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context).customColor1,
                                  fontSize: 16.0,
                                ),
                                elevation: 3.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 40.0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                // Set the boolean variable to true when the reject button is pressed
                                setState(() {
                                    isVerificationApproved = false;
                                    isVerificationRejected = true;
                                    isButtonPressed = true;
                                });
                                updateStatus("reject");
                                await saveButtonState(true);
                              },
                              text: 'Reject',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50.0,
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).error,
                                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context).customColor1,
                                  fontSize: 16.0,
                                ),
                                elevation: 3.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                        // else if (isVerificationApproved == true)...[
                        //   Row(
                        //     children: [
                        //       Text("isVerificationApproved == true"),
                        //       // Add other widgets as needed
                        //     ],
                        //   ),
                        // ]else if (isVerificationRejected == false)...[
                        //    Row(
                        //     children: [
                        //       Text("isVerificationRejected == false"),
                        //       // Add other widgets as needed
                        //     ],
                        //   ), 
                        // ],
                      //   // Reject button have been press
                      //   else if (isVerificationApproved == false && isVerificationRejected==true )
                      //   Row(),
                     
                       // Verification Status Messages
                        if (isVerificationApproved == true && isVerificationRejected==false && isButtonPressed==true)
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).success,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                'Status: Approved',
                                style: FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context).customColor1,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          )
                      
                        // Approve button have been press
                        else if (isVerificationApproved == false && isVerificationRejected==true && isButtonPressed==true)

                          Center(
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color:FlutterFlowTheme.of(context).error,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  'Status: Rejected',
                                  style: FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).customColor1,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            )
                        // else if (user_verify_status == false && isVerificationApproved == false && isVerificationRejected==false )
                        //   Row(
                        //       children: [Text("ALL FALSE"),],
                        //   ),

                      ], // children /
                    ),
                  ),
                ],
              ),
            ),
          ),
        ), // Body : Safe area
      ),//      child: Scaffold(
    ); // GestureDetector
  } //   Widget build(BuildContext context) {
} //_HostVerificationDetailScreenWidgetState
