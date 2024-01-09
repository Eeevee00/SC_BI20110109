import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'ticket_detail_model.dart';
export 'ticket_detail_model.dart';
import '../../../data/models/ticket_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../edit_ticket/edit_ticket_widget.dart';

import '../../seeker/check_out/check_out_widget.dart';

class TicketDetailWidget extends StatefulWidget {
  final Ticket ticket;
  final String event_uid;
  const TicketDetailWidget({required this.ticket, required this.event_uid});

  @override
  _TicketDetailWidgetState createState() => _TicketDetailWidgetState();
}

class _TicketDetailWidgetState extends State<TicketDetailWidget> {
  late TicketDetailModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  var title;
  var quantity;
  var value;
  var ticket_type;
  var description;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TicketDetailModel());
    title = widget.ticket.title;
    quantity = widget.ticket.quantity;
    value = widget.ticket.value;
    ticket_type = widget.ticket.ticket_type;
    description = widget.ticket.description;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void getTicket() async {
    var event_uid = widget.event_uid;
    var ticket_uid = widget.ticket.uid;

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Assuming 'tickets' is the collection and 'ticket_uid' is the document ID
      DocumentSnapshot ticketDoc = await firestore.doc('/event/$event_uid/ticket/$ticket_uid').get();

      if (ticketDoc.exists) {
        // Access the data from the document
        Map<String, dynamic> ticketData = ticketDoc.data() as Map<String, dynamic>;

        setState(() {
          title = ticketData['title'];
          quantity = ticketData['quantity'];
          value = ticketData['value'];
          ticket_type = ticketData['ticket_type'];
          description = ticketData['description'];
        });
      } else {
        print('Ticket document does not exist');
      }
    } catch (error) {
      print('Error fetching ticket details: $error');
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
            'Ticket Detail',
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
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
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
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      'Ticket',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 18.0,
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
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      title.toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context)
                                                .customColor1,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text(
                                        'Available quantity',
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Outfit',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
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
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      quantity.toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context)
                                                .customColor1,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text(
                                        'Price per ticket',
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Outfit',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
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
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      value.toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context)
                                                .customColor1,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text(
                                        'Ticket Type',
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Outfit',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
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
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      ticket_type.toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context)
                                                .customColor1,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text(
                                        'Description',
                                        style: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              fontFamily: 'Outfit',
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
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
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      description.toString(),
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Outfit',
                                            color: FlutterFlowTheme.of(context)
                                                .customColor1,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 40.0),
                                child: FFButtonWidget(
                                    onPressed: () async {
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                            builder: (context) => CheckOutWidget(ticket: widget.ticket, event_uid: widget.event_uid),
                                            ),
                                        );
                                    },
                                    text: 'Buy Ticket',
                                    options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 50.0,
                                    padding:
                                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    iconPadding:
                                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    textStyle:
                                        FlutterFlowTheme.of(context).titleSmall.override(
                                                fontFamily: 'Outfit',
                                                color: FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                                fontSize: 16.0,
                                            ),
                                    elevation: 3.0,
                                    borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
