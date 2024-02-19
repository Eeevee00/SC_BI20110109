import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'event_detail_host_model.dart';
export 'event_detail_host_model.dart';
import 'dart:async';
import '../../../data/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../applicant_list/applicant_list_widget.dart';

import '../review_event/review.dart';
import '../ticket_list/ticket_list_screen_widget.dart';

import '../edit_event/edit_event_form_widget.dart';


class EventDetailHostWidget extends StatefulWidget {
  final Event event;
  const EventDetailHostWidget({required this.event});

  @override
  _EventDetailHostWidgetState createState() => _EventDetailHostWidgetState();
}

class _EventDetailHostWidgetState extends State<EventDetailHostWidget> {
  late EventDetailHostModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  var status = false;
  var _image;
  var title;
  var start_date;
  var end_date;
  var start_time;
  var end_time;
  var address;
  var name;
  var phone;
  var email;
  var description;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EventDetailHostModel());
    status = widget.event.status!;
    _image = widget.event.image;
    title = widget.event.title!;
    start_date = widget.event.start_date;
    end_date = widget.event.end_date;
    start_time = widget.event.start_time!;
    end_time = widget.event.end_time!;
    address = widget.event.location!['address'];
    name = widget.event.organizer_name!;
    phone = widget.event.phone!;
    email = widget.event.organizer_email!;
    description = widget.event.description!;
  }

  image(pictures){
    var list = pictures;
    var stringList = list.join("");
    return stringList;
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
    super.dispose();
  }

  getEventDetail() async {
    var event_uid = widget.event.uid;

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Assuming 'tickets' is the collection and 'ticket_uid' is the document ID
      DocumentSnapshot eventDoc = await firestore.doc('/event/$event_uid').get();

      if (eventDoc.exists) {
        // Access the data from the document
        Map<String, dynamic> eventData = eventDoc.data() as Map<String, dynamic>;

        setState(() {
          _image = eventData['image'];
          title = eventData['title'];
          start_date = eventData['start_date'];
          end_date = eventData['end_date'];
          start_time = eventData['start_time'];
          end_time = eventData['end_time'];
          address = eventData['location']['address'];
          name = eventData['organizer_name'];
          phone = eventData['phone'];
          email = eventData['organizer_email'];
          description = eventData['description'];
        });
      } else {
        print('Ticket document does not exist');
      }
    } catch (error) {
      print('Error fetching ticket details: $error');
    }
  }

  void deleteEvent() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Delete Event",
      desc: "Are you sure you want to delete this event?",
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        DialogButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            Navigator.pop(context);

            await FirebaseFirestore.instance.collection('event').doc(widget.event.uid).delete();

            Alert(
              context: context,
              type: AlertType.success,
              title: "Event Deleted",
              desc: "The event has been successfully deleted.",
              buttons: [
                DialogButton(
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ).show();
          },
        ),
      ],
    ).show();
  }


  void changeStatusEvent(bool currentStatus) async {
    bool newStatus = !currentStatus;

    try {
      await FirebaseFirestore.instance.collection('event').doc(widget.event.uid).update({
        'status': newStatus,
      });

      String statusMessage = newStatus ? "active" : "inactive";
      setState(() {
          status = newStatus;
      });

      // Show a success message
      Alert(
        context: context,
        type: AlertType.success,
        title: "Status Updated",
        desc: "The event is now $statusMessage.",
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ).show();
    } catch (error) {
      // Show an error message if update fails
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: "Failed to update event status. Please try again.",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ).show();
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
          // title: Text(
          //   'Event Detail',
          //   style: FlutterFlowTheme.of(context).bodyMedium.override(
          //         fontFamily: 'Outfit',
          //         color: FlutterFlowTheme.of(context).primaryText,
          //         fontSize: 20.0,
          //         fontWeight: FontWeight.w500,
          //       ),
          // ),

          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Event Detail',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'updateEvent',
                    child: Text('Update Event'),
                  ),
                  PopupMenuItem<String>(
                    value: 'deleteEvent',
                    child: Text('Delete Event'),
                  ),
                ],
                onSelected: (String choice) async {
                  if (choice == 'updateEvent') {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditEventFormWidget(event: widget.event),
                      ),
                    );
                    getEventDetail();
                  } else if (choice == 'deleteEvent') {
                    deleteEvent();                       
                  }
                },
              ),
            ],
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
              children: [
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      image(_image),
                      width: double.infinity,
                      height: 240.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        //Title
                        Text(
                          title.toString(),
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                                fontFamily: 'Outfit',
                                color: FlutterFlowTheme.of(context).customColor1,
                                fontWeight: FontWeight.w800,
                                fontSize:30,
                              ),
                        ),

                        //Description
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 20.0),
                          child: Text(
                            widget.event.description!,
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'Outfit',
                                  color:
                                      FlutterFlowTheme.of(context).customColor1,
                                 fontSize: 15,

                                ),
                          ),
                        ),

                      // Host Detail - image, name, phone, email
                      Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(12.0), // Adjust the border radius as needed
                          ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 8.0, 0.0, 10.0),
                            //Left :Image
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 20.0, 0.0),
                                //Image
                                child: 
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          4.0, 0.0, 0.0, 0.0),
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                                      border: Border.all(
                        color: Colors.yellow, // Set your desired border color
                        width: 2.0, // Set your desired border width
                        ),
                                        ),
                                        child: Image.network(
                                          widget.event.organizer_image!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),      //Padding 

                                //Name
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                0.0, 8.0, 90.0, 0.0),
                                            child: Text(
                                              name!,
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily: 'Outfit',
                                                    color:
                                                        FlutterFlowTheme.of(context)
                                                            .customColor1,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                //Phone and email
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 8.0, 0.0),
                                          child: Icon(
                                            Icons.phone,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 24.0,
                                          ),
                                        ),
                                        Text(
                                          phone!,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium.override(
                                                fontFamily: 'Outfit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .customColor1,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 8.0, 0.0),
                                          child: Icon(
                                            Icons.email,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            size: 24.0,
                                          ),
                                        ),
                                        Text(
                                          email!,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium.override(
                                                  fontFamily: 'Outfit',
                                                  color:
                                                      FlutterFlowTheme.of(context)
                                                          .customColor1,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                            ],
                          ),
                        ),
                      ),

                      //Date & Time
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 20.0, 0.0, 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 20.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 36.0,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                                                  Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 2.0, 0.0, 0.0),
                                      child: Text(
                                        start_time + " - " + end_time,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Outfit',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .customColor1,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 2.0, 0.0, 0.0),
                                      child: Text(
                                        formatTimestamp(start_date) + " - " + formatTimestamp(end_date),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Outfit',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .customColor1,
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

                      //Location                     
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    size: 36,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    address,
                                    maxLines: 3,
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Outfit',
                                          color: FlutterFlowTheme.of(context).customColor1,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //Button : View Ticket
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 16.0, 0.0, 0.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TicketListScreenWidget(event_uid: widget.event.uid!),
                              ),
                            );
                          },
                          text: 'View Ticket',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 55.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primaryText,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
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

                      //Button : View Participant List
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 16.0, 0.0, 16.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ApplicantListScreenWidget(event_uid: widget.event.uid!),
                              ),
                            );
                          },
                          text: 'View Participant List',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 55.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primaryText,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
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
                      //Button :View Feeedback
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 16.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewPage(eventID: widget.event.uid!),
                              ),
                            );
                          },
                          text: 'View Feedback/rating',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 55.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primaryText,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
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

                      //Button :Open/Close
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 0.0, 16.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            changeStatusEvent(status);
                          },
                        text: 'Current Status: ${status == true ? "Active" : "Deactivated"}',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 55.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: status == true
                              ? FlutterFlowTheme.of(context).success // Green color for 'Activate'
                              : FlutterFlowTheme.of(context).error, // Red color for 'Deactivate'
                            textStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color: FlutterFlowTheme.of(context)
                                      .customColor1,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
