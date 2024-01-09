import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'reward_list_screen_model.dart';
export 'reward_list_screen_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../reward_detail_screen/reward_detail_screen_widget.dart';

import '../../../data/models/reward_model.dart';
import '../../../search_widget.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardListScreenWidget extends StatefulWidget {
  final String uid;
  const RewardListScreenWidget({required this.uid});

  @override
  _RewardListScreenWidgetState createState() => _RewardListScreenWidgetState();
}

class _RewardListScreenWidgetState extends State<RewardListScreenWidget> {
  late RewardListScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  String query = '';
  Timer? debouncer;
  final db = FirebaseFirestore.instance;
  CollectionReference docReward = FirebaseFirestore.instance.collection('rewards');
  List<Reward> rewards = [];
  List<Reward> rewardList = [];

  @override
  void initState() {
    getRewardList();
    super.initState();
    _model = createModel(context, () => RewardListScreenModel());
    _model.searchBarController ??= TextEditingController();
    _model.searchBarFocusNode ??= FocusNode();
    init();
  }

  getRewardList() async {
    try {
      var data = await db.collection('/rewards')
      .where('status', isEqualTo: true)
      .get();

      print(data);
      print(data.docs.length);

      if (data.docs.isEmpty) {
        print('No reward available');
        return;
      }

      rewardList.clear();

      for (var doc in data.docs) {
        Reward? temp = Reward.fromDocument(doc);
        rewardList.add(temp);
      }

      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      print('Error getting reward: $error');
    }
  }

  @override
  void dispose() {
    _model.dispose();
    debouncer?.cancel();
    super.dispose();
  }

  init(){
    final list = rewardList;
    setState(() => this.rewards = list);
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
            'Reward List',
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
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            //width: MediaQuery.sizeOf(context).width * 1.0,
                            width: MediaQuery.of(context).size.width * 1.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 16.0, 0.0, 12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 8.0, 0.0),
                                    child: Text(
                                      'Reward List',
                                      style: FlutterFlowTheme.of(context)
                                          .headlineSmall,
                                    ),
                                  ),
                                  buildSearch(),
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.65,
                                    child: ListView.builder(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemCount: rewards.length,
                                      itemBuilder: (context, index) {
                                        final reward = rewards[index];
                                        return reward.quantity != "0" ?
                                          buildReward(reward)
                                          :
                                          Row();
                                      },
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
    hintText: 'Reward Name',
    onChanged: searchUser,
  );

  void searchUser(String query) {
    final reward = rewardList.where((reward) {
    final name = reward.name!.toLowerCase();
    final searchLower = query.toLowerCase();

    return name.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.rewards = reward;
    });
  }

  Widget buildReward(Reward reward) => 
    Padding(
  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
  child: InkWell(
    onTap: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RewardDetailScreenWidget(uid: widget.uid, reward: reward),
        ),
      );
      getRewardList();
    },
    child: Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(image(reward.image!)),
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
                              Color(0xB348426D)
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
                              width: 100.0,
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
                                  reward.text_status!.toString(),
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
                                      reward.name!.toString(),
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Outfit',
                                        color: FlutterFlowTheme.of(context).customColor1,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      reward.point!.toString() + ' Point Needed',
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);

}
