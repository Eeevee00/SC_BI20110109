import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

import 'dart:ui';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../search_widget.dart';
import '../../screens/skeleton_screen.dart';
import '../../../data/models/event_model.dart';
import 'dart:math' as math;
import '../event_detail_2/event_detail_host_widget.dart';
import 'event_list_model.dart';
export 'event_list_model.dart';

class PublicEventListScreenWidget extends StatefulWidget {
  const PublicEventListScreenWidget({Key? key}) : super(key: key);

  @override
  _PublicEventListScreenWidgetState createState() =>
      _PublicEventListScreenWidgetState();
}

class _PublicEventListScreenWidgetState
    extends State<PublicEventListScreenWidget> {
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

  // Function to calculate the distance between two geographical points using Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Earth's radius in kilometers
    const double radiusOfEarth = 6371;

    // Function to calculate haversine value
    double haversine(double theta) {
      return math.sin(theta / 2) * math.sin(theta / 2);
    }

    // Function to calculate haversine formula
    double haversineFormula(double dLat, double dLon) {
      return haversine(dLat) + math.cos(lat1) * math.cos(lat2) * haversine(dLon);
    }

    // Calculate the distance using Haversine formula
    double distance = 2 * math.asin(math.sqrt(haversineFormula(lat2 - lat1, lon2 - lon1)));

    // Return the calculated distance
    return radiusOfEarth * distance;
  }


  // Fetches events and filters them based on user's location
  Future<void> getEventList() async {
    // Retrieve user's location from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userLatitude = prefs.getDouble("user_latitude");
    var userLongitude = prefs.getDouble("user_longitude");

    try {
      // Retrieve events from Firestore
      //var data = await db.collection('/event').get();
      var data = await db.collection('/event').where('status', isEqualTo: true).get();

      // Check if there are no events available
      if (data.docs.isEmpty) {
        print('No event available');
        return;
      }

      // Clear the existing event list
      eventList.clear();

      // Iterate through each event document
      for (var doc in data.docs) {
        // Convert Firestore document to Event object
        Event? temp = Event.fromDocument(doc);

        // Extract latitude and longitude from the event's location map
        var eventLatitude = temp?.location!['latitude'];
        var eventLongitude = temp?.location!['longitude'];

        // Check if location data is available
        if (eventLatitude != null && eventLongitude != null) {
          // Calculate the distance between user and event
          double distance = calculateDistance(
            userLatitude!,
            userLongitude!,
            eventLatitude,
            eventLongitude,
          );
          print(distance);

          // Check if the event is within the specified radius (50 km)
          //if (distance <= 50) {
            eventList.add(temp);
          //}
        }
      }

      // Update the UI if the widget is still mounted
      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      // Handle errors during event retrieval
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
            'Event List',
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
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            //width: MediaQuery.sizeOf(context).width * 1.0,
                            width: MediaQuery.of(context).size.width * 1.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).secondaryBackground,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                                    child: Text(
                                      'Event List',
                                      style: FlutterFlowTheme.of(context).headlineSmall,
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

 //UI of how event listtile look
  Widget buildEvent(Event event) => 
  Padding(
    padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 0.0), // Size of container 
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

    child: Stack(
      children: [
      //The whole container
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
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
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
            child: Flexible(

              child: Container(
                width: double.infinity,
                height: 190.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.network('',).image,
                  ),
                  borderRadius:BorderRadius.circular(24.0),
                ),

                  child: Stack(
                    children: [
                      //Photo as bg
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

                    // Gradient Container
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              FlutterFlowTheme.of(context).primaryBackground.withOpacity(1.0),
                            ],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(0.0, -1.0),
                            end: AlignmentDirectional(0, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),

                    //The details
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              //Event title
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                                child: Row(
                                  mainAxisSize:MainAxisSize.max,
                                  children: [
                                    Icon(Icons.event_rounded,
                                      color: FlutterFlowTheme.of(context).customColor1,
                                      size: 24.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        event.title!,
                                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                                              fontFamily:'Outfit',
                                              color: FlutterFlowTheme.of(context).customColor1,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //Event description
                              Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                  child: Text(
                                    event.description!,
                                    textAlign:TextAlign.start,
                                    maxLines: 2,
                                    style: FlutterFlowTheme.of(context).labelMedium.override(
                                          fontFamily:'Outfit',
                                          color: FlutterFlowTheme.of(context).customColor1,
                                        ),
                                  ),
                              ),

                              // Time
                              Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize:MainAxisSize.max,
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Time',
                                      style: FlutterFlowTheme.of(context).labelMedium.override(
                                            fontFamily:'Outfit',
                                            color: FlutterFlowTheme.of(context).customColor1,
                                          ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 4.0, 0.0),
                                        child: Text(
                                          event.start_time! + " - " + event.end_time!,
                                          style: FlutterFlowTheme.of(context).labelMedium.override(
                                                fontFamily:'Outfit',
                                                color: FlutterFlowTheme.of(context).customColor1,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ),

                              //Date
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize:MainAxisSize.max,
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Date',
                                    style: FlutterFlowTheme.of(context).labelMedium.override(
                                          fontFamily:'Outfit',
                                          color: FlutterFlowTheme.of(context).customColor1,
                                        ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 4.0, 0.0),
                                      child: Text(
                                        formatTimestamp(event.start_date) + " - " + formatTimestamp(event.end_date),
                                        style: FlutterFlowTheme.of(context).labelMedium.override(
                                              fontFamily:'Outfit',
                                              color: FlutterFlowTheme.of(context).customColor1,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //Location
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize:MainAxisSize.max,
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Location',
                                    style: FlutterFlowTheme.of(context).labelMedium.override(
                                          fontFamily:'Outfit',
                                          color: FlutterFlowTheme.of(context).customColor1,
                                        ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 4.0, 0.0),
                                                child: Text(
                                                            event.location?['address'],
                                                            textAlign: TextAlign.end,
                                                            maxLines: 2,
                                                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                                                  fontFamily:'Outfit',
                                                                  color: FlutterFlowTheme.of(context).customColor1,
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

                    ],
                  ),

            ),//349
          ),
        ),
      ),//332

      //Status: Active /inactive 
      Positioned(
        top: 0.0,
        right: 00.0,
        child: Container(
          width: 70.0,
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
            event.status! ? 'Active' : 'Inactive',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Outfit',
                color: FlutterFlowTheme.of(context).primaryText,
                fontSize: 12.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),

      ],
    ),

    ),
  ); 

}
