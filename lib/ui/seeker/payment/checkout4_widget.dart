import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'checkout4_model.dart';
export 'checkout4_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../../data/models/ticket_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Checkout4Widget extends StatefulWidget {
  final Ticket ticket;
  final String event_uid;
  final int number_of_ticket;
  const Checkout4Widget({required this.ticket, required this.event_uid, required this.number_of_ticket});

  @override
  _Checkout4WidgetState createState() => _Checkout4WidgetState();
}

class _Checkout4WidgetState extends State<Checkout4Widget> {
  late Checkout4Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  var total = 0;
  var number_of_ticket = 0;
  var ticket_price = 0;
  var title;
  var description;
  var point;
  var host_uid;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => Checkout4Model());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  getTotal(){
    int total = 0;
    total = int.parse(widget.ticket.value!) * widget.number_of_ticket;
    return total.toString();
  }

  Future<void> updateTicketQuantity() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var eventUid = widget.event_uid;
    var ticketUid = widget.ticket.uid;
    var numberOfTickets = widget.number_of_ticket;

    try {
      // Get the current quantity value
      DocumentReference eventDocument = firestore.collection('event').doc(eventUid);
      var documentSnapshot = await eventDocument.collection('ticket').doc(ticketUid).get();
      
      // Ensure the ticket document exists
      if (documentSnapshot.exists) {
        var currentQuantity = documentSnapshot['quantity'] ?? 0; // If quantity does not exist, default to 0

        // Calculate the new quantity
        var newQuantity = currentQuantity - numberOfTickets;

        // Update the quantity in Firestore
        await eventDocument.collection('ticket').doc(ticketUid).update({
          'quantity': newQuantity,
        });
      } else {
        print('Ticket document does not exist');
        // Handle the case where the ticket document does not exist
      }
    } catch (e) {
      print('Error updating ticket quantity: $e');
      // Handle the error as needed
    }
  }

  getHostUid()async{
    String event_uid = widget.event_uid;
    try {
      DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('event')
          .doc(event_uid)
          .get();

      if (eventSnapshot.exists) {
        // Assuming 'organizer_uid' is a field in the 'event' document
        String? organizerUid = eventSnapshot['organizer_uid'];
        return organizerUid;
      } else {
        print('Event not found in Firestore');
        return null;
      }
    } catch (error) {
      print('Error getting organizer UID: $error');
      return null;
    }
  }

  // Get user points from Firestore
Future<int?> getUserPoint(var userUid) async {
  try {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      // Assuming the points field is an integer in your Firestore document
      int? userPoints = userData['points'];
      print('User Points: $userPoints');
      return userPoints;
    } else {
      print('User not found in Firestore');
      return null;
    }
  } catch (error) {
    print('Error getting user points: $error');
    return null;
  }
}

  // Update user points in Firestore by 1000
  Future<void> updateUserPoint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_uid = prefs.getString("current_user_uid");

    try {
      // Get the current user points
      int? currentPoints = await getUserPoint(user_uid);
      String? hostUid = await getHostUid();
      int? currentHostPoints = await getUserPoint(hostUid);

      if (currentPoints != null) {
        // Update user points by 1000
        int updatedPoints = currentPoints + 1000;

        // Update points in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user_uid)
            .update({'points': updatedPoints});

        print('User Points Updated: $updatedPoints');
        sendNotification();
      } else {
        print('Cannot update user points. User not found in Firestore.');
      }

      if (currentHostPoints != null) {
        // Update user points by 1000
        int updatedHostPoints = currentHostPoints + 50;

        // Update points in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(hostUid)
            .update({'points': updatedHostPoints});

        print('User Points Updated: $updatedHostPoints');
        sendNotification2();
      } else {
        print('Cannot update user points. User not found in Firestore.');
      }
    } catch (error) {
      print('Error updating user points: $error');
    }
  }

  sendNotification2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_uid = await getHostUid();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference notificationRef = await firestore
        .collection('users')
        .doc(user_uid)
        .collection('notification')
        .add({
          'title': "Ticket Purchase",
          'content': "Congratulation, One of your event ticket have been purchase. 50 point reward have been credit to your account",
          'timestamp': FieldValue.serverTimestamp(),
          'uid': "", // Leave it empty for now
          'send_to': "user",
          'created_by': "",
          'read': false,
        });

    // Get the auto-generated uid from the notificationRef
    String notificationUid = notificationRef.id;

    // Update the notification document with the correct uid
    await notificationRef.update({'uid': notificationUid});
  }

  sendNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_uid = prefs.getString("current_user_uid");

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference notificationRef = await firestore
        .collection('users')
        .doc(user_uid)
        .collection('notification')
        .add({
          'title': "Ticket Purchase",
          'content': "Thanks for buying event ticket, 1000 points have been credited to your account as a reward",
          'timestamp': FieldValue.serverTimestamp(),
          'uid': "", // Leave it empty for now
          'send_to': "user",
          'created_by': "",
          'read': false,
        });

    // Get the auto-generated uid from the notificationRef
    String notificationUid = notificationRef.id;

    // Update the notification document with the correct uid
    await notificationRef.update({'uid': notificationUid});
  }


  buyTicket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var event_uid = widget.event_uid;
    var user_uid = prefs.getString("current_user_uid");

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot usersQuery = await firestore
          .collection('event')
          .where('uid', isEqualTo: event_uid)
          .get();

      for (QueryDocumentSnapshot userDoc in usersQuery.docs) {
        String docId = userDoc.id;

        DocumentReference participantRef = await firestore
          .collection('event')
          .doc(event_uid)
          .collection('participant')
          .add({
            'no_of_purchase': widget.number_of_ticket.toString(),
            'record_uid': "",
            'ticket_description': widget.ticket.description,
            'ticket_title': widget.ticket.title,
            'ticket_type': widget.ticket.ticket_type,
            'timestamp': FieldValue.serverTimestamp(),
            'uid': user_uid,
            'value_per_ticket': widget.ticket.value,
          });
        String participantDocId = participantRef.id;

        await participantRef.update({
          'record_uid': participantDocId,
        });
        }
        updateUserPoint();

      Alert(
        context: context,
        type: AlertType.success,
        title: "Ticket Purchase",
        desc: "Successfully purchase the ticket, 1000 point will be added to you as a reward",
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: const Color(0xFFEE8B60),
            onPressed: () async {
              await updateTicketQuantity();
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    } catch (error) {
      print('Error: $error');
    } finally {

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

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        iconTheme:
            IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
        automaticallyImplyLeading: true,
        title: Text(
          'Check Out',
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
      body: Align(
        alignment: AlignmentDirectional(0.0, -1.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 24.0),
                child: Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  direction: Axis.horizontal,
                  runAlignment: WrapAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 750.0,
                      ),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4.0,
                            color: Color(0x33000000),
                            offset: Offset(0.0, 2.0),
                          )
                        ],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Cart',
                              style: FlutterFlowTheme.of(context).titleLarge,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 12.0),
                              child: Text(
                                'Below is the list of items in your cart.',
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Outfit',
                                      color: FlutterFlowTheme.of(context)
                                          .customColor1,
                                    ),
                              ),
                            ),
                            ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 12.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 1.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 0.0,
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          offset: Offset(0.0, 1.0),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 4.0, 0.0, 12.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          8.0, 0.0, 4.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        widget.ticket.title!,
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleLarge,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    4.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: RichText(
                                                          textScaleFactor:
                                                              MediaQuery.of(
                                                                      context)
                                                                  .textScaleFactor,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    'Total Ticket: ',
                                                                style:
                                                                    TextStyle(),
                                                              ),
                                                              TextSpan(
                                                                text: widget.number_of_ticket.toString(),
                                                                style:
                                                                    TextStyle(),
                                                              )
                                                            ],
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
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  'RM ' + widget.ticket.value!,
                                                  textAlign: TextAlign.end,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleLarge,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 4.0, 8.0, 12.0),
                                          child: AutoSizeText(
                                            widget.ticket.description!,
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
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
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 1.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxWidth: 430.0,
                      ),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4.0,
                            color: Color(0x33000000),
                            offset: Offset(0.0, 2.0),
                          )
                        ],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Summary',
                              style: FlutterFlowTheme.of(context).titleLarge,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 12.0),
                              child: Text(
                                'Below is a list of your items.',
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: 'Outfit',
                                      color: FlutterFlowTheme.of(context)
                                          .customColor1,
                                    ),
                              ),
                            ),
                            Divider(
                              height: 32.0,
                              thickness: 2.0,
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 12.0),
                                    child: Text(
                                      'Price Breakdown',
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context)
                                                .customColor1,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Base Price' ,
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontFamily: 'Outfit',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .customColor1,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                        Text(
                                          "RM " + widget.ticket.value! + " x" + widget.number_of_ticket.toString(),
                                          textAlign: TextAlign.end,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 8.0, 0.0, 8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'Total',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .titleMedium
                                                  .override(
                                                    fontFamily: 'Outfit',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .customColor1,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "RM " + getTotal(),
                                          style: FlutterFlowTheme.of(context)
                                              .displaySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 24.0, 0.0, 0.0),
                                    child: FFButtonWidget(
                                      onPressed: () async {
                                        await buyTicket();
                                      },
                                      text: 'Pay Now',
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
            ],
          ),
        ),
      ),
    );
  }
}
