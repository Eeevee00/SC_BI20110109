import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'package:getwidget/getwidget.dart';
import 'reviewList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'writeReview.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class ReviewPage extends StatefulWidget {
  final String? eventID;

  const ReviewPage({Key? key, required this.eventID}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

    var user_type;
    var userId;

    @override
    void initState() {
        super.initState();
        getUserType();
    }

    getUserType()async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
            user_type = prefs.getString("user_type");
            userId = prefs.getString('current_user_uid');
            //print(user_type);
        });
    }
    Future<bool> checkReviewDone() async {
      try {
        // Assuming you have a reference to your Firestore instance
        var firestore = FirebaseFirestore.instance;

        // Replace 'events' with the actual name of your events collection
        var eventRef = firestore.collection('event').doc(widget.eventID);

        // Replace 'participant' with the actual name of your participants collection
        var participantRef = eventRef.collection('reviews');

        // Get the document snapshot for the user in the participants collection
        var participantDoc = await participantRef.where('userID', isEqualTo: userId).get();
        print(participantDoc.docs.length);

        // Check if the document exists (i.e., the user is a participant)
        var isParticipant = participantDoc.docs.isNotEmpty;

        return isParticipant;
      } catch (e) {
        print('Error checking participant status: $e');
        return false; // Handle the error according to your needs
      }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            appBar: AppBar(
                backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                iconTheme:
                    IconThemeData(color: FlutterFlowTheme.of(context).primaryText),
                automaticallyImplyLeading: true,
                title: Text(
                    'Event Review',
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
            body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                children: [
                    Padding(
                        padding: EdgeInsets.only(
                            left: 6.0, right: 6.0, bottom: 7.0),
                        child: Container(
                            color: FlutterFlowTheme.of(context).secondaryBackground,
                            child: DefaultTabController(
                            length: 3,
                            child: LimitedBox(
                                maxHeight: MediaQuery.of(context).size.height * 0.79,
                                child: Column(
                                children: <Widget>[
                                    Expanded(
                                    child: Tab1(eventID: widget.eventID),
                                    ),
                                ],
                                ),
                            ),
                            ),
                        ),
                        ),
                    const SizedBox(height: 30),
                    
                ],
            ),
            bottomNavigationBar: BottomAppBar(
                child: Container(
                    decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: (user_type != "admin" && user_type != "superadmin" && user_type != "host") ?
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                        Container(
                            constraints: BoxConstraints(minWidth: 100, maxWidth: 350),
                            child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                            child: FFButtonWidget(
                                onPressed: () async {
                                    var check = await checkReviewDone();

                                    if(check == true){
                                        Alert(
                                            context: context,
                                            type: AlertType.warning,
                                            title: "Write Review",
                                            desc: "Only one review allowed to write per event",
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
                                    }else{
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                            builder: (context) => WriteReview(eventID: widget.eventID),
                                            ),
                                        ).then((value) {
                                            setState(() {});
                                        });
                                    }
                                },
                                text: 'Write Review',
                                options: FFButtonOptions(
                                width: double.infinity,
                                height: 55.0,
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primaryText,
                                textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    fontSize: 4.0,
                                ),
                                elevation: 2.0,
                                borderRadius: BorderRadius.circular(5.0),
                                ),
                            ),
                            ),
                        )
                        ],
                    )
                    :
                    Row(),
                ),
            ),
        );
    }

}