import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'claim_list_user_model.dart';
export 'claim_list_user_model.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import '../../../data/models/claim_model.dart';
import '../../../search_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../admin/admin_detail_screen/claim_detail.dart';
import '../reward_list/reward_list_screen_widget.dart';

class ClaimListUserWidget extends StatefulWidget {
  final String uid;
  const ClaimListUserWidget({required this.uid});

  @override
  _ClaimListUserWidgetState createState() => _ClaimListUserWidgetState();
}

class _ClaimListUserWidgetState extends State<ClaimListUserWidget> {
  late ClaimListUserModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String query = '';
  Timer? debouncer;
  final db = FirebaseFirestore.instance;
  List<Claim> claims = [];
  List<Claim> claimList = [];

  @override
  void initState() {
    getClaimList();
    super.initState();
    _model = createModel(context, () => ClaimListUserModel());
    _model.emailAddressController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();
    init();
  }

  String formatTimestamp(Timestamp timestamp) {
    if (timestamp == null) {
      return '';
    }

    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    
    return formattedDate;
  }

  @override
  void dispose() {
    _model.dispose();
    debouncer?.cancel();
    super.dispose();
  }

  getClaimList() async {
    try {
      var data = await db.collection('/claim')
      .where('claim_by_uid', isEqualTo: widget.uid)
      .get();

      if (data.docs.isEmpty) {
        print('No claim available');
        return;
      }

      claims.clear();

      for (var doc in data.docs) {
        Claim? temp = Claim.fromDocument(doc);
        claims.add(temp);
      }

      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      print('Error getting claim: $error');
    }
  }

  init(){
    final list = claimList;
    setState(() => this.claims = list);
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
            'Claim List',
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
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RewardListScreenWidget(uid:widget.uid),
                              ),
                            );
                            getClaimList();
                          },
                          text: 'See All Reward List',
                          options: FFButtonOptions(
                            width: 130.0,
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primaryText,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                ),
                            elevation: 2.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                                  0.0, 16.0, 0.0, 12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8.0, 0.0, 8.0, 0.0),
                                    child: Text(
                                      'My Claim',
                                      style: FlutterFlowTheme.of(context)
                                          .headlineSmall,
                                    ),
                                  ),
                                  buildSearch(),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 12.0, 12.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Claim',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .customColor1,
                                                ),
                                          ),
                                        ),
                                        if (responsiveVisibility(
                                          context: context,
                                          phone: false,
                                          tablet: false,
                                        ))
                                        Expanded(
                                          child: Text(
                                            'Detail',
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .customColor1,
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
                                          height: MediaQuery.of(context).size.height * 0.5,
                                          child: ListView.builder(
                                            itemCount: claims.length,
                                            itemBuilder: (context, index) {
                                              final noti = claims[index];
                                              return buildClaim(noti);
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
    hintText: 'Claim Name',
    onChanged: searchClaim,
  );

  void searchClaim(String query) {
    final notify = claimList.where((notify) {
    final title = notify.title!.toLowerCase();
    final searchLower = query.toLowerCase();

    return title.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.claims = notify;
    });
  }

  Widget buildClaim(Claim claim) => 
    Padding(
  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
  child: InkWell(
    onTap: () async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailScreenWidget(claim: claim),
        ),
      );
      getClaimList();
    },
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius:
                                                                BorderRadius.circular(12.0),
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
  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
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
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            claim.title!,
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                              fontFamily: 'Outfit',
                              color: FlutterFlowTheme.of(context).customColor1,
                              fontSize: 18.0,
                            ),
                          ),
                          if (responsiveVisibility(
                            context: context,
                            tabletLandscape: false,
                            desktop: false,
                          ))
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                2.0,
                                0.0,
                                0.0,
                              ),
                              child: Text(
                                claim.status == true ? "Complete" : "Pending",
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context).customColor1,
                                ),
                              ),
                            ),
                          if (responsiveVisibility(
                            context: context,
                            tabletLandscape: false,
                            desktop: false,
                          ))
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                2.0,
                                0.0,
                                0.0,
                              ),
                              child: Text(
                                formatTimestamp(claim.timestamp),
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
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
                  style: FlutterFlowTheme.of(context)
                      .bodyMedium
                      .override(
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

    ),
  ),
);
}
