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
import '../../../data/models/claim_model.dart';
import '../admin_detail_screen/claim_detail.dart';
import 'claim_list_screen_model.dart';
export 'claim_list_screen_model.dart';
// import '../add_admin_screen/add_admin_screen_widget.dart';
// import '../claim_detail/claim_detail_screen_widget.dart';

class ClaimListScreenWidget extends StatefulWidget {
  const ClaimListScreenWidget({Key? key}) : super(key: key);

  @override
  _ClaimListScreenWidgetState createState() => _ClaimListScreenWidgetState();
}

class _ClaimListScreenWidgetState extends State<ClaimListScreenWidget> {
  late ClaimListScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  String query = '';
  Timer? debouncer;
  final db = FirebaseFirestore.instance;
  CollectionReference docUser = FirebaseFirestore.instance.collection('claim');
  List<Claim> claims = [];
  List<Claim> claimList = [];

  // Function to retrieve a list of claims from Firestore
  getClaimList() async {
    try {
      // Fetching data from the 'claim' collection in Firestore
      db.collection('/claim').get().then((data) {
        // Further asynchronous operations
      }).then((_) {
        // Fetching data from the 'docUser' collection in Firestore
        docUser.get().then((data) async {
          // Checking if there are documents in the collection
          if (data.docs.length < 1) {
            return;
          }

          // Clearing the existing claimList to refresh with new data
          claimList.clear();

          // Iterating through the documents and creating Claim objects
          for (var doc in data.docs) {
            Claim? temp = Claim.fromDocument(doc);
            claimList.add(temp);
          }

          // Updating the UI if the widget is still mounted
          if (mounted) setState(() {});
        });
      });
    } catch (error) {
      // Handling errors and printing an error message
      print('Error getting claim list: $error');
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
  void initState() {
    getClaimList();
    super.initState();
    _model = createModel(context, () => ClaimListScreenModel());

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
            'Claim List',
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
                                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                                    child: Text(
                                      'Claim List',
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
                                            child: Text(
                                              'Name',
                                              style:FlutterFlowTheme.of(context).bodySmall.override(
                                                        fontFamily: 'Outfit',
                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Detail',
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                  fontFamily: 'Outfit',
                                                  color: FlutterFlowTheme.of(context).primaryText,
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
                                            itemCount: claims.length,
                                            itemBuilder: (context, index) {
                                              final claim = claims[index];
                                              return buildUser2(claim);
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
    onChanged: searchClaim,
  );

  void searchClaim(String query) {
    final user = claimList.where((user) {
    final name = user.claim_by_name!.toLowerCase();
    final searchLower = query.toLowerCase();

    return name.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.claims = user;
    });
  }

  Widget buildUser2(Claim claim) => 
    Padding(
  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
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
                              imageUrl: (image(claim.user_image!) != "Empty")
                                  ? image(claim.user_image!)
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
                              claim.claim_by_name!,
                              style: FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).customColor1,
                                fontSize: 14.0,
                              ),
                            ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                                child: Text(
                                  claim.title!,
                                  overflow: TextOverflow.ellipsis,
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).customColor1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                                child: Text(
                                  claim.point_required! + " points",
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).customColor1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                                child: Text(
                                  claim.status_text!,
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
);
}
