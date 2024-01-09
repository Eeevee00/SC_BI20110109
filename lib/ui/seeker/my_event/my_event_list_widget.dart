import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'event_list_model.dart';
export 'event_list_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import '../../../data/models/event_model.dart';
import '../../../search_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/skeleton_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../feedback_detail_screen/feedback_detail_screen_widget.dart';
import 'package:intl/intl.dart';

import '../event_detail/event_detail_host_widget.dart';

class MyEventListScreenWidget extends StatefulWidget {
  const MyEventListScreenWidget({Key? key}) : super(key: key);

  @override
  _PublicEventListScreenWidgetState createState() =>
      _PublicEventListScreenWidgetState();
}

class _PublicEventListScreenWidgetState
    extends State<MyEventListScreenWidget> {
  late PublicEventListScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  String query = '';
  Timer? debouncer;
  final db = FirebaseFirestore.instance;
  CollectionReference docEvent = FirebaseFirestore.instance.collection('event');
  List<Event> events = [];
  List<Event> eventList = [];

  @override
  void initState() {
    getEventList();
    super.initState();
    _model = createModel(context, () => PublicEventListScreenModel());
    init();
  }

  @override
  void dispose() {
    _model.dispose();
    debouncer?.cancel();
    super.dispose();
  }

  getEventList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user_uid = prefs.getString("current_user_uid");
    try {
      var eventQuery = await db.collection('/event').get();

      if (eventQuery.docs.isEmpty) {
        print('No events available');
        return;
      }

      eventList.clear();

      for (var eventDoc in eventQuery.docs) {
        var participantQuery = await eventDoc.reference.collection('participant').where('uid', isEqualTo: user_uid).get();

        if (participantQuery.docs.isNotEmpty) {
          // If the participant with user_uid is found in the subcollection
          Event? temp = Event.fromDocument(eventDoc);
          eventList.add(temp);
        }
      }

      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      print('Error getting events: $error');
    }
  }
    
  init(){
    final list = eventList;
    setState(() => this.events = list);
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
            'Event Join',
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
                                      'Event Join',
                                      style: FlutterFlowTheme.of(context)
                                          .headlineSmall,
                                    ),
                                  ),
                                  buildSearch(),
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context).size.height * 0.63,
                                          child: ListView.builder(
                                            itemCount: events.length,
                                            itemBuilder: (context, index) {
                                              final noti = events[index];
                                              return buildEvent(noti);
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
    hintText: 'Event Name or Location',
    onChanged: searchEvent,
  );

  void searchEvent(String query) {
    final notify = eventList.where((notify) {
    final title = notify.title!.toLowerCase();
    final address = notify.location!['address']!.toLowerCase();
    final searchLower = query.toLowerCase();

    return title.contains(searchLower) || address.contains(searchLower) ;
    }).toList();

    setState(() {
      this.query = query;
      this.events = notify;
    });
  }

  Widget buildEvent(Event event) => 
    Padding(
  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
  child: InkWell(
    onTap: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailHostWidget(event: event),
        ),
      );
      getEventList();
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
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 16.0),
                                        child: Container(
                                          width: double.infinity,
                                          height: 260.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              
                                              image: Image.network(
                                                '',
                                              ).image,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                          child: Stack(
                                            children: [
                                                ClipRRect(
                                                    borderRadius: BorderRadius.circular(12.0), // Adjust the radius as needed
                                                    child: ImageFiltered(
                                                        imageFilter: ImageFilter.blur(
                                                        sigmaX: 5.0,
                                                        sigmaY: 5.0,
                                                        ),
                                                        child: Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        decoration: BoxDecoration(
                                                            color: FlutterFlowTheme.of(context).secondaryBackground,
                                                            borderRadius: BorderRadius.circular(12.0), // Make sure to match the outer radius
                                                            image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: CachedNetworkImageProvider(image(event.image!)),
                                                            ),
                                                        ),
                                                        ),
                                                    ),
                                                ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(12.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(16.0),
                                                  
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    12.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .event_rounded,
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
                                                                event.title!,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
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
                                                            event.description!,
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 2,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
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
                                                      Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Location',
                                                              style: FlutterFlowTheme.of(context).labelSmall.override(
                                                                fontFamily: 'Outfit',
                                                                color: FlutterFlowTheme.of(context).customColor1,
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child: Padding(
                                                                padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 4.0, 0.0),
                                                                child: Text(
                                                                  event.location!['address']!,
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  textAlign: TextAlign.right, // Align the text to the right
                                                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                    fontFamily: 'Outfit',
                                                                    color: FlutterFlowTheme.of(context).customColor1,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        16.0,
                                                                        0.0,
                                                                        0.0),
                                                            child:
                                                                FFButtonWidget(
                                                              onPressed: () async {
                                                                await Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => EventDetailHostWidget(event: event),
                                                                  ),
                                                                );
                                                                getEventList();
                                                              },
                                                              text: 'Detail',
                                                              options:
                                                                  FFButtonOptions(
                                                                width: 150.0,
                                                                height: 44.0,
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                iconPadding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                textStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          'Outfit',
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                    ),
                                                                elevation: 0.0,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
    ),
  ),
);

}
