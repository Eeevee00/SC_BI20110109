import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'profile_model.dart';
export 'profile_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../data/models/user_model.dart';
import '../../../data/models/shared_pref.dart';
import '../../editprofile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late ProfileModel _model;

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
  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    _initializeFirebase();
    super.initState();
    _model = createModel(context, () => ProfileModel());

    _model.nameFieldController ??= TextEditingController();
    _model.emailFieldController ??= TextEditingController();
    _model.phoneFieldController ??= TextEditingController();
    _model.iCFieldController ??= TextEditingController();
  }

  Future updateData() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set({
            'name': _model.nameFieldController.text, 
            'email': _model.emailFieldController.text, 
            'phone': _model.phoneFieldController.text, 
        },SetOptions(merge: true));
    currentUser.name = _model.nameFieldController.text;
    currentUser.email = _model.emailFieldController.text;
    currentUser.phone = _model.phoneFieldController.text;
    _getCurrentUser();
  }

  _getCurrentUser() async {
    sharedPref.save("user", currentUser);
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
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
        _model.nameFieldController.text = currentUser.name!;
        _model.emailFieldController.text = currentUser.email!;
        _model.phoneFieldController.text = currentUser.phone!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        iconTheme:
            IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
        automaticallyImplyLeading: true,
        title: Text(
          'Admin Detail',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Outfit',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                    child: SingleChildScrollView(
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
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 14.0, 0.0, 0.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 5.0,
                                              color: Color(0x4D101213),
                                              offset: Offset(0.0, 2.0),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: TextFormField(
                                          controller:
                                              _model.nameFieldController,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Name',
                                            hintText: 'Enter fullname',
                                            hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                                            labelStyle: TextStyle( // Add this block for label text style
                                            color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context).primaryBackground,
                                                width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).primaryText,
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
                                            fillColor:
                                                FlutterFlowTheme.of(context).primaryBackground,
                                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                                20.0, 24.0, 20.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily),
                                              ),
                                          maxLines: null,
                                          validator: _model
                                              .nameFieldControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 14.0, 0.0, 0.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 5.0,
                                              color: Color(0x4D101213),
                                              offset: Offset(0.0, 2.0),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: TextFormField(
                                          readOnly: true,
                                          controller:
                                              _model.emailFieldController,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            hintText: 'Enter email',
                                            hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                                            labelStyle: TextStyle( // Add this block for label text style
                                            color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context).primaryBackground,
                                                width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).primaryText,
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
                                            fillColor:
                                                FlutterFlowTheme.of(context).primaryBackground,
                                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                                20.0, 24.0, 20.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily),
                                              ),
                                          maxLines: null,
                                          validator: _model
                                              .emailFieldControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 14.0, 0.0, 0.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 5.0,
                                              color: Color(0x4D101213),
                                              offset: Offset(0.0, 2.0),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: TextFormField(
                                          controller:
                                              _model.phoneFieldController,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            labelText: 'Phone',
                                            hintText: 'Enter phone number',
                                            hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                                            labelStyle: TextStyle( // Add this block for label text style
                                            color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    FlutterFlowTheme.of(context).primaryBackground,
                                                width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(5.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: FlutterFlowTheme.of(context).primaryText,
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
                                            fillColor:
                                                FlutterFlowTheme.of(context).primaryBackground,
                                            contentPadding: EdgeInsetsDirectional.fromSTEB(
                                                20.0, 24.0, 20.0, 24.0),
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily),
                                              ),
                                          maxLines: null,
                                          validator: _model
                                              .phoneFieldControllerValidator
                                              .asValidator(context),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 24.0, 0.0, 20.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          updateData();
                                          Alert(
                                            context: context,
                                            type: AlertType.success,
                                            title: "",
                                            desc: "Update profile successfully",
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
                                        },
                                        text: 'Save Detail',
                                        options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 50.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            textStyle:
                                                FlutterFlowTheme.of(context).titleSmall.override(
                                                    fontFamily: 'Outfit',
                                                    color: FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
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
      ),
    );
  }
}
