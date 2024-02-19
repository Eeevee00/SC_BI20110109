import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notification_list_screen_model.dart';
export 'notification_list_screen_model.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../../../data/models/notification_model.dart';
import '../../../search_widget.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/skeleton_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notification_detail/notification_detail_widget.dart';
import 'package:intl/intl.dart';

class NotificationListScreenWidget extends StatefulWidget {
  final String uid;
  const NotificationListScreenWidget({required this.uid});

  @override
  _NotificationListScreenWidgetState createState() =>
      _NotificationListScreenWidgetState();
}

class _NotificationListScreenWidgetState
    extends State<NotificationListScreenWidget> {
  late NotificationListScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String query = '';
  Timer? debouncer;
  final db = FirebaseFirestore.instance;
  CollectionReference docNotification = FirebaseFirestore.instance.collection('notification');
  List<Notifications> notifications = [];
  List<Notifications> notificationList = [];

  @override
  void initState() {
    getNotificationList();
    super.initState();
    _model = createModel(context, () => NotificationListScreenModel());
    init();
  }

  @override
  void dispose() {
    _model.dispose();
    debouncer?.cancel();
    super.dispose();
  }

  getNotificationList() async {
    var user_uid = widget.uid;
    try {
      var data = await db.collection('users').doc(user_uid).collection('notification').get();

      if (data.docs.isEmpty) {
        init();
        notificationList.clear();
        print('No notifications available');
        return;
      }

      notificationList.clear();

      for (var doc in data.docs) {
        Notifications? temp = Notifications.fromDocument(doc);
        notificationList.add(temp);
      }

      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      print('Error getting notifications: $error');
    }
  }
    
  init(){
    final list = notificationList;
    setState(() => this.notifications = list);
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

  String formatTimestamp(Timestamp timestamp) {
    if (timestamp == null) {
      return '';
    }

    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    
    return formattedDate;
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
            'Notification List',
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
                            //width: MediaQuery.sizeOf(context).width * 1.0,
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
                                    'Notification List',
                                    style: FlutterFlowTheme.of(context).headlineSmall.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),

                                  ),
                                  buildSearch(),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 6.0, 12.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Name',
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                ),
                                          ),
                                        ),
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
                                                      .primaryText,
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
                                          height: MediaQuery.of(context).size.height * 0.45, // Adjust the height as needed
                                          child: ListView.builder(
                                            itemCount: notifications.length,
                                            itemBuilder: (context, index) {
                                              final noti = notifications[index];
                                              return buildNotification(noti);
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
    hintText: 'Title',
    onChanged: searchNotification,
  );

  void searchNotification(String query) {
    final notify = notificationList.where((notify) {
    final title = notify.title!.toLowerCase();
    final searchLower = query.toLowerCase();

    return title.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.notifications = notify;
    });
  }

  Widget buildNotification(Notifications noti) => 
    Padding(
  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
  child: InkWell(
    onTap: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationDataDetailScreenWidget(uid: widget.uid, notification: noti),
        ),
      );
      getNotificationList();
    },
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
                            noti.title,
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context).customColor1,
                                  fontSize: 18.0,
                                ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                            child: Text(
                              formatTimestamp(noti.timestamp),
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
);

}
