import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../search_widget.dart';
import '../../screens/skeleton_screen.dart';
import '../../../data/models/user_model.dart';
import '../host_verification_detail_screen/host_verification_detail_screen_widget.dart';
import 'host_verification_list_model.dart';
export 'host_verification_list_model.dart';

class HostVerificationListWidget extends StatefulWidget {
  const HostVerificationListWidget({Key? key}) : super(key: key);

  @override
  _HostVerificationListWidgetState createState() => _HostVerificationListWidgetState();
}

class _HostVerificationListWidgetState extends State<HostVerificationListWidget> {
  late HostVerificationListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  String query = '';
  Timer? debouncer;
  final db = FirebaseFirestore.instance;
  CollectionReference docUser = FirebaseFirestore.instance.collection('users');
  List<Users> users = [];
  List<Users> userList = [];

  // Function to fetch the list of users from the 'users' collection
  getUserList2() async {
    try {
      // Get the user documents from the 'users' collection
      var data = await db.collection('/users').get();

      // Check if there are no user documents
      if (data.docs.isEmpty) {
        print('No users available');
        return;
      }

      // Clear the existing userList
      userList.clear();

      // Iterate through the documents and create Users objects
      for (var doc in data.docs) {
        Users? temp = Users.fromDocument(doc);
        userList.add(temp);
      }

      // If the widget is mounted, update the UI
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      // Print error details if fetching user list fails
      print('Error getting users: $error');
    }
  }

 // Function to fetch the list of users from the 'users' collection
  Future<void> getUserList() async {
    try {
      // Clear the existing userList
      userList.clear();

      // Query all user documents from the 'users' collection
      QuerySnapshot<Map<String, dynamic>> usersSnapshot = 
      //await db.collection('/users').get();
       await db.collection('/users').where('request_to_verify', isEqualTo: true).get();

      // Process the snapshot and add users to the list
      for (QueryDocumentSnapshot<Map<String, dynamic>> userDoc in usersSnapshot.docs) {
        Users? temp = Users.fromDocument(userDoc);
        userList.add(temp);
      }

      // Update the UI if the widget is still mounted
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error getting users: $error');
    }
  }
    
  init(){
    final list = userList;
    setState(() => this.users = list);
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  @override
  void initState() {
    getUserList();
    super.initState();
    _model = createModel(context, () => HostVerificationListModel());

    _model.emailAddressController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();
    init();
  }

  @override
  void dispose() {
    _model.dispose();
    debouncer?.cancel();
    super.dispose();
  }

  image(pictures){
    var list = pictures;
    var stringList = list.join("");

    return stringList;
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
            'User Verification List',
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 4.0, 24.0),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Color(0x33000000),
                                  offset: Offset(0.0, 2.0),
                                )
                              ],
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 20.0, 0.0, 12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'User verification list',
                                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                                      fontFamily: 'Outfit',
                                      color: FlutterFlowTheme.of(context).primaryText,
                                      fontSize: 20.0,
                                    ),
                                    ),
                                  ),
                                  buildSearch(),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(12.0, 12.0, 12.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding:EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                            child: Text('Name',
                                              style:FlutterFlowTheme.of(context) .bodySmall.override(
                                                fontFamily: 'Outfit',
                                                color:FlutterFlowTheme.of(context).primaryText,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        if (responsiveVisibility(
                                          context: context,
                                          //phone: false,
                                          tablet: false,
                                        ))
                                          
                                        Expanded(
                                          child: Text(
                                            'Detail',
                                            textAlign: TextAlign.end,
                                              style:FlutterFlowTheme.of(context) .bodySmall.override(
                                                        fontFamily: 'Outfit',
                                                        color:FlutterFlowTheme.of(context).primaryText,
                                                      ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context).size.height * 0.5, // Adjust the height as needed
                                          child: ListView.builder(
                                            itemCount: users.length,
                                            itemBuilder: (context, index) {
                                              final user = users[index];
                                              return buildUser2(user);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.0,),
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
        ),
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Name',
    onChanged: searchUser,
  );

  void searchUser(String query) {
    final user = userList.where((user) {
    final name = user.name!.toLowerCase();
    final searchLower = query.toLowerCase();

    return name.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.users = user;
    });
  }

  Widget buildUser2(Users user) => 
    user.user_type == "host" || user.user_type == "seeker"  && user.status == true?
    Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
      child: InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HostVerificationDetailScreenWidget(user: user),
          ),
        );
        getUserList();
      },
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 2.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 0.0,
                color: FlutterFlowTheme.of(context).secondaryBackground,
                offset: Offset(0.0, 1.0),
              )
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: CachedNetworkImage(
                                fadeInDuration: Duration(milliseconds: 500),
                                fadeOutDuration: Duration(milliseconds: 500),
                                imageUrl: (image(user.image!) != "Empty")
                                    ? image(user.image!)
                                    : "https://s3.amazonaws.com/37assets/svn/765-default-avatar.png",
                                width: 40.0,
                                height: 40.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                user.name!,
                                style: FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context).customColor1,
                                  fontSize: 18.0,
                                ),
                              ),
                                // user.verification! == true ?
                                // Padding(
                                //   padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                                //   child: Text(
                                //     "Approve",
                                //     style: FlutterFlowTheme.of(context).bodySmall.override(
                                //       fontFamily: 'Outfit',
                                //       color: FlutterFlowTheme.of(context).success,
                                //     ),
                                //   ),
                                // )
                                // :
                                //   Padding(
                                //   padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                                //   child: Text(
                                //     user.request_to_verify == true ? "Pending" : "Rejected",
                                //     style: FlutterFlowTheme.of(context).bodySmall.override(
                                //       fontFamily: 'Outfit',
                                //       color: user.request_to_verify == true
                                //           ? FlutterFlowTheme.of(context).warning
                                //           : FlutterFlowTheme.of(context).error,
                                //     ),
                                //   ),
                                // ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                                  child: Text(
                                    user.is_approved == true && user.is_rejected == false
                                        ? "Approve"
                                        : user.is_approved == false && user.is_rejected == true
                                            ? "Rejected"
                                            : "Pending",
                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Outfit',
                                      color: user.is_approved == true && user.is_rejected == false
                                          ? FlutterFlowTheme.of(context).success
                                          : user.is_approved == false && user.is_rejected == true
                                              ? FlutterFlowTheme.of(context).error
                                              : FlutterFlowTheme.of(context).warning,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                                  child: Text(
                                    user.user_type! == "host" ? "Host" : "Seeker",
                                    style: FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Outfit',
                                      color: FlutterFlowTheme.of(context).customColor1,
                                    ),
                                  ),
                                ),

                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'View',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Outfit',
                        color: FlutterFlowTheme.of(context).customColor1,
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
    )
    :
    Row();
}
