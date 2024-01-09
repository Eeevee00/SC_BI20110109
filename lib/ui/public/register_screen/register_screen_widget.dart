import '../../flutter_flow/flutter_flow_drop_down.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'register_screen_model.dart';
export 'register_screen_model.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../service/auth.dart';
import '../../../service/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../updateLocation.dart';

class RegisterScreenWidget extends StatefulWidget {
  const RegisterScreenWidget({Key? key}) : super(key: key);

  @override
  _RegisterScreenWidgetState createState() => _RegisterScreenWidgetState();
}

class _RegisterScreenWidgetState extends State<RegisterScreenWidget> {
  late RegisterScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProcessing = false;
  final db = FirebaseFirestore.instance;
  final _registerFormKey = GlobalKey<FormState>();

  var address;
  late var userLocation = "";
  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RegisterScreenModel());
    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();
    _model.textController5 ??= TextEditingController();
    _model.textFieldFocusNode5 ??= FocusNode();

    _model.textController6 ??= TextEditingController();
    _model.textFieldFocusNode6 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  add_user() async {
    if(_model.textController4.text != _model.textController5.text){
      Alert(
        context: context,
        type: AlertType.error,
        title: "Register error",
        desc: "Both password not match",
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: const Color(0xFFFF5963),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
    else if(_model.dropDownValue == null){
      Alert(
        context: context,
        type: AlertType.error,
        title: "Register error",
        desc: "Please select user type",
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: const Color(0xFFFF5963),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
    else{
      setState(() {
        _isProcessing = true;
      });

      if (_registerFormKey.currentState!.validate()) {
        User? user = await FireAuth.registerUsingEmailPassword(
          name: _model.textController1.text,
          email: _model.textController2.text,
          password: _model.textController4.text,
          context: context,
        );

        setState(() {
          _isProcessing = false;
        });

        if (user != null) {
          await _setDataUser(
              user, _model.textController1.text, _model.textController2.text, _model.textController3.text, _model.dropDownValue, _model.textController6.text, latitude, longitude);
          Alert(
            context: context,
            type: AlertType.success,
            title: "Registration successful",
            desc: "1000 points have been credited to your account",
            buttons: [
              DialogButton(
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                color: const Color(0xFFEE8B60),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                width: 120,
              )
            ],
          ).show();
        } else {
          CollectionReference users =
              FirebaseFirestore.instance.collection('users');

          final documents = await users
              .where("email", isEqualTo: _model.textController2.text)
              .get();

          documents.docs.forEach((element) {
            if (element['status'] == false) {
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(element['uid'])
                  .set({
                'status': true,
              }, SetOptions(merge: true));
              Alert(
                context: context,
                type: AlertType.success,
                title: "Registration successful",
                desc: "1000 points have been credited to your account",
                buttons: [
                  DialogButton(
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: const Color(0xFFEE8B60),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    width: 120,
                  )
                ],
              ).show();
            } else {
              Alert(
                context: context,
                type: AlertType.error,
                title: "Register error",
                desc: "The account already exists for that email.",
                buttons: [
                  DialogButton(
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: const Color(0xFFFF5963),
                    onPressed: () => Navigator.pop(context),
                    width: 120,
                  )
                ],
              ).show();
            }
          });
        }
      }

      setState(() {
        _isProcessing = false;
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
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          iconTheme:
              IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
          automaticallyImplyLeading: true,
          title: Text(
            'Sign Up',
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
          child: SingleChildScrollView(
            child: Form(
              key: _registerFormKey,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 16.0),
                      child: Text(
                        'Please fill in all the field to register your account',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).customColor1,
                            ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 16.0),
                      child: TextFormField(
                        controller: _model.textController1,
                        focusNode: _model.textFieldFocusNode1,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter user name',
                          hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                          labelStyle: TextStyle( // Add this block for label text style
                            color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryBackground,
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
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null; // Return null if validation succeeds
                            },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                      child: TextFormField(
                        controller: _model.textController2,
                        focusNode: _model.textFieldFocusNode2,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'Enter user  email address',
                          hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                          labelStyle: TextStyle( // Add this block for label text style
                            color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryBackground,
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
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            }
                            // Use a regex pattern for email validation
                            String emailRegex =
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                            RegExp regex = RegExp(emailRegex);
                            if (!regex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null; // Return null if validation succeeds
                          },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                      child: TextFormField(
                        controller: _model.textController3,
                        focusNode: _model.textFieldFocusNode3,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter user phone number',
                          hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                          labelStyle: TextStyle( // Add this block for label text style
                            color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryBackground,
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
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number';
                            }
                            return null; // Return null if validation succeeds
                          },
                      ),
                    ),

                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                      child: TextFormField(
                        controller: _model.textController6,
                        focusNode: _model.textFieldFocusNode6,
                        obscureText: false,
                        onTap: () async {
                          address = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Test(userLocation),
                            ),
                          );

                          if (address != null) {
                            setState(() {
                              print(address['PlaceName']);
                              print(address['latitude']);
                              print(address['longitude']);
                              // address = address['PlaceName'];
                              latitude = address['latitude'];
                              longitude = address['longitude'];
                              //userLocation = address['PlaceName'];
                            });
                            _model.textController6.text = address['PlaceName'];
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Your Address',
                          hintText: 'Enter your address',
                          hintStyle: FlutterFlowTheme.of(context).bodyLarge,
                          labelStyle: TextStyle( // Add this block for label text style
                            color: FlutterFlowTheme.of(context).primaryText, // Set the color you want
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primaryBackground,
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
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number';
                            }
                            return null; // Return null if validation succeeds
                          },
                      ),
                    ),
                    SizedBox(
                      height: 80, // Adjust the height as needed
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                        child: FlutterFlowDropDown<String>(
                          controller: _model.dropDownValueController ??=
                              FormFieldController<String>(null),
                          options: ['Seeker', 'Host'],
                          onChanged: (val) =>
                              setState(() => _model.dropDownValue = val),
                          width: double.infinity,
                          height: 50.0,
                          textStyle: FlutterFlowTheme.of(context).bodyMedium,
                          hintText: 'Please select user type',
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                          fillColor: FlutterFlowTheme.of(context).primaryBackground,
                          elevation: 2.0,
                          borderColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                          borderWidth: 2.0,
                          borderRadius: 8.0,
                          margin:
                              EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                          hidesUnderline: true,
                          isSearchable: false,
                          isMultiSelect: false,
                        ),
                      ),
                    ),
                    Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                          child: TextFormField(
                            controller: _model.textController4,
                            focusNode: _model.textFieldFocusNode4,
                            obscureText: !_model.passwordVisibility1,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter password',
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
                              suffixIcon: InkWell(
                                onTap: () => setState(
                                  () => _model.passwordVisibility1 =
                                      !_model.passwordVisibility1,
                                ),
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                  _model.passwordVisibility1
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  size: 22.0,
                                ),
                              ),
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null; // Return null if validation succeeds
                            },
                          ),
                        ),
                    Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                          child: TextFormField(
                            controller: _model.textController5,
                            focusNode: _model.textFieldFocusNode5,
                            obscureText: !_model.passwordVisibility2,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              hintText: 'Enter password',
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
                              suffixIcon: InkWell(
                                onTap: () => setState(
                                  () => _model.passwordVisibility2 =
                                      !_model.passwordVisibility2,
                                ),
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                  _model.passwordVisibility2
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  size: 22.0,
                                ),
                              ),
                            ),
                            style: FlutterFlowTheme.of(context).bodyMedium,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null; // Return null if validation succeeds
                            },
                          ),
                        ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                      child: FFButtonWidget(
                        onPressed: () async {
                          if (_registerFormKey.currentState?.validate() ?? false) {
                            await add_user();
                          }
                        },
                        text: 'Register',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 55.0,
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          iconPadding:
                              EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primaryText,
                          textStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    fontSize: 14.0,
                                  ),
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


Future _setDataUser(User? user, name, email, phone, user_type, address, latitude, longitude) async {
  await FirebaseFirestore.instance.collection("users").doc(user?.uid).set(
    {
      'email': email,
      'image': ['Empty'], 
      'name': name,
      'phone': phone,
      'pushToken': "",
      'uid': user?.uid,
      'user_type': user_type.toLowerCase(),
      'status': true,
      'location': {
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
      },
      'verification': false,
      'request_to_verify': false,
      'proof_for_verification_1': ['Empty'], 
      'proof_for_verification_2': ['Empty'], 
      'points': 1000,
      'total_point': 1000,
      'bio': "",
      'hashtag': [],
      'tier': "Bronze",
    },
    SetOptions(merge: true)
  );
}