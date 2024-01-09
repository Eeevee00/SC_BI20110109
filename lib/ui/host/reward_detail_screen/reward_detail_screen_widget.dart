import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../data/models/reward_model.dart';
import 'reward_detail_screen_model.dart';
export 'reward_detail_screen_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RewardDetailScreenWidget extends StatefulWidget {
  final String uid;
  final Reward reward;
  const RewardDetailScreenWidget({required this.reward, required this.uid});

  @override
  _RewardDetailScreenWidgetState createState() =>
      _RewardDetailScreenWidgetState();
}

class _RewardDetailScreenWidgetState extends State<RewardDetailScreenWidget> {
  late RewardDetailUserModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  var point = 0;
  var name = "";

  @override
  void initState() {
    getUserDetails();
    super.initState();
    _model = createModel(context, () => RewardDetailUserModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  image(pictures){
    var list = pictures;
    var stringList = list.join("");

    return stringList;
  }

  getUserDetails() async {
    try {
      CollectionReference<Map<String, dynamic>> usersCollection =
          FirebaseFirestore.instance.collection('/users');

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await usersCollection.doc(widget.uid).get();

      if (userSnapshot.exists) {
        setState(() {
          name = userSnapshot['name'];
          point = userSnapshot['points'];
        });
      } else {
        print('User with UID $widget.uid not found.');
      }
    } catch (error) {
      print('Error getting user details: $error');
      return {};
    }
  }

  checkUserPoint(){

  }

  Future<bool> updateUserPoint(int pointsToDeduct)async{
    try {
      CollectionReference<Map<String, dynamic>> usersCollection =
          FirebaseFirestore.instance.collection('/users');

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await usersCollection.doc(widget.uid).get();

      if (userSnapshot.exists) {
        int currentPoints = userSnapshot['points'];

        if (currentPoints >= pointsToDeduct) {
          int updatedPoints = currentPoints - pointsToDeduct;

          await usersCollection.doc(widget.uid).update({
            'points': updatedPoints,
          });

          print('Points deducted successfully. New points: $updatedPoints');
          return true;
        } else {
          print('Insufficient points. User has $currentPoints points, but $pointsToDeduct points are required.');
          return false;
        }
      } else {
        print('User with UID $widget.uid not found.');
      }
    } catch (error) {
      print('Error deducting points: $error');
      return false;
    }
    return false;
  }

  Future<void> updateRewardQuantity()async{
    try {
      CollectionReference<Map<String, dynamic>> rewardCollection =
          FirebaseFirestore.instance.collection('rewards');

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await rewardCollection.doc(widget.reward.uid).get();

      if (userSnapshot.exists) {
        int currentQuantity = int.parse(userSnapshot['quantity']);
        int updatedQuantity = currentQuantity - 1;

        await rewardCollection.doc(widget.reward.uid).update({
          'quantity': updatedQuantity.toString(),
        });
      }
      else{
      }
    } catch (error) {
      print('Error deducting quantity: $error');
    }
  }

  Future<void> createClaimRecord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      CollectionReference<Map<String, dynamic>> claimCollection =
          FirebaseFirestore.instance.collection('claim');

      var result = await updateUserPoint(int.parse(widget.reward.point!));
      if(result == false){
        Alert(
            context: context,
            type: AlertType.error,
            title: "Reward Claim",
            desc: "Failed to claim reward, you dont have enough point to claim.",
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
                  Navigator.pop(context);
                },
                width: 120,
              )
            ],
          ).show();
      }else{
        updateRewardQuantity();
        DocumentReference<Map<String, dynamic>> newClaimRef =
          await claimCollection.add({
            'claim_by_uid': widget.uid,
            'claim_by_name': prefs.getString("current_user_name"),
            'point_required': widget.reward.point,
            'status': true,
            'title': widget.reward.name,
            'timestamp': FieldValue.serverTimestamp(),
            'uid': "",
            'user_image': [prefs.getString("current_user_image")],
            'reward_uid': widget.reward.uid,
            'status_text': "Approve",
          });

          String newClaimId = newClaimRef.id;

          await newClaimRef.update({'uid': newClaimId});

          Alert(
            context: context,
            type: AlertType.success,
            title: "Reward Claim",
            desc: "Successfully claim this reward, admin will contact you to get your reward.",
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
                  Navigator.pop(context);
                },
                width: 120,
              )
            ],
          ).show();
      }
    } catch (error) {
      print('Error creating claim record: $error');
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
            'Reward_detail',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Outfit',
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 20, 16, 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 20),
                    child: Text(
                      'Reward Detail',
                      style:
                          FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        fadeInDuration: Duration(milliseconds: 500),
                        fadeOutDuration: Duration(milliseconds: 500),
                        imageUrl: image(widget.reward.image),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            'Reward Name',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
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
                          padding: EdgeInsets.all(4),
                          child: Text(
                            widget.reward.name.toString(),
                            maxLines: 2,
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).customColor1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
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
                          padding: EdgeInsets.all(4),
                          child: Text(
                            'Point to Claim',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
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
                          padding: EdgeInsets.all(4),
                          child: Text(
                            widget.reward.point.toString() + " point to claim",
                            maxLines: 2,
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).customColor1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
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
                          padding: EdgeInsets.all(4),
                          child: Text(
                            'Awailable Quantity to Claim',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
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
                          padding: EdgeInsets.all(4),
                          child: Text(
                            widget.reward.quantity.toString(),
                            maxLines: 2,
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).customColor1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
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
                          padding: EdgeInsets.all(4),
                          child: Text(
                            'Description',
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
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
                          padding: EdgeInsets.all(4),
                          child: Text(
                            widget.reward.description.toString(),
                            maxLines: 2,
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).customColor1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
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
                          padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                          child: FFButtonWidget(
                            onPressed: () async {
                              await createClaimRecord();
                            },
                            text: 'Claim This Reward',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 50,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).primaryText,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    fontSize: 16,
                                  ),
                              elevation: 3,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                            ),
                          ),
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
    );
  }
}
